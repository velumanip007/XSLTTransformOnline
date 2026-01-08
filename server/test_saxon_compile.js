const SaxonJS = require('saxon-js');
const fs = require('fs');

async function testCompile() {
    console.log("Probing SaxonJS compiler...");

    // 1. Get Platform
    const platform = SaxonJS.getPlatform();
    // console.log("Platform keys:", Object.keys(platform));

    try {
        // 2. Try to get compiler resource
        // In xslt3.js: b=platform.resource("compiler");
        // But platform.resource might not be exposed or "compiler" might be internal string map key

        // Let's check if we can simply use the 'xslt3' package logic.
        // The xslt3.js uses: platform.resource("compiler")

        let compilerStylesheet = null;
        if (platform.resource) {
            compilerStylesheet = platform.resource("compiler");
            console.log("Got compiler resource via platform.resource()");
        } else {
            console.log("platform.resource function not found.");
        }

        if (!compilerStylesheet) {
            console.log("Compiler stylesheet is null.");
            return;
        }

        // 3. Try to compile sample XSLT
        const xslt = `<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:template match="/">Root</xsl:template></xsl:stylesheet>`;

        // Emulate xslt3.js compileXSLT function
        // h.destination="application"; h.initialMode="compile-complete";
        // h.templateParams={"Q{}options":{noXPath:!1}};
        // h.stylesheetParams...

        const params = new SaxonJS.XdmMap();
        // xslt3.js puts staticParameters into stylesheetParams
        // h.stylesheetParams.inSituPut(SaxonJS.XS.QName.fromParts("","","staticParameters"),[d]); 
        // d is the options object from CLI.

        const cliOptions = {
            stylesheetFileName: "dummy.xsl", // fake filename
            stylesheetBaseURI: "file:///dummy.xsl",
            // other defaults
        };

        // We can't easily reproduce the XdmMap import without internal access or digging docs.
        // But let's try to just pass simple object params if SaxonJS accepts them.
        // Actually, xslt3.js uses internal XdmMap.

        const options = {
            stylesheetInternal: compilerStylesheet,
            sourceText: xslt,
            destination: "application",
            initialMode: "compile-complete",
            templateParams: {
                "Q{}options": { noXPath: false }
            },
            // stylesheetParams: params // Let's omit this first to see if it changes the error.
        };

        console.log("Current Date:", new Date().toISOString());
        console.log("Attempting transformation (compilation) with updated params...");

        const result = await SaxonJS.transform(options, "async");

        console.log("Transformation result keys:", Object.keys(result));
        if (result.principalResult) {
            console.log("Compilation Successful! SEF generated.");
        } else {
            console.log("No principalResult found.");
        }

    } catch (err) {
        console.error("Error during probe:", err);
    }
}

testCompile();
