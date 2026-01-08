const express = require('express');
const cors = require('cors');
const fs = require('fs-extra');
const path = require('path');
const { execSync, execFile } = require('child_process');
const util = require('util');
const execFileAsync = util.promisify(execFile);
const SaxonJS = require('saxon-js');
const crypto = require('crypto');
const { Worker } = require('worker_threads');

const app = express();
const PORT = process.env.PORT || 3000;

// In-memory cache for compiled SEF stylesheets
const xsltCache = new Map();

// Initialize XSLT Worker
const xsltWorker = new Worker(path.join(__dirname, 'xslt_worker.js'));
const pendingCompilations = new Map();

xsltWorker.on('message', (msg) => {
    if (msg.type === 'ready') {
        console.log("XSLT Worker is ready and hot.");
        return;
    }
    if (msg.type === 'error') {
        console.error("XSLT Worker Error:", msg.error);
        return;
    }

    // Handle compilation response
    const { id, stdout, stderr, exitCode } = msg;
    if (pendingCompilations.has(id)) {
        const { resolve, reject } = pendingCompilations.get(id);
        pendingCompilations.delete(id);

        if (exitCode === 0) {
            resolve({ stdout, stderr });
        } else {
            reject(new Error(`Worker exited with code ${exitCode}\nStderr: ${stderr}\nStdout: ${stdout}`));
        }
    }
});

xsltWorker.on('error', (err) => {
    console.error("XSLT Worker Thread Error:", err);
});

function compileInWorker(args) {
    return new Promise((resolve, reject) => {
        const id = Date.now().toString() + Math.random();
        pendingCompilations.set(id, { resolve, reject });
        xsltWorker.postMessage({ id, args });
    });
}

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Global error handlers
process.on('uncaughtException', (err) => {
    console.error('UNCAUGHT EXCEPTION:', err);
});
process.on('unhandledRejection', (reason, promise) => {
    console.error('UNHANDLED REJECTION:', reason);
});

// Temp directory for file processing
const TEMP_DIR = path.join(__dirname, 'temp');
fs.ensureDirSync(TEMP_DIR);

/**
 * Endpoint to transform XML using XSLT
 */
app.post('/api/transform', async (req, res) => {
    const { xml, xslt } = req.body;

    if (!xml || !xslt) {
        return res.status(400).json({ error: 'Both XML and XSLT content are required.' });
    }

    const uniqueId = Date.now() + Math.random().toString(36).substring(7);
    const xmlPath = path.join(TEMP_DIR, `${uniqueId}.xml`);
    const xsltPath = path.join(TEMP_DIR, `${uniqueId}.xsl`);
    const sefPath = path.join(TEMP_DIR, `${uniqueId}.sef.json`);

    try {
        // 1. Write content to temporary files
        await fs.writeFile(xmlPath, xml);

        // Check Cache for XSLT
        const xsltHash = crypto.createHash('sha256').update(xslt).digest('hex');
        let sefContent;

        if (xsltCache.has(xsltHash)) {
            console.log("-> Cache HIT for XSLT. Using cached SEF.");
            sefContent = xsltCache.get(xsltHash);
        } else {
            console.log("-> Cache MISS for XSLT. Compiling...");
            await fs.writeFile(xsltPath, xslt);

            console.log("   Compiling XSLT using Worker...");
            console.time("XSLT3 Worker Time");

            try {
                // Use persistent worker
                const { stdout, stderr } = await compileInWorker([
                    `-xsl:${xsltPath}`,
                    `-export:${sefPath}`,
                    '-nogo'
                ]);

                console.timeEnd("XSLT3 Worker Time");

                if (stdout) console.log("   Worker stdout:", stdout);
                if (stderr) console.error("   Worker stderr:", stderr);

            } catch (compileError) {
                console.error("   Compilation Error Details:", compileError);
                throw new Error(`XSLT Compilation Failed: ${compileError.message}`);
            }

            // Read compiled SEF
            sefContent = await fs.readJson(sefPath);
            // Update Cache
            xsltCache.set(xsltHash, sefContent);
        }

        // 3. Transform using SaxonJS
        const result = await SaxonJS.transform({
            stylesheetInternal: sefContent,
            sourceFileName: xmlPath,
            destination: "serialized"
        }, "async");

        // 4. Send result
        res.json({ output: result.principalResult });

    } catch (error) {
        console.error("Transformation Error:", error);
        res.status(500).json({ error: error.message || "An error occurred during transformation." });
    } finally {
        // 5. Cleanup
        try {
            await fs.remove(xmlPath);
            // Only remove XSLT/SEF if they were physically created (Cache MISS)
            // But fs.remove is safe to call even if files don't exist
            await fs.remove(xsltPath);
            await fs.remove(sefPath);
        } catch (cleanupError) {
            console.error("Cleanup Error:", cleanupError);
        }
    }
});

/**
 * Endpoint to validate XML against XSD
 */
app.post('/api/validate', async (req, res) => {
    console.log("-> Received validation request");
    const { xml, xsd } = req.body;

    if (!xml || !xsd) {
        return res.status(400).json({ error: 'Both XML and XSD content are required.' });
    }

    try {
        console.log("   Importing libxml2-wasm...");
        const libxmlModule = await import('libxml2-wasm');
        // Destructure correct exports
        const { XmlDocument, XsdValidator } = libxmlModule;

        console.log("   Parsing XML and XSD...");
        let xmlDoc, xsdDoc, validator;

        try {
            // Use XmlDocument.fromString
            xmlDoc = XmlDocument.fromString(xml);
            xsdDoc = XmlDocument.fromString(xsd);
        } catch (parseError) {
            console.error("   Parse Error:", parseError);
            return res.json({ valid: false, errors: ["XML or XSD Parse Error: " + parseError.message] });
        }

        console.log("   Validating...");
        let isValid = true;
        let validationErrors = [];

        try {
            // Create Validator from XSD Doc
            validator = XsdValidator.fromDoc(xsdDoc);

            // Validate! 
            // If valid: returns void (undefined).
            // If invalid: THROWS XmlValidateError.
            validator.validate(xmlDoc);

            isValid = true;
        } catch (valError) {
            console.error("   Validation Failed (Expected):", valError);
            // valError.details is an array of objects { message, line, col }
            if (valError.details) {
                validationErrors = valError.details.map(d => `Line ${d.line}: ${d.message.trim()}`);
            } else {
                validationErrors = [valError.message];
            }
            isValid = false;
        }

        console.log(`   Validation Result: ${isValid}`);

        // Cleanup
        if (xmlDoc) xmlDoc.dispose();
        if (xsdDoc) xsdDoc.dispose();
        if (validator) validator.dispose();

        res.json({ valid: isValid, errors: validationErrors });

    } catch (error) {
        console.error("!! VALIDATION SERVER ERROR:", error);
        res.status(500).json({ error: error.message || "An error occurred during validation." });
    }
});

// Serve static files from the React app (Client)
// In production, the client build will be in ../client/dist
const clientBuildPath = path.join(__dirname, '../client/dist');
if (fs.existsSync(clientBuildPath)) {
    app.use(express.static(clientBuildPath));
    app.get(/.*/, (req, res) => {
        res.sendFile(path.join(clientBuildPath, 'index.html'));
    });
}

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
