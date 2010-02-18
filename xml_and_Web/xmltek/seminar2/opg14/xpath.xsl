<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="rcp:collection">
     <xsl:text>
     </xsl:text>
    <xsl:apply-templates select="rcp:recipe"/>
  </xsl:template>

  <xsl:template match="rcp:recipe">
     <xsl:value-of select="rcp:title"/>
     <!-- Use the // construct to also get the nested preparation elements -->
    <xsl:apply-templates mode="points" select=".//rcp:preparation"/>
     <xsl:text>
     </xsl:text>
  </xsl:template>
  
  <xsl:function name="points">
    <xsl:param name="p"/>
    <xsl:value-of select="fn:string-length(.)"/>
  </xsl:function>
  
  <xsl:template name="npoints">
         <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template mode="points" match="rcp:preparation">
     <!-- P: Number of sentences (number of points) -->
     <xsl:analyze-string select="." regex="\.">
       <xsl:matching-substring>
         <xsl:value-of select="."/>
       </xsl:matching-substring>
     </xsl:analyze-string>
  </xsl:template>

  <xsl:template match="rcp:preparation">
     <xsl:text> LIX=</xsl:text>


     <!-- W: Number of words in the text -->
     <xsl:analyze-string select="." regex="\s[a-zA-Z]+\s">
       <xsl:matching-substring>
         W=<xsl:value-of select="."/>
       </xsl:matching-substring>
     </xsl:analyze-string>
     
     <!-- L: Number of words with more than 6 characters -->
     <xsl:analyze-string select="." regex="\s[a-zA-Z]{{7,}}\s">
       <xsl:matching-substring>
         L=<xsl:value-of select="."/>
       </xsl:matching-substring>
     </xsl:analyze-string>
     <!-- LIX=W/P + 100*L/W -->
  </xsl:template>

</xsl:stylesheet>
