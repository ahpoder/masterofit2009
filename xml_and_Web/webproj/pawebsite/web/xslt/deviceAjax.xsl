<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="g:device">
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details AJAX</title>
			
<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<script type="text/javascript">
	var timeout; // This variable is used for changing between http not ready timeout and polling timeout
	
	// This function can be reused by both send chat and poll
	function serverResponse(data) {
		// Create a new in-memeory div element and set its content to the repsonse.
		// This is needed in order to extract sub-elements from the response.
		var d = document.createElement("div");
		d.innerHTML = data;
		// Extract the first table (there should be only 1)
		var u = d.getElementsByTagName("div");
		$('#deviceData').html(u[0].innerHTML);

		// Re-start the timeout
		window.clearTimeout(timeout);
		timeout = window.setTimeout(pollServer, 3000);
	}
	
	function pollServer() {
		$.get("http://" + location.host + "/paweb/device", { id: <xsl:value-of select="@id"/> }, serverResponse);
    }
	// Start the poll timer (maybe we should check for document ready???)
	timeout = window.setTimeout(pollServer, 3000);
</script>

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
				<th>sensor1</th> <!-- How do we iterate sensors? Get unique sensorids ... -->
			</tr>
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
		<!--
		<xsl:choose>
			<xsl:when test="fn:compare('OK', .)=0">
				<td bgcolor="green"><xsl:value-of select="."/></td>
			</xsl:when>
			<xsl:when test="fn:compare('ERROR', ./text())=0">
				<td bgcolor="red"><xsl:value-of select="."/></td>
			</xsl:when>
			<xsl:otherwise>
				<td bgcolor="yellow"><xsl:value-of select="."/></td>
			</xsl:otherwise>
		</xsl:choose>
		-->
  </xsl:template>

  <!-- Format a reading for display in a table -->
  <xsl:template mode="table" match="g:reading">
   	<td><xsl:value-of select="./g:value"/><text> </text><xsl:value-of select="./g:unit"/></td>
  </xsl:template>
  
</xsl:stylesheet>
