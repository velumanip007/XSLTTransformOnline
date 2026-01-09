
const axios = require('axios');

const XSLT_SAMPLE = `<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
  <h2>Test</h2>
</xsl:template>
</xsl:stylesheet>`;

async function testCompile() {
    try {
        console.log("Sending Compilation Request...");
        const res = await axios.post('http://localhost:3000/api/compile', {
            xslt: XSLT_SAMPLE
        });

        if (res.status === 200 && res.data.sef) {
            console.log("✅ Compilation Successful: SEF Received");
            console.log("SEF Type:", typeof res.data.sef);
        } else {
            console.error("❌ Compilation Failed:", res.status, res.data);
        }

    } catch (err) {
        console.error("❌ Error:", err.message);
        if (err.response) console.error("Response:", err.response.data);
    }
}

testCompile();
