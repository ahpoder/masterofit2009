<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns:g="http://www.pa.com/geolog"
								xmlns:k="http://code.google.com/kml21"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

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
		<xsl:apply-templates /> 
	</ul>
	</body>
</html>

	<xsl:template match="/">

    <xsl:text>
    Get geolog elements :
    </xsl:text>
    
    <xsl:value-of select="//g:device/g:geologCollection/g:geolog"/>
    <xsl:text> </xsl:text>

  </xsl:template>
</xsl:stylesheet>
