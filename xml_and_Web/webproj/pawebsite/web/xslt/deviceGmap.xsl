<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">
  
  <!--
  				xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
-->
  <!--xsl:import href="date.xsl" /-->
  
	<xsl:function name="g:getTokens" as="xs:string+">
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
	
	var map;
	var polylinePath; // Used to update the current polyline
	var variableDefinitionString; // holder stirng to allow easy comparison as document is not updated
	<xsl:variable name="deviceID" select="./@id"/>
<!-- This will show the coordinates as a marker -->
/*!!!VAR_DEF_START!!!*/
	// Need to extract the coordinates, as the KML order is opposite the LatLng order
	<xsl:for-each select="//g:geolog">
		<xsl:if test="position()=last()">	
			currentMarkerPosition = new google.maps.LatLng(<xsl:value-of select="fn:substring-after(./k:Point/k:coordinates,',')"/>, <xsl:value-of select="fn:substring-before(./k:Point/k:coordinates,',')"/>);
		</xsl:if>
	</xsl:for-each>

	currentMarker = new google.maps.Marker({
		  position: currentMarkerPosition,
	<xsl:choose>
			<xsl:when test="./g:status='OK'">
		  icon: "img/map_pin_OK.png",
		  </xsl:when>
			<xsl:when test="./g:status='ERROR'">
		  icon: "img/map_pin_ERROR.png",
		  </xsl:when>
			<xsl:otherwise>
		  icon: "img/map_pin_DISCONNECTED.png",
		  </xsl:otherwise>
	</xsl:choose>
		  title:"<xsl:value-of select="$deviceID"/>"
		});

		contentString = '<div id="test">' +
						'Device: <xsl:value-of select="$deviceID"/>' +
						'<br/>' +
						'Status: <xsl:value-of select="./g:status"/>' +
						'<br/>' +
						'<a href="device?id={$deviceID}&amp;type=graph">Show readings</a>' +
						'</div>';

    movementCoordinates = [
		<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
			new google.maps.LatLng(<xsl:value-of select="fn:substring-after(.,',')"/>, <xsl:value-of select="fn:substring-before(.,',')"/>)
			<xsl:if test="position()!=last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		];
/*!!!VAR_DEF_SLUT!!!*/
	
  function initialize() {
	var latlng = new google.maps.LatLng(!!CENTER_LATTITUDE!!, !!CENTER_LONGITUDE!!);
    var myOptions = {
      zoom: !!CENTER_ZOOM!!,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("gmapData"),
        myOptions);
		
	<xsl:for-each select="//g:geolog">
		<xsl:if test="position()=last()">	
		  var image = new google.maps.MarkerImage('img/green-dot.png',
		  // This marker is 32 pixels wide by 32 pixels tall.
		  new google.maps.Size(32, 32),
		  // The origin for this image is 0,0.
		  new google.maps.Point(0,0),
		  // The anchor for this image is the base of the flagpole at 0,32.
		  new google.maps.Point(16, 32));

		  currentMarker.setMap(map);
		  
          var infowindow = new google.maps.InfoWindow({
				content: contentString
			});

			google.maps.event.addListener(currentMarker, 'click', function() {
			  infowindow.open(map,currentMarker);
			});
		</xsl:if>
	</xsl:for-each>

<!-- This will draw the poly-line -->
	polylinePath = new google.maps.Polyline({
		path: movementCoordinates,
		strokeColor: "#FF0000",
		strokeOpacity: 1.0,
		strokeWeight: 2
	});

	polylinePath.setMap(map);
	
	var myString = document.documentElement.innerHTML;
	myString = myString.replace(/\n/g,'\uffff');
	var myRegexp = new RegExp("/\\*!!!VAR_DEF_START!!!\\*/(.*?)/\\*!!!VAR_DEF_SLUT!!!\\*/");
	var match = myRegexp.exec(myString);
	variableDefinitionString = match[1].replace(/\uffff/g,'\n');
  }

	// This function can be reused by both send chat and poll
	function serverResponse(data) {
		var tempPosition = currentMarkerPosition;
		
		// Extract the new variables as a string
		var myString = data;
		myString = myString.replace(/\n/g,'\uffff');
		var myRegexp = new RegExp("/\\*!!!VAR_DEF_START!!!\\*/(.*?)/\\*!!!VAR_DEF_SLUT!!!\\*/");
		var match = myRegexp.exec(myString);
		var newVars = match[1].replace(/\uffff/g,'\n');
		
		// Extrcat the old variables as a string for comparison. Unfortunately document.documentElement.innerHTML do
		// not work as eval only update the variable not the underlying document.

		if (newVars != variableDefinitionString)
		{
			currentMarker.setMap(null); // Clear old marker, as new marker variable will override old
			polylinePath.setMap(null); // This does not have to be done before eval, but we do it anyway

			eval(newVars);
			
			currentMarker.setMap(map);
			
			polylinePath = new google.maps.Polyline({
				path: movementCoordinates,
				strokeColor: "#FF0000",
				strokeOpacity: 1.0,
				strokeWeight: 2
			});

			polylinePath.setMap(map);
			variableDefinitionString = newVars;
		}

		// Re-start the timeout
		window.clearTimeout(timeout);
		timeout = window.setTimeout(pollServer, 3000);
	}

	function pollServer() {
		$.get("http://" + location.host + "/paweb/device", { id: <xsl:value-of select="@id"/>, type: "gmap" }, serverResponse);
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