<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">
<!-- This is the first device stylesheet generated and will simply
     generate a list of all readings for all sensors in a table. -->

	<xsl:template match="g:device">
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details</title>
		</head>
		<body>
		<h1>Welcome to the PA geolog device details for device with ID: <xsl:value-of select="@id"/></h1>
		<br/>
		<p>On this page you can see the details of the selected device</p>
		<div id="deviceData">
		<table border="1">
			<tr>
				<th>DateTime</th>
				<th>Status</th>
				<!-- iterate the unique reading's id and create a table heading for each -->
				<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
					<th><xsl:value-of select="."/></th>
				</xsl:for-each>
			</tr>
			<!-- Apply the template to generate the actual table of data -->
			<xsl:apply-templates mode="table" select="//g:geolog"/> 
		</table>
		</div>
		</body>
	</html>
  </xsl:template>

  <!-- Format a geolog entry for display in a table 
  			One geolog will become one row in the table -->
  <xsl:template mode="table" match="g:geolog">
		<tr>  	
    	<td><xsl:value-of select="./@dateTime"/></td>
			<xsl:apply-templates mode="table" select="g:status"/> 
			<xsl:apply-templates mode="table" select=".//g:reading"/> 
		</tr>
  </xsl:template>
  
  <!-- Format the status for display in a table 
  			Cell color will depend on the status value -->
  <xsl:template mode="table" match="g:status">
		<td class="{.}"><xsl:value-of select="."/></td>
  </xsl:template>

  <!-- Format a reading for display in a table -->
  <xsl:template mode="table" match="g:reading">
   	<td><xsl:value-of select="./g:value"/><text> </text><xsl:value-of select="./g:unit"/></td>
  </xsl:template>
  
</xsl:stylesheet>
