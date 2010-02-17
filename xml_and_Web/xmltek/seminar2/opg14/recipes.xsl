<xsl:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- This answers bullet 3 -->
<xsl:key name="rel" match="rcp:recipe" use="rcp:title"/>
<!-- End of bullet 3 answer -->
				
  <xsl:template match="rcp:collection">
    <html>
      <head>
        <title><xsl:value-of select="rcp:description"/></title>
        <link href="style.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>
<!-- This answers bullet 1 -->
	    <ul>
	<!-- This answers bullet 2 -->
		  <xsl:apply-templates mode="titles" select="rcp:recipe">
			<xsl:sort select="rcp:title"/>
		  </xsl:apply-templates>
	<!-- End of bullet 2 answer -->
		</ul>
<!-- End of bullet 1 answer -->
        <table border="1">
          <xsl:apply-templates mode="content" select="rcp:recipe"/>
        </table>
      </body>
    </html>
  </xsl:template>

<!-- This answers bullet 1 -->
  <xsl:template mode="titles" match="rcp:recipe">
    <li>
<!-- This answers bullet 3 -->
	  <a href="#{generate-id(key('rel', rcp:title))}">
<!-- End of bullet 3 answer -->
	  <xsl:value-of select="rcp:title"/>
	  </a>
	</li>
  </xsl:template>
<!-- End of bullet 1 answer -->

  <xsl:template mode="content" match="rcp:recipe">
    <tr>
      <td>
<!-- This answers bullet 3 -->
        <a name="{generate-id(.)}"/>
<!-- End of bullet 3 answer -->
        <h1><xsl:value-of select="rcp:title"/></h1>
        <i><xsl:value-of select="rcp:date"/></i>
        <ul><xsl:apply-templates select="rcp:ingredient"/></ul>
        <xsl:apply-templates select="rcp:preparation"/>
        <xsl:apply-templates select="rcp:comment"/>
        <xsl:apply-templates select="rcp:nutrition"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="rcp:ingredient">
    <xsl:choose>
      <xsl:when test="@amount">
        <li>
          <xsl:if test="@amount!='*'">
            <xsl:value-of select="@amount"/>
            <xsl:text> </xsl:text>
            <xsl:if test="@unit">
              <xsl:value-of select="@unit"/>
              <xsl:if test="number(@amount)>number(1)">
                <xsl:text>s</xsl:text>
              </xsl:if>
              <xsl:text> of </xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:value-of select="@name"/>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:value-of select="@name"/></li>
        <ul><xsl:apply-templates select="rcp:ingredient"/></ul>
        <xsl:apply-templates select="rcp:preparation"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rcp:preparation">
    <ol><xsl:apply-templates select="rcp:step"/></ol>
  </xsl:template>

  <xsl:template match="rcp:step">
    <li><xsl:value-of select="node()"/></li>
  </xsl:template>

  <xsl:template match="rcp:comment">
    <ul>
      <li type="square"><xsl:value-of select="node()"/></li>
    </ul>
  </xsl:template>

  <xsl:template match="rcp:nutrition">
    <table border="2">
      <tr>
        <th>Calories</th><th>Fat</th><th>Carbohydrates</th><th>Protein</th>
        <xsl:if test="@alcohol">
          <th>Alcohol</th>
        </xsl:if>
      </tr>
      <tr>
        <td align="right"><xsl:value-of select="@calories"/></td>
        <td align="right"><xsl:value-of select="@fat"/></td>
        <td align="right"><xsl:value-of select="@carbohydrates"/></td>
        <td align="right"><xsl:value-of select="@protein"/></td>
        <xsl:if test="@alcohol">
          <td align="right"><xsl:value-of select="@alcohol"/></td>
        </xsl:if>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
