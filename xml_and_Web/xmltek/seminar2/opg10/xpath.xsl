<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <xsl:text>
    1A:</xsl:text>
    <xsl:copy-of select="(//rcp:ingredient)[40]"/>

    <xsl:text> 
    
    1B:</xsl:text>
    <xsl:copy-of select="(//rcp:ingredient)[53]"/>

    <xsl:text> 
    1:</xsl:text>

    <xsl:value-of select="(//rcp:ingredient)[40] eq (//rcp:ingredient)[53] "/>

    <xsl:text> 
    2:</xsl:text>

    <xsl:value-of select="(//rcp:ingredient)[40] = (//rcp:ingredient)[53] "/>

    <xsl:text> 
    3:</xsl:text>

    <xsl:value-of select="(//rcp:ingredient)[40] is (//rcp:ingredient)[53] "/>

    <xsl:text> 
    1A atomized = empty string:</xsl:text>

    <xsl:value-of select="(//rcp:ingredient)[40] = '' "/>

    <xsl:text> 
    1A atomized = ():</xsl:text>

    <xsl:value-of select="(//rcp:ingredient)[40] = () "/>
  </xsl:template>
</xsl:stylesheet>
