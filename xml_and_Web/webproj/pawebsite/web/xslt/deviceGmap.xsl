<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">
    
<!-- This is the fourth device stylesheet generated and will 
     show the device's location history on google maps. The location 
	 will continously be updated using AJAX -->
	
	<!-- Function to get a collection of strings from a teokenized string -->
	<xsl:function name="g:getTokens" as="xs:string+">
		<xsl:param name="str" as="xs:string" />
		<xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
			<xsl:matching-substring>
				<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")' />
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:function>

  <xsl:template match="g:device">
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details Graph</title>
			
<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false&amp;language=da"></script>
<script type="text/javascript">
	var timeout; // This variable is used for changing between http not ready timeout and polling timeout
	
	var map;
	var polylinePath; // Used to update the current polyline
	var variableDefinitionString; // String holder to allow easy comparison as document is not updated. It might be possible to update the document content, but this is easier.
	
	<!-- Store the device ID in a variable for later use -->
	<xsl:variable name="deviceID" select="./@id"/>
	
// This section contains a start and end tag defining the sections containing the data variables.
// This is done so it is possible for code to extract the new data from the AJAX response,
// and reinitialize the javascript variables with the new data using the eval function.
/*!!!VAR_DEF_START!!!*/
	<!-- Need to extract the coordinates, as the KML order is opposite the LatLng order -->
	<!-- This foreach actually only need to find the last entry, and there may be easier ways 
	to do it -->
	<xsl:for-each select="//g:geolog">
		<xsl:if test="position()=last()">	
			currentMarkerPosition = new google.maps.LatLng(<xsl:value-of select="fn:substring-after(./k:Point/k:coordinates,',')"/>, <xsl:value-of select="fn:substring-before(./k:Point/k:coordinates,',')"/>);
		</xsl:if>
	</xsl:for-each>

	// current marker is stored so it can be removed upon data update, and also to 
	// make sure a change in status will trigger an update
	currentMarker = new google.maps.Marker({
		  position: currentMarkerPosition,
		  <!-- Determine the status of the device and choose an icon accordingly -->
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
		  <!-- Use the previously stored device id as title -->
		  title:"<xsl:value-of select="$deviceID"/>"
		});

		// This is the content of the pop-up bubble when the marker is pushed.
		contentString = '<div id="test">' +
						'Device: <xsl:value-of select="$deviceID"/>' +
						'<br/>' +
						'Status: <xsl:value-of select="./g:status"/>' +
						'<br/>' +
						'<a href="device?id={$deviceID}&amp;type=graph">Show readings</a>' +
						'</div>';

    // This is the coordinates of all locations the device has visited, and is used to draw a 
	// poly-line from. The poly-line itself is generic and a new one is just created when the 
	// data change, so the poly-line itself do not need to be within the replacable data.
    movementCoordinates = [
		<!-- Extract all coordinates one at a time and place them in a javascript array of LatLng -->
		<xsl:for-each select="//g:geolog/k:Point/k:coordinates">
			new google.maps.LatLng(<xsl:value-of select="fn:substring-after(.,',')"/>, <xsl:value-of select="fn:substring-before(.,',')"/>)
			<xsl:if test="position()!=last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		];
		
	// Define the two corners of the bounding box
	// This is used to determine correct center and zoom level
	<!-- Here post-processing is used again, simply because generating the minimum and maximum values
	of the lattitudes and longitudes are so much easier in Java than in XSLT. It might be possible,
	but we have chosen this solution -->
	sw = new google.maps.LatLng(!!MIN_LATTITUDE!!, !!MIN_LONGITUDE!!);  
	ne = new google.maps.LatLng(!!MAX_LATTITUDE!!, !!MAX_LONGITUDE!!);  
/*!!!VAR_DEF_SLUT!!!*/
	
  // This function is called upon initialization of the body element, i.e. when the page has finished loaded.
  // This is important if one wishes to access some of the elements in the page from this code.
  function initialize() {
    // Initialize the gmap
    var myOptions = {
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("gmapData"),
        myOptions);

	// Create the bounding box and let the map center and zoom to it.
	var bounds = new google.maps.LatLngBounds(sw, ne);  
	map.fitBounds(bounds)

	// Generate a marker at the last location
    var image = new google.maps.MarkerImage('img/green-dot.png',
    // This marker is 32 pixels wide by 32 pixels tall.
    new google.maps.Size(32, 32),
    // The origin for this image is 0,0.
    new google.maps.Point(0,0),
    // The anchor for this image is the base of the flagpole at 0,32.
    new google.maps.Point(16, 32));

    currentMarker.setMap(map);
  
    // Generate the info windows for the marker
    var infowindow = new google.maps.InfoWindow({
		content: contentString
	});

	// Add the click listener to open and close the info windows
	google.maps.event.addListener(currentMarker, 'click', function() {
	  infowindow.open(map,currentMarker);
	});

    // Create and draw the poly-line
	polylinePath = new google.maps.Polyline({
		path: movementCoordinates,
		strokeColor: "#FF0000",
		strokeOpacity: 1.0,
		strokeWeight: 2
	});

	polylinePath.setMap(map);
	
	// This is for AJAX use only. Generate a string representation of the current data variables
	// to use for comparisons when an AJAX response i sreceived
	var myString = document.documentElement.innerHTML;
	myString = myString.replace(/\n/g,'\uffff');
	var myRegexp = new RegExp("/\\*!!!VAR_DEF_START!!!\\*/(.*?)/\\*!!!VAR_DEF_SLUT!!!\\*/");
	var match = myRegexp.exec(myString);
	variableDefinitionString = match[1].replace(/\uffff/g,'\n');
  }

	// This function is called when an AJAX response is reveived
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
			
			// draw the marker and the polyline
			currentMarker.setMap(map);
			
			// It is possible to add to a current poly-line, but as it is so fast to redraw it 
			// has been deemed acceptable to do so, and it is easier from a data handling point of view
			polylinePath = new google.maps.Polyline({
				path: movementCoordinates,
				strokeColor: "#FF0000",
				strokeOpacity: 1.0,
				strokeWeight: 2
			});

			polylinePath.setMap(map);
			
			// Reevaluate the center and zoom level
			var bounds = new google.maps.LatLngBounds(sw, ne);  
			map.fitBounds(bounds)
			
			// Store the current variable data string for suture comparison
			variableDefinitionString = newVars;
		}

		// Re-start the timeout
		window.clearTimeout(timeout);
		timeout = window.setTimeout(pollServer, 3000);
	}

	// This function uses JQuery to make an AJAX request for new data.
	function pollServer() {
		$.get("http://" + location.host + "/paweb/device", { id: <xsl:value-of select="@id"/>, type: "gmap" }, serverResponse);
    }
	// Start the poll timer.
	// As the time is long enough that we are sure the document is loaded
	// before the timer expires it is OK, otherwise it should be done in
	// body initialize callback.
	timeout = window.setTimeout(pollServer, 3000);
</script>

		</head>
		<!-- register the initialize function to be called when the page is fully loaded -->
		<body onload="initialize()">
		<h1>Welcome to the PA geolog device details for device with ID: <xsl:value-of select="@id"/></h1>
		<br/>
		<p>On this page you can see the details for a given device</p>
		
		<!-- the div holding the gmap -->
		<div id="gmapData" style="width:600px; height:500px"></div>
		</body>
	</html>
  </xsl:template>
  
</xsl:stylesheet>