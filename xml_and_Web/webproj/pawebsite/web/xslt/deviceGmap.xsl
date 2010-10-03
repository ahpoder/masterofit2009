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
	var latlng = new google.maps.LatLng(!!CENTER_LATTITUDE!!, !!CENTER_LONGITUDE!!);
    var myOptions = {
      zoom: !!CENTER_ZOOM!!,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("gmapData"),
        myOptions);
		
	<xsl:variable name="deviceID" select="./@id"/>
<!-- This will show the coordinates as a marker -->
	<xsl:for-each select="//g:geolog">
		<xsl:if test="position()=last()">	
		  var image = new google.maps.MarkerImage('img/green-dot.png',
		  // This marker is 32 pixels wide by 32 pixels tall.
		  new google.maps.Size(32, 32),
		  // The origin for this image is 0,0.
		  new google.maps.Point(0,0),
		  // The anchor for this image is the base of the flagpole at 0,32.
		  new google.maps.Point(16, 32));

			var marker = new google.maps.Marker({
				  position: new google.maps.LatLng(<xsl:value-of select="./k:Point/k:coordinates"/>),
				  map: map, 
			<xsl:if test="./g:status='OK'">
				  icon: image,
			</xsl:if>
				  title:"<xsl:value-of select="$deviceID"/>"
				});

			var contentString = '<div id="test">' +
			                    'Device: <xsl:value-of select="$deviceID"/>' +
								'<br/>' +
								'Status: <xsl:value-of select="./g:status"/>' +
								'<br/>' +
								'<a href="device?id={$deviceID}&amp;type=graph">Show readings</a>' +
								'</div>';

			var infowindow = new google.maps.InfoWindow({
				content: contentString
			});

			google.maps.event.addListener(marker, 'click', function() {
			  infowindow.open(map,marker);
			});
		</xsl:if>
	</xsl:for-each>

<!-- This will draw the poly-line -->
  var movementCoordinates = [
	<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
		new google.maps.LatLng(<xsl:value-of select="."/>)
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