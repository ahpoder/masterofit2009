<xsl:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:w="http://cs.au.dk/~schwarz/XMLTek"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fn="http://www.w3.org/2005/xpath-functions">

  <xsl:template match="w:wiki">
    <html>
      <head>
        <title><xsl:value-of select="@name"/></title>
        <link href="style.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>
		<xsl:apply-templates/>
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

  <xsl:template match="w:br">
	<xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="w:link">
	<a href="{@url}"><xsl:value-of select="@word"/></a>
  </xsl:template>

	<xsl:template match="w:wikilink">
		<xsl:element name="a">
			<xsl:if test="fn:exists(@wiki)">
				<xsl:attribute name="href" select="@wiki"/>
			</xsl:if>
			<xsl:value-of select="@word"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="w:bold">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="w:italics">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="w:tt">
		<pre>
			<xsl:apply-templates/>
		</pre>
	</xsl:template>

	<xsl:template match="w:image">
		<img src="{@url}"/>
	</xsl:template>

	<xsl:template match="w:rule">
		<hr/>
	</xsl:template>

	<xsl:template match="w:character">
		<!-- TODO Translate -->
	</xsl:template>

	<xsl:template match="w:list">
		<ul>
			<xsl:apply-templates select="w:item"/>
		</ul>
	</xsl:template>

	<xsl:template match="w:item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>
	
	<xsl:template match="text()">
	</xsl:template>

</xsl:stylesheet>
