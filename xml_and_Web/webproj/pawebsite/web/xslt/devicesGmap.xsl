<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="g:devices">
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device listing</title>
		</head>
		<body>
			<h1>Welcome to the PA geolog Website</h1>
			<br/>
			<p>On this page you can see a list of all devices registered with the service. To view details for a given device simply follow the link for that device.</p>
			<p>For debugging purposes there is currently a direct link to the web-service. This link will return an XML document.</p>
			<table border="1">
				<tr>
					<th>Status</th>
					<th>Device ID</th>
					<th>Web-site</th>
					<th>AJAX Web-site</th>
					<th>Graph Web-site</th>
					<th>GMap Web-site</th>
					<th>Web-service</th>
				</tr>
				<xsl:apply-templates mode="table" select="//g:deviceSimple"/> 
    	</table>
    	<br/>
			<a href="devices">
				<xsl:text>Show this information as sent from the web-service</xsl:text>
			</a>
    </body>
	</html>
  </xsl:template>

	<!-- Display each device as a table row. 
				The background color of the status column depends on the status 
				through the class attribute and the CSS stylesheet -->
  <xsl:template mode="table" match="g:deviceSimple">
		<tr>
			<td class="{./@status}"><xsl:value-of select="./@status"/></td>
			<td><xsl:value-of select="@id"/></td> 
			<td><xsl:apply-templates mode="websiteurl" select="."/></td> 
			<td><xsl:apply-templates mode="websiteAJAXurl" select="."/></td> 
			<td><xsl:apply-templates mode="websiteGRAPHurl" select="."/></td> 
			<td><xsl:apply-templates mode="websiteGMAPurl" select="."/></td> 
			<td><xsl:apply-templates select="./g:deviceURL"/></td> 
		</tr>
  </xsl:template>

  <xsl:template mode="websiteurl" match="g:deviceSimple">
			<xsl:apply-templates mode="websiteurl" select="g:deviceURL"/>
  </xsl:template>

  <xsl:template mode="websiteAJAXurl" match="g:deviceSimple">
			<xsl:apply-templates mode="websiteAJAXurl" select="g:deviceURL"/>
  </xsl:template>

  <xsl:template mode="websiteGRAPHurl" match="g:deviceSimple">
			<xsl:apply-templates mode="websiteGRAPHurl" select="g:deviceURL"/>
  </xsl:template>

  <xsl:template mode="websiteGMAPurl" match="g:deviceSimple">
			<xsl:apply-templates mode="websiteGMAPurl" select="g:deviceURL"/>
  </xsl:template>

  <!-- TODO: Can we make this nicer and less brittle? 
							Is it possible to grab the web-site url from in here? -->
  <xsl:template mode="websiteurl" match="g:deviceURL">
		<a href="{concat(substring-before(.,'/geolog/'), '/paweb/device?id=', substring-after(.,'/geolog/devices/'))}">
			<xsl:text>Web-site</xsl:text>
		</a>
  </xsl:template>

  <xsl:template mode="websiteAJAXurl" match="g:deviceURL">
		<a href="{concat(substring-before(.,'/geolog/'), '/paweb/device?id=', substring-after(.,'/geolog/devices/'), '&amp;type=AJAX')}">
			<xsl:text>AJAX Web-site</xsl:text>
		</a>
  </xsl:template>

  <xsl:template mode="websiteGRAPHurl" match="g:deviceURL">
		<a href="{concat(substring-before(.,'/geolog/'), '/paweb/device?id=', substring-after(.,'/geolog/devices/'), '&amp;type=GRAPH')}">
			<xsl:text>Graph Web-site</xsl:text>
		</a>
  </xsl:template>

  <xsl:template mode="websiteGMAPurl" match="g:deviceURL">
		<a href="{concat(substring-before(.,'/geolog/'), '/paweb/device?id=', substring-after(.,'/geolog/devices/'), '&amp;type=GMAP')}">
			<xsl:text>GMap Web-site</xsl:text>
		</a>
  </xsl:template>

  <xsl:template match="g:deviceURL">
		<a href="{.}">
			<xsl:text>Web-service</xsl:text>
		</a>
  </xsl:template>
</xsl:stylesheet>



