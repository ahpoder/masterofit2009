<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <!--Exercise 4 -->
    <xsl:value-of select="fn:sum(for $r in //rcp:ingredient return 
    				   if (fn:contains($r/@name, 'egg')) 
    				     then $r/@amount 
    				   else ()
    				 )"/>

    <xsl:text> </xsl:text>

    <!--Exercise 4 advanced part of the exercise -->
    <xsl:value-of select="fn:sum(for $r in //rcp:ingredient return 
    				   if (fn:contains($r/@name, 'egg')) 
    				     then $r/@amount 
    				   else ()
    				 )"/>

  </xsl:template>
</xsl:stylesheet>
