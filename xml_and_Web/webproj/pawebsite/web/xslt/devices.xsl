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
			<table border="1">
				<tr>
					<th>Status</th>
					<th>Device</th>
				</tr>
				<xsl:apply-templates select="//g:deviceSimple"/> 
    	</table>
    </body>
	</html>
  </xsl:template>

	<!-- Display each device as a table row. The background color of the status column depends on the status -->
  <xsl:template match="g:deviceSimple">
		<tr>
			<xsl:choose>
				<xsl:when test="compare('OK', ./g:status/text())=0">
					<td bgcolor="green"><xsl:value-of select="./g:status"/></td>
				</xsl:when>
				<xsl:when test="compare('ERROR', ./g:status/text())=0">
					<td bgcolor="red"><xsl:value-of select="./g:status"/></td>
				</xsl:when>
				<xsl:otherwise>
					<td bgcolor="yellow"><xsl:value-of select="./g:status"/></td>
				</xsl:otherwise>
			</xsl:choose>
			<td><xsl:apply-templates select="./g:deviceURL"/></td> 
		</tr>
  </xsl:template>

  <xsl:template match="g:deviceURL">
		<a href="{concat(substring-before(.,'/geolog/'), '/paweb/device?id=', substring-after(.,'/geolog/devices/'))}">
			<xsl:text>Device with ID </xsl:text><xsl:value-of select="substring-after(.,'/geolog/devices/')"/>
		</a>
  </xsl:template>
</xsl:stylesheet>



