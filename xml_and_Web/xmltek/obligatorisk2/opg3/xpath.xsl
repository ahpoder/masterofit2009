<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <xsl:text>
Exercise 3.3:
  Number of eggs in recipies also using milk:
    </xsl:text>
	<xsl:value-of select="//rcp:recipe[fn:contains(fn:string-join(rcp:ingredient/@name, ' '), 'milk')]/
								rcp:ingredient[fn:contains(@name, 'egg')]/@amount"/>
  </xsl:template>
</xsl:stylesheet>
