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

// Path to xslt3 executable
const xslt3Path = path.resolve(__dirname, 'node_modules', '.bin', 'xslt3');
// Use the cmd shim on Windows? No, typically better to node executable directly if possible, 
// otherwise use the .cmd on windows.
// Let's use the node script directly for better control? 
// The worker used: path.resolve(__dirname, 'node_modules', 'xslt3', 'xslt3.js');
// Let's stick to spawning node with that script.
const xslt3Script = path.resolve(__dirname, 'node_modules', 'xslt3', 'xslt3.js');

/**
 * Helper to run xslt3 CLI in a child process
 */
async function runWithXslt3(args) {
    return new Promise((resolve, reject) => {
        // Increase maxBuffer for large outputs
        // Increase stack size for the child process (16MB Stack)
        execFile(process.execPath, [
            '--stack-size=16384', // 16MB stack
            xslt3Script,
            ...args
        ], { maxBuffer: 1024 * 1024 * 50 }, (error, stdout, stderr) => {
            if (error) {
                // Warning: xslt3 might exit with non-zero but still have useful stderr
                reject(new Error(`Process exited with code ${error.code}\nStderr: ${stderr}\nStdout: ${stdout}`));
            } else {
                resolve({ stdout, stderr });
            }
        });
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
    const outputPath = path.join(TEMP_DIR, `${uniqueId}.out.xml`);

    try {
        // 1. Write content to temporary files
        await fs.writeFile(xmlPath, xml);

        // Check Cache for XSLT
        const xsltHash = crypto.createHash('sha256').update(xslt).digest('hex');
        let sefContent;

        if (xsltCache.has(xsltHash)) {
            console.log("-> Cache HIT for XSLT. Using cached SEF.");
            sefContent = xsltCache.get(xsltHash);
            // We need the file on disk for the CLI tool
            await fs.writeJson(sefPath, sefContent);
        } else {
            console.log("-> Cache MISS for XSLT. Compiling...");
            await fs.writeFile(xsltPath, xslt);

            console.log("   Compiling XSLT using spawned process...");
            console.time("XSLT3 Compile Time");

            try {
                // Compile XSLT to SEF
                await runWithXslt3([
                    `-xsl:${xsltPath}`,
                    `-export:${sefPath}`,
                    '-nogo'
                ]);

                console.timeEnd("XSLT3 Compile Time");

            } catch (compileError) {
                console.error("   Compilation Error Details:", compileError);
                throw new Error(`XSLT Compilation Failed: ${compileError.message}`);
            }

            // Read compiled SEF to cache it
            if (await fs.pathExists(sefPath)) {
                sefContent = await fs.readJson(sefPath);
                xsltCache.set(xsltHash, sefContent);
            } else {
                throw new Error("Compilation failed to produce SEF file.");
            }
        }

        // 3. Transform using spawned process
        console.log("-> Transforming using spawned process...");
        console.time("Transformation Time");

        // CLI: xslt3 -s:source.xml -xsl:stylesheet.sef.json -o:output.xml -nogo
        const { stdout, stderr } = await runWithXslt3([
            `-s:${xmlPath}`,
            `-xsl:${sefPath}`,
            `-o:${outputPath}`,
            `-nogo`
        ]);

        console.timeEnd("Transformation Time");
        if (stderr) console.error("   Transform stderr:", stderr);

        // 4. Send result
        if (await fs.pathExists(outputPath)) {
            const output = await fs.readFile(outputPath, 'utf8');
            res.json({ output });
        } else {
            throw new Error("Transformation failed to produce output file.");
        }

    } catch (error) {
        console.error("Transformation Error:", error);
        res.status(500).json({ error: error.message || "An error occurred during transformation." });
    } finally {
        // 5. Cleanup
        try {
            await Promise.all([
                fs.unlink(xmlPath).catch(() => { }),
                fs.unlink(xsltPath).catch(() => { }),
                fs.unlink(sefPath).catch(() => { }),
                fs.unlink(outputPath).catch(() => { })
            ]);
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

const server = app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
server.timeout = 0; // No timeout
server.keepAliveTimeout = 0; // No keep-alive timeout
