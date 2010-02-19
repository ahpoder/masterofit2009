<xsl:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:w="http://cs.au.dk/~schwarz/XMLTek"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="w:wiki">
    <html>
      <head>
        <title><xsl:value-of select="@name"/></title>
        <link href="style.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>
				<xsl:apply-templates select="w:header"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="w:header">
	<h1>
		<xsl:apply-templates/>
	</h1>
  </xsl:template>

	<xsl:template match="w:text">
		<xsl:value-of select="text()"/>
  </xsl:template>

  <xsl:template match="w:ws">
	<xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="w:link">
	<xsl:value-of select="text()"/>
  </xsl:template>

	<xsl:template match="w:wikilink">
	  <xsl:value-of select="text()"/>
  </xsl:template>

<!--
	<element name="image" type="anyURI"/>
	<element name="wikilink" type="w:wikilinkType"/>
	<element name="link" type="w:linkType"/>
	<element name="italics" type="w:italicsType"/>
	<element name="tt" type="w:ttType"/>
	<element name="bold" type="w:boldType"/>
	<element name="header" type="w:headerType"/>
	<element name="rule" type="w:ruleType"/>
	<element name="character" type="w:characterType"/>
	<element name="list" type="w:listType"/>
	<element name="br" type="w:brType"/>
	<element name="text" type="w:textType"/>
	<element name="ws" type="w:wsType"/>
-->
</xsl:stylesheet>
