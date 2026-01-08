const express = require('express');
const cors = require('cors');
const fs = require('fs-extra');
const path = require('path');
const { execSync } = require('child_process');
const SaxonJS = require('saxon-js');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

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
        // We use the locally installed xslt3 executable from node_modules
        const xslt3Path = path.resolve(__dirname, 'node_modules', '.bin', 'xslt3');
        // On Windows, it might be xslt3.cmd
        const xslt3Cmd = process.platform === 'win32' ? `${xslt3Path}.cmd` : xslt3Path;

        const compileCommand = `"${xslt3Cmd}" -xsl:"${xsltPath}" -export:"${sefPath}" -nogo`;

        try {
            execSync(compileCommand);
        } catch (compileError) {
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
