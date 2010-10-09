<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

<!-- This is the second device stylesheet generated and will 
     generate the same table as device.xsl, yet it will also 
	 generate the javascript (JQuery) code to update the table
	 automatically using AJAX -->
				
  <xsl:template match="g:device">
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details AJAX</title>
			
<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<script type="text/javascript">
	var timeout; // This variable is used for changing between http not ready timeout and polling timeout
	
	// This function is called when an AJAX response is reveived
	function serverResponse(data) {
		// Create a new in-memeory div element and set its content to the repsonse.
		// This is needed in order to extract sub-elements from the response.
		var d = document.createElement("div");
		d.innerHTML = data;
		// Extract the first table (there should be only 1)
		var u = d.getElementsByTagName("div");
		// Update the table with the new one. This is done 
		// regardless of whether there are any changes, as
		// It is not visible anyway.
		$('#deviceData').html(u[0].innerHTML);

		// Re-start the timeout
		window.clearTimeout(timeout);
		timeout = window.setTimeout(pollServer, 3000);
	}
	
	// This function uses JQuery to make an AJAX request for new data.
	function pollServer() {
		$.get("http://" + location.host + "/paweb/device", { id: <xsl:value-of select="@id"/> }, serverResponse);
    }
	// Start the poll timer.
	// As the time is long enough that we are sure the document is loaded
	// before the timer expires it is OK, otherwise it should be done in
	// body initialize callback.
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
