<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="g:devices">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device listing</title>
		</head>
		<body>
		<h1>Welcome to the PA geolog Website</h1>
		<br/>
		<p>On this page you can see a list of all devices registered with the service. To view details for a given device simply follow the link for that device.</p>
		<ul>
			<xsl:apply-templates select="g:deviceURL"/> 
		</ul>
		</body>
	</html>
  </xsl:template>

  <xsl:template match="g:deviceURL">
    <li>
	<a href="{text()}"><xsl:value-of select="text()"/></a>
	</li>
  </xsl:template>
</xsl:stylesheet>
