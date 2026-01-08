<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <div id="cd-collection">
      <h1>My CD Collection</h1>
      <table border="1">
        <tr>
          <th>Title</th>
          <th>Artist</th>
          <th>Year</th>
        </tr>
        <xsl:for-each select="collection/cd">
          <tr>
            <td><xsl:value-of select="title"/></td>
            <td><xsl:value-of select="artist"/></td>
            <td><xsl:value-of select="year"/></td>
          </tr>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>
