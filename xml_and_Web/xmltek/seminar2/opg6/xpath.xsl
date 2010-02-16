<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <xsl:text>
    Exercise 1:
    </xsl:text>
    
    <xsl:value-of select="//rcp:recipe[3]//rcp:ingredient[@name='olive oil']/@amount"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="//rcp:recipe[3]//rcp:ingredient[@name='olive oil']/@unit"/>

    <xsl:text>
    Exercise 2:
    </xsl:text>
    
    <xsl:value-of select="//rcp:recipe[rcp:title/text()='Ricotta Pie']//rcp:ingredient[@name='eggs']/@amount"/>
    <xsl:text> eggs</xsl:text>

    <xsl:text>
    Exercise 3:
    </xsl:text>
    <xsl:value-of select="//rcp:recipe[@id='r105']//rcp:title/text()"/>
    <!-- The solution below does not return the expected result. Why? -->
    <xsl:value-of select="//fn:id('r105')/rcp:title/text()"/>

    <!--Exercise 4 advanced part of the exercise -->
    <xsl:text>
    Exercise 4:
    </xsl:text>
    <xsl:value-of select="fn:sum(for $r in //rcp:ingredient return 
    				   if (fn:contains($r/@name, 'egg')) 
    				     then $r/@amount 
    				   else ()
    				 )"/>

  </xsl:template>
</xsl:stylesheet>
