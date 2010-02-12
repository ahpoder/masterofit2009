<xsl:stylesheet version="2.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    
  </xsl:template>
  
  <xsl:template match="rcp:description">
    <a/>
    <xsl:value-of select="text()"/>
  </xsl:template>

</xsl:stylesheet>