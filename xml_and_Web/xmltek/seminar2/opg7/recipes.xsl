<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:rcp="http://www.brics.dk/ixwt/recipes" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="rcp:collection">
    <html>
      <head>
        <title><xsl:value-of select="rcp:description"/></title>
        <link href="recipes_files/style.css" rel="stylesheet" type="text/css"/>
      </head>
      <script src="recipes_files/injection_graph_func.js" id="injection_graph_func" charset="utf-8"/><script id="_nameHighlight_injection"/><link id="_injection_graph_nh_css" charset="utf-8" rel="stylesheet" type="text/css" href="recipes_files/injection_nh_graph.css" class="skype_name_highlight_style"/><link id="_skypeplugin_dropdownmenu_css" charset="utf-8" rel="stylesheet" type="text/css" href="recipes_files/skypeplugin_dropdownmenu.css"/><body>
        <table border="1">
          <xsl:apply-templates select="rcp:recipe"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="rcp:recipe">
    <tr>
      <td>
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
              <xsl:if test="number(@amount)&gt;number(1)">
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