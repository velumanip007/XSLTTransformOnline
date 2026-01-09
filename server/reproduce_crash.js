
const fs = require('fs-extra');
const path = require('path');
const { execFile } = require('child_process');

const xslt3Script = path.resolve(__dirname, 'node_modules', 'xslt3', 'xslt3.js');
const tempDir = path.join(__dirname, 'temp_debug');
fs.ensureDirSync(tempDir);

// Read User Data
const xmlPath = path.join(__dirname, 'Xml', 'BNK21105KHCLMFLG');
const xsltPath = path.join(__dirname, 'Stylesheet', 'camt.111-IVR-SWIFTMX.xslt');
const debugXmlPath = path.join(tempDir, 'debug.xml');
const debugXsltPath = path.join(tempDir, 'debug.xslt');
const sefPath = path.join(tempDir, 'debug.sef.json');
const outputPath = path.join(tempDir, 'output.xml');

async function run() {
    console.log("Preparing debug files...");
    await fs.copy(xmlPath, debugXmlPath);
    await fs.copy(xsltPath, debugXsltPath);

    console.log("Running XSLT3 with -t (Trace)...");

    // Limits: 4GB Heap, 64MB Stack
    const args = [
        '--stack-size=65536',
        '--max-old-space-size=4096',
        xslt3Script,
        `-s:${debugXmlPath}`,
        `-xsl:${debugXsltPath}`,
        `-o:${outputPath}`,
        `-t`, // Trace
        `-nogo`
    ];

    const child = execFile(process.execPath, args, {
        maxBuffer: 1024 * 1024 * 50 // 50MB buffer
    }, (error, stdout, stderr) => {
        if (stderr) {
            console.log("--- STDERR (TRACE TAIL) ---");
            const lines = stderr.split('\n');
            // Print last 50 lines to see where it crashed
            console.log(lines.slice(-50).join('\n'));
        }
        if (stdout) {
            console.log("--- STDOUT (TAIL) ---");
            const lines = stdout.split('\n');
            console.log(lines.slice(-20).join('\n'));
        }
        if (error) {
            console.error("Process exited with code:", error.code);
        } else {
            console.log("Success!");
        }
    });
}

run();
