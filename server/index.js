const express = require('express');
const cors = require('cors');
const fs = require('fs-extra');
const path = require('path');
const { execSync, execFile } = require('child_process');
const util = require('util');
const execFileAsync = util.promisify(execFile);
const SaxonJS = require('saxon-js');

const app = express();
const PORT = process.env.PORT || 3000;

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
        await fs.writeFile(xsltPath, xslt);

        // 2. Compile XSLT to SEF using xslt3 command line tool
        // We execute xslt3.js directly to avoid permission issues with .cmd shims
        const xslt3JsPath = path.resolve(__dirname, 'node_modules', 'xslt3', 'xslt3.js');

        console.log("Compiling XSLT using:", xslt3JsPath);

        try {
            // using execFile (async) to avoid blocking and shell
            const { stdout, stderr } = await execFileAsync(process.execPath, [
                xslt3JsPath,
                `-xsl:${xsltPath}`,
                `-export:${sefPath}`,
                '-nogo'
            ], { timeout: 30000 }); // 30s timeout

            if (stdout) console.log("XSLT3 stdout:", stdout);
            if (stderr) console.error("XSLT3 stderr:", stderr);

        } catch (compileError) {
            console.error("Compilation Error Details:", compileError);
            // If compilation fails, read the stderr/stdout if available or just return the error message
            throw new Error(`XSLT Compilation Failed: ${compileError.message}\n${compileError.stdout ? compileError.stdout.toString() : ''}`);
        }

        // 3. Transform using SaxonJS
        const sefContent = await fs.readJson(sefPath);

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
