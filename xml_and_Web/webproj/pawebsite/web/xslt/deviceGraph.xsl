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
			<title>PA International device details Graph</title>
			
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

	function graphSelectionChanged() {
		var s = document.getElementById("graphSelect");
		var o = s.options[s.selectedIndex];
		var selected = o.text;
		switch (selected) {
		  case "none":
		  
		    break;
		  case "location":
			<xsl:for-each select="//geolog/">
				<xsl:value-of select="."/>
			</xsl:for-each>
			break;
		<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
			case <xsl:value-of select="."/>:
			<xsl:for-each select="//g:reading[@id=.]">
				<xsl:value-of select="."/>
			</xsl:for-each>
			break;
		</xsl:for-each>
		}
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
		<p>On this page you can see the details for a given sensor or location over time</p>
		Please select the sensor or location to show: 
		<select id="graphSelect" onchange="graphSelectionChanged()">
		  <option value="location">None</option> 
		  <option value="location">Location</option> 
			<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
			<option><xsl:value-of select="."/></option>
			</xsl:for-each>
		</select>

		<div id="deviceData">
			<xsl:apply-templates select="//readings"/> 
		</div>
		</body>
	</html>
  </xsl:template>
  
</xsl:stylesheet>
