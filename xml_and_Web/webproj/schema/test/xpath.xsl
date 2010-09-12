<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns:g="http://www.pa.com/geolog"
								xmlns:k="http://code.google.com/kml21"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <xsl:text>
    Get geolog elements :
    </xsl:text>
    
    <xsl:value-of select="//g:device/g:geologCollection/g:geolog"/>
    <xsl:text> </xsl:text>

  </xsl:template>
</xsl:stylesheet>
