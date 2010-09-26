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
<!--[if IE]><script language="javascript" type="text/javascript" src="excanvas.js"></script><![endif]-->
<script language="javascript" type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.jqplot.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/jquery.jqplot.css" />
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
		  case "Location":
			$.jqplot('chartdiv', [[<xsl:for-each select="//g:geolog">[<xsl:value-of select="./k:Point/k:coordinates"/>]<xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>]]);
			break;
		<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
			case &quot;<xsl:value-of select="."/>&quot;:
			$.jqplot('chartdiv',  [[[1, 2],[3,5.12],[5,13.1],[7,33.6],[9,85.9],[11,219.9]]]);
			 
			 
			&lt;!--
			
			--&gt;
			<!--$.jqplot('chartdiv', [[[0,0]
			<xsl:for-each select="//g:geolog/">
				,[<xsl:value-of select="./@dateTime"/>,<xsl:value-of select="./g:readings/g:reading[@id=.]/value"/>]
			</xsl:for-each>
			]]-->
		  <!--$.jqplot('chartdiv', [[[0,0]<xsl:for-each select="//g:geolog/">,[xs:dateTime(<xsl:value-of select="./@dateTime"/>) - xs:dateTime('1970-01-01T00:00:00'),<xsl:value-of select="./k:Point"/>]</xsl:for-each>]]-->
			<!--xsl:for-each select="//g:reading[@id=.]">
				<xsl:value-of select="."/>
			</xsl:for-each-->
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

		<div id="chartdiv" style="height:400px;width:300px; "></div>
		
		<div id="deviceData">
			<xsl:apply-templates select="//readings"/> 
		</div>
		</body>
	</html>
  </xsl:template>
  
</xsl:stylesheet>