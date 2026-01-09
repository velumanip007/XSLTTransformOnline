const axios = require('axios');
const fs = require('fs');
const path = require('path');

const xsltPath = 'E:\\AntiGravity\\XSLTTransformOnline\\server\\Stylesheet\\camt.111-IVR-SWIFTMX.xslt';
const xmlPath = 'E:\\AntiGravity\\XSLTTransformOnline\\server\\Xml\\BNK21105KHCLMFLG';

async function runTest() {
    try {
        console.log("Reading input files...");
        const xslt = fs.readFileSync(xsltPath, 'utf8');
        const xml = fs.readFileSync(xmlPath, 'utf8');

        console.log(`XSLT Size: ${xslt.length} bytes`);
        console.log(`XML Size: ${xml.length} bytes`);
        console.log("Sending transformation request to http://localhost:3000/api/transform...");

        console.time("Total Request Time");

        const response = await axios.post('http://localhost:3000/api/transform', {
            xml: xml,
            xslt: xslt
        }, {
            maxContentLength: Infinity,
            maxBodyLength: Infinity,
            timeout: 0 // No timeout for client
        });

        console.timeEnd("Total Request Time");

        if (response.data.output) {
            console.log("✅ Transformation Successful");
            console.log("Output Length:", response.data.output.length);
            // console.log("Output Preview:", response.data.output.substring(0, 200));
            fs.writeFileSync('user_test_output.xml', response.data.output);
            console.log("Output saved to user_test_output.xml");
        } else {
            console.log("⚠️ No output received (but no error).");
        }

    } catch (error) {
        console.error("❌ Transformation Failed");
        if (error.response) {
            console.error(`Status: ${error.response.status}`);
            console.error(`Data:`, error.response.data);
        } else {
            console.error(error.message);
        }
    }
}

runTest();
