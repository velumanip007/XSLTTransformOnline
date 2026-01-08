const { parentPort } = require('worker_threads');
const path = require('path');

// 1. Pre-load SaxonJS to keep it warm in memory
// We don't use it directly here, but requiring it populates the require cache
// so when xslt3.js requires it, it returns instantly.
try {
    require('saxon-js');
    parentPort.postMessage({ type: 'ready' });
} catch (err) {
    parentPort.postMessage({ type: 'error', error: err.message });
}

// Path to xslt3.js
const xslt3Path = path.resolve(__dirname, 'node_modules', 'xslt3', 'xslt3.js');

parentPort.on('message', async (message) => {
    const { id, args } = message;

    if (!id || !args) return; // invalid message

    // Capture output
    let stdout = [];
    let stderr = [];

    // Store original functions
    const originalLog = console.log;
    const originalError = console.error;
    const originalExit = process.exit;
    const originalArgv = process.argv;

    // Mock environment
    let exitCode = 0;

    // Intercept stdout/stderr
    console.log = (...args) => {
        stdout.push(args.map(a => String(a)).join(' '));
    };
    console.error = (...args) => {
        stderr.push(args.map(a => String(a)).join(' '));
    };

    // Mock process.exit
    // xslt3.js calls process.exit() when done or on error.
    // We need to stop it from actually exiting the worker.
    const exitPromise = new Promise((resolve) => {
        process.exit = (code) => {
            exitCode = code || 0;
            resolve();
        };
    });

    // Mock process.argv
    // args should be arrays of strings like ['-xsl:foo.xsl', ...]
    process.argv = [process.execPath, xslt3Path, ...args];

    try {
        // Clear xslt3.js from cache so it re-executes its main function
        delete require.cache[xslt3Path];

        // Execute xslt3.js
        // It runs synchronously or async depending on internal logic, 
        // but it usually calls main() immediately.
        // It might be async internally, but usually ends with process.exit().
        require(xslt3Path);

        // However, looking at xslt3.js source, it does have some async parts (promises).
        // It calls exit() in .then() or .catch().
        // So we wait for exit() to be called.

        // We also need a timeout in case it doesn't call exit (unlikely for CLI but possible)
        const timeoutPromise = new Promise((_, reject) =>
            setTimeout(() => reject(new Error('Worker Timeout')), 60000)
        );

        await Promise.race([exitPromise, timeoutPromise]);

    } catch (err) {
        // If require throws (synchronous error) or timeout
        stderr.push(err.toString());
        exitCode = 1;
    } finally {
        // Restore environment
        console.log = originalLog;
        console.error = originalError;
        process.exit = originalExit;
        process.argv = originalArgv;

        // Send result back
        parentPort.postMessage({
            id,
            stdout: stdout.join('\n'),
            stderr: stderr.join('\n'),
            exitCode
        });
    }
});
