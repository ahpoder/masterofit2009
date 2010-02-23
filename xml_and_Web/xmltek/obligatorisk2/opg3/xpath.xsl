<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <xsl:text>
All ingredients:
    </xsl:text>
	<xsl:value-of select="for $r in //rcp:recipe return fn:concat(fn:string-join($r/rcp:ingredient/@name, ' '), '|')"/>

    <xsl:text>
All ingredients with milk:
    </xsl:text>
	<xsl:value-of select="for $r in //rcp:recipe return 
							if (fn:contains(fn:string-join($r/rcp:ingredient/@name, ' '), 'milk')) then
								fn:concat(fn:string-join($r/rcp:ingredient/@name, ' '), '|')
							else
								()"/>

    <xsl:text>
All ingredients with milk and egg:
    </xsl:text>
	<xsl:value-of select="for $r in //rcp:recipe return 
							if (fn:contains(fn:string-join($r/rcp:ingredient/@name, ' '), 'milk')) then
								if (fn:contains(fn:string-join($r/rcp:ingredient/@name, ' '), 'egg')) then
									fn:concat(fn:string-join($r/rcp:ingredient/@name, ' '), '|')
								else
									()
							else
								()"/>

    <xsl:text>
Exercise 3.3:
  Number of eggs in recipies also using milk:
    </xsl:text>
	<xsl:value-of select="for $r in //rcp:recipe return 
							if (fn:contains(fn:string-join($r/rcp:ingredient/@name, ' '), 'milk')) then
								if (fn:contains(fn:string-join($r/rcp:ingredient/@name, ' '), 'egg')) then
									$r/rcp:ingredient[fn:contains(@name, 'egg')]/@amount
								else
									()
							else
								()"/>




    <xsl:text>
Exercise 3.3:
  PMD: another solution for the number of eggs in recipies also using milk:
    </xsl:text>
	<xsl:value-of select="//rcp:ingredient[fn:contains(@name,'milk')]/../rcp:ingredient[fn:contains(@name,'egg')]/@amount"/>



	</xsl:template>
</xsl:stylesheet>
