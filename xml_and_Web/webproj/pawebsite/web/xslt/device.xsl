<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="g:device">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details</title>
		</head>
		<body>
		<h1>Welcome to the PA geolog device details for device with ID: <xsl:apply-templates select="./@id"/></h1>
		<br/>
		<p>On this page you can see the details about the select device</p>
		<table border="1">
			<tr><td>ID</td><td><xsl:apply-templates select="./@id"/></td></tr>
		</table>
		</body>
	</html>
  </xsl:template>

  <xsl:template match="./@id">
    <xsl:value-of select="text()"/>
  </xsl:template>
</xsl:stylesheet>
