<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">


<xsl:template match="//student">
    <xsl:if test="fn:count(./major) ge 2">
      <double xsl:exclude-result-prefixes="#all">
         <xsl:value-of select="./name/text()"/>
      </double>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
