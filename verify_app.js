const axios = require('axios');
const { exec } = require('child_process');
const path = require('path');

// Start the server
const serverProcess = exec('node index.js', { cwd: path.join(__dirname, 'server') });

serverProcess.stdout.on('data', (data) => console.log(`Server: ${data}`));
serverProcess.stderr.on('data', (data) => console.error(`Server Error: ${data}`));

const XML_SAMPLE = `<?xml version="1.0" encoding="UTF-8"?>
<catalog>
  <cd>
    <title>Empire Burlesque</title>
    <artist>Bob Dylan</artist>
    <country>USA</country>
    <company>Columbia</company>
    <price>10.90</price>
    <year>1985</year>
  </cd>
</catalog>`;

const XSLT_SAMPLE = `<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
  <h2>My CD Collection</h2>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th style="text-align:left">Title</th>
      <th style="text-align:left">Artist</th>
    </tr>
    <xsl:for-each select="catalog/cd">
    <tr>
      <td><xsl:value-of select="title"/></td>
      <td><xsl:value-of select="artist"/></td>
    </tr>
    </xsl:for-each>
  </table>
</xsl:template>
</xsl:stylesheet>`;

// Wait for server to start
setTimeout(async () => {
  try {
    console.log("Sending transformation request...");
    const response = await axios.post('http://localhost:3000/api/transform', {
      xml: XML_SAMPLE,
      xslt: XSLT_SAMPLE
    });

    console.log("Transformation Result:");
    console.log(response.data.output);

    if (response.data.output.includes("My CD Collection") && response.data.output.includes("Bob Dylan")) {
      console.log("\n✅ VERIFICATION SUCCESSFUL");
    } else {
      console.log("\n❌ VERIFICATION FAILED: Output did not match expected content.");
    }
  } catch (error) {
    console.error("Verification Error:", error.response?.data || error.message);
  } finally {
    serverProcess.kill();
    process.exit();
  }
}, 10000);
