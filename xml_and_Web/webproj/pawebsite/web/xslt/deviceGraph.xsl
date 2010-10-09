<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">
  
<!-- This is the third device stylesheet generated and will 
     generate the same table as device.xsl, and also update its
	 data using AJAX, yet it will also use JQPlot to display the 
	 data graphically. The graphical data is also updated using AJAX -->

  <xsl:template match="g:device">
	<html>
		<head>
			<link href="style.css" rel="stylesheet" type="text/css"/>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>PA International device details Graph</title>
			
<script type="text/javascript" src="js/jquery-1.4.2.js"></script>
<!-- There is a problem with JQPlot on IE -->
<!--[if IE]><script language="javascript" type="text/javascript" src="js/excanvas.js"></script><![endif]-->

<!--script language="javascript" type="text/javascript" src="js/jquery-1.3.2.min.js"></script-->
<script language="javascript" type="text/javascript" src="js/jquery.jqplot.js"></script>
<link rel="stylesheet" type="text/css" href="css/jquery.jqplot.css" />

<script type="text/javascript">
	var timeout; // This variable is used for changing between http not ready timeout and polling timeout
	var plotObject;
	
    // This function is called upon initialization of the body element, i.e. when the page has finished loaded.
	// This is important if one wishes to access some of the elements in the page from this code.
	function initialize() {
		// The page contains a dropdown list, and we want to select the first entry in the list
		// and the refresh the graph.
		var s = document.getElementById("graphSelect");
		s.selectedIndex = 0;
		graphSelectionChanged();
    }

// This section contains a start and end tag defining the sections containing the data variables.
// This is done so it is possible for code to extract the new data from the AJAX response,
// and reinitialize the javascript variables with the new data using the eval function.
/*!!!VAR_DEF_START!!!*/
	<!-- This foreach creates a variable for each sensor using the position as an ID (needed later) -->
	<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
		<!-- Store the id , as we need it in the inner foreach -->
		<xsl:variable name="currentID" select="." />

		<!-- Loop all data pertaining to this sensor and place it with entry and exit tags so it may be 
		processed by the post-processing which converts the dateTime into a format usable by jqplot.
		it might be possible to find an XSLT solution to this, but the date framework we tried did 
		not work with our transformer, and then we decided to just do it in Java -->
		graphData<xsl:value-of select="position()"/> = [[<xsl:for-each select="//g:geolog">[!!DATETIME_START_TAG!!<xsl:value-of select="./@dateTime"/>!!DATETIME_END_TAG!!,<xsl:value-of select="./g:readings/g:reading[$currentID=@id]/g:value"/>]<xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>]];
	</xsl:for-each>
/*!!!VAR_DEF_SLUT!!!*/

	// This function is called when AJAX response is reveived
	function serverResponse(data) {
		// Create a new in-memeory div element and set its content to the repsonse.
		// This is needed in order to extract sub-elements from the response.
		var d = document.createElement("div");
		d.innerHTML = data;
		// Extract the div elements
		var u = d.getElementsByTagName("div");
		// Determine if the data in the div element currently in 
		// the document is different from the one received in the 
		// AJAX response (i.e. has the data changed)
		if ($('#deviceData')[0].innerHTML != u[1].innerHTML)
		{
			// If the data has changed first update the table
			$('#deviceData').html(u[1].innerHTML); // div 0 is graph
			// Then use regex to extract the data variables section of the javascript
			var myString = data;
			myString = myString.replace(/\n/g,'\uffff');
			var myRegexp = new RegExp("/\\*!!!VAR_DEF_START!!!\\*/(.*?)/\\*!!!VAR_DEF_SLUT!!!\\*/");
			var match = myRegexp.exec(myString);
			var temp = match[1].replace(/\uffff/g,'\n');
			// And finally update the variables
			eval(temp);
			// and re-evaluate the graph
			graphSelectionChanged();
		}
		
		// Re-start the timeout
		window.clearTimeout(timeout);
		timeout = window.setTimeout(pollServer, 3000);
	}

	// This function is changed when the selection in the dropdown list 
	// is changed. It will redraw the graph with the new selected data
	function graphSelectionChanged() {
		// Extract the selected sensor
		var s = document.getElementById("graphSelect");
		var o = s.options[s.selectedIndex];
		var selected = o.text;

		switch (selected) {
		<!-- iterate the unique reading's id and create a case entry for each -->
		<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
			case &quot;<xsl:value-of select="."/>&quot;:
				// for the given case plot the data pertaining to that sensor
				plotObject = $.jqplot('chartdiv', graphData<xsl:value-of select="position()"/>, { axes:{xaxis:{ min: 0 }} });
				// Unfortunately the above command only draws the plot the first time, on subsequent plots
				// it is required to call replot
				if (plotObject) {
					// This is not required the first time, but every other time to ensure axis re-scale.
					var replotOptionObj = {clear:true, resetAxes:true};
					plotObject.replot(replotOptionObj);
				}
			break;
		</xsl:for-each>
		}
	}

	// This function uses JQuery to make an AJAX request for new data.
	function pollServer() {
		$.get("device", { id: <xsl:value-of select="@id"/>, type: "graph" }, serverResponse);
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
		<p>On this page you can see the details for a given sensor or location over time</p>
		Please select the sensor or location to show: 
		<select id="graphSelect" onchange="graphSelectionChanged()">
			<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
			<option><xsl:value-of select="."/></option>
			</xsl:for-each>
		</select><br/>
		<br/>
		<!-- As the first dateTime is used as a starting point, it is required to print this starting point
		so the exact date and time can be calculated from the relative plot. -->
		The first sample was taken on: 
		<xsl:value-of select="//g:geolog[1]/@dateTime"/>
		 and the axis shows seconds after that.
		<br/>
		<br/>
		<!-- the div holding the plot -->
		<div id="chartdiv" style="height:600px;width:800px; "></div>
		
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
