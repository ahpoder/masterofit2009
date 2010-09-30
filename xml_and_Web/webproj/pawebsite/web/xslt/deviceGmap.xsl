<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">
  
  <xsl:import href="date.xsl" />
  
	<xsl:function name="getTokens" as="xs:string+">
		<xsl:param name="str" as="xs:string" />
		<xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
			<xsl:matching-substring>
			<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")' />
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:function>

  <xsl:template match="g:device">
	<!--
	<!DOCTYPE html>
	-->
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details Graph</title>
			
<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<!--[if IE]><script language="javascript" type="text/javascript" src="excanvas.js"></script><![endif]-->
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false&amp;language=da"></script>
<script type="text/javascript">
	var timeout; // This variable is used for changing between http not ready timeout and polling timeout
	
  function initialize() {
    
<!-- Experiments for determining min and max lattitude and longitude	
	
	!!ALL_LATTITUDES_START!!
<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
	<xsl:variable name="cdiantes" select="getTokens(.)" as="xs:string+" />
	// cdiantes[0] - lattitude
	// cdiantes[1] - longitude
	<xsl:value-of select="$cdiantes[0]"/>
	<xsl:if test="position()!=last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:for-each>
	!!ALL_LATTITUDES_END!!

	!!ALL_LONGITUDE_START!!
<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
	<xsl:variable name="cdiantes" select="getTokens(.)" as="xs:string+" />
	// cdiantes[0] - lattitude
	// cdiantes[1] - longitude
	<xsl:value-of select="$cdiantes[1]"/>
	<xsl:if test="position()!=last()">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:for-each>
	!!ALL_LONGITUDE_END!!

	<xsl:for-each select="$elemNames">
		<xsl:variable name="pos" select="position()" />
		<elem name="{.}">
		<xsl:value-of select="$lineItems[$pos]" />
		</elem>
	</xsl:for-each>

	<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
		<xsl:variable name="cdiantes" select="getTokens(.)" as="xs:string+" />
		// cdiantes[0] - lattitude
		// cdiantes[1] - longitude
		
	<xsl:variable name="minLatLocation">
		<xsl:for-each select="event">
			<xsl:sort select="@date" data-type="text" order="ascending" />
			<xsl:if test="position() = 1">
				<xsl:value-of select="@date" />
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="maxEventDate">
	<xsl:for-each select="event">
	<xsl:sort select="@date" data-type="text" order="descending" />
	<xsl:if test="position() = 1">
	<xsl:value-of select="@date" />
	</xsl:if>
	</xsl:for-each>
	</xsl:variable>

-->

	var latlng = new google.maps.LatLng(!!CENTER_LATTITUDE!!, !!CENTER_LONGITUDE!!);
    var myOptions = {
      zoom: !!CENTER_ZOOM!!,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("gmapData"),
        myOptions);
			
<!-- This will show the coordinates as a marker -->
	<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
		<xsl:if test="position()=last()">
			new google.maps.Marker({
				  position: new google.maps.LatLng(<xsl:value-of select="."/>),
				  map: map, 
				  title:"Hello World!"
				});
		</xsl:if>
	</xsl:for-each>

<!-- This will draw the poly-line -->
  var movementCoordinates = [
	<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
		new google.maps.LatLng(<xsl:value-of select="."/>),
		<xsl:if test="position()!=last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:for-each>
   ];
	var movementPath = new google.maps.Polyline({
		path: movementCoordinates,
		strokeColor: "#FF0000",
		strokeOpacity: 1.0,
		strokeWeight: 2
	});

	movementPath.setMap(map);

  }

	// This function can be reused by both send chat and poll
	function serverResponse(data) {
		// Create a new in-memeory div element and set its content to the repsonse.
		// This is needed in order to extract sub-elements from the response.
		var d = document.createElement("div");
		d.innerHTML = data;
		// Extract the first table (there should be only 1)
		var u = d.getElementsByTagName("div");
		//$('#deviceData').html(u[0].innerHTML);

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
		<body onload="initialize()">
		<h1>Welcome to the PA geolog device details for device with ID: <xsl:value-of select="@id"/></h1>
		<br/>
		<p>On this page you can see the details for a given device</p>
		
		<div id="gmapData" style="width:600px; height:500px"></div>
		</body>
	</html>
  </xsl:template>
  
</xsl:stylesheet>