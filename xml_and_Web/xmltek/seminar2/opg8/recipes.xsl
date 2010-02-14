<xsl:stylesheet version="2.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Remove all attributes -->
  <xsl:template priority="1" match="node()">
    <xsl:copy>
    	<xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- All text changed to capital letters -->
  <xsl:template priority="2" match="text()">
      <xsl:value-of select="upper-case(.)"/>
  </xsl:template>

  <!-- Add a comment to all ingredient elements -->
  <xsl:template priority="3" match="rcp:ingredient">
    <xsl:comment select="'ingredient'"/>
    <xsl:copy>
    	<xsl:apply-templates select="node()"/>
    </xsl:copy>  
  </xsl:template>

</xsl:stylesheet>