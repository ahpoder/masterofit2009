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
<script language="javascript" type="text/javascript" src="js/jquery.jqplot.js"></script>
<link rel="stylesheet" type="text/css" href="css/jquery.jqplot.css" />

<script type="text/javascript">
	var timeout; // This variable is used for changing between http not ready timeout and polling timeout
	var plotObject;
	
    function initialize() {
		var s = document.getElementById("graphSelect");
		s.selectedIndex = 0;
		graphSelectionChanged();
		pollServer();
    }

/*!!!VAR_DEF_START!!!*/
		<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
				<xsl:variable name="currentID" select="." />
				graphData<xsl:value-of select="position()"/> = [[<xsl:for-each select="//g:geolog">[!!DATETIME_START_TAG!!<xsl:value-of select="./@dateTime"/>!!DATETIME_END_TAG!!,<xsl:value-of select="./g:readings/g:reading[$currentID=@id]/g:value"/>]<xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>]];
		</xsl:for-each>
/*!!!VAR_DEF_SLUT!!!*/

	// This function can be reused by both send chat and poll
	function serverResponse(data) {
		// Create a new in-memeory div element and set its content to the repsonse.
		// This is needed in order to extract sub-elements from the response.
		var d = document.createElement("div");
		d.innerHTML = data;
		// Extract the first table (there should be only 1)
		var u = d.getElementsByTagName("div");
		if ($('#deviceData')[0].innerHTML != u[1].innerHTML)
		{
			$('#deviceData').html(u[1].innerHTML); // div 0 is graph
			var myString = data;
			myString = myString.replace(/\n/g,'\uffff');
			var myRegexp = new RegExp("/\\*!!!VAR_DEF_START!!!\\*/(.*?)/\\*!!!VAR_DEF_SLUT!!!\\*/");
			var match = myRegexp.exec(myString);
			var temp = match[1].replace(/\uffff/g,'\n');
			eval(temp);
			graphSelectionChanged();
		}
		
		// Re-start the timeout
		window.clearTimeout(timeout);
		timeout = window.setTimeout(pollServer, 3000);
	}

	function graphSelectionChanged() {
		var s = document.getElementById("graphSelect");
		var o = s.options[s.selectedIndex];
		var selected = o.text;

		switch (selected) {
		<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
			case &quot;<xsl:value-of select="."/>&quot;:
				<xsl:variable name="currentID" select="." />

				<!-- This would have been the most elegant solution, but unfortunaltely the date:seconds do not work with the XSLT transformer we use. -->
				<!-- $.jqplot('chartdiv', [[<xsl:for-each select="//g:geolog">[<xsl:value-of select="date:seconds(./@dateTime))"/>,<xsl:value-of select="./g:readings/g:reading[$currentID=@id]/g:value"/>]<xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>]]); -->

			plotObject = $.jqplot('chartdiv', graphData<xsl:value-of select="position()"/>, { axes:{xaxis:{ min: 0 }} });

			if (plotObject)
			{
				// This is not required the first time, but every other time to ensure axis re-scale.
				var replotOptionObj = {clear:true, resetAxes:true};
				plotObject.replot(replotOptionObj);
			}

			break;
		</xsl:for-each>
		}
	}

	function pollServer() {
		$.get("http://" + location.host + "/paweb/device", { id: <xsl:value-of select="@id"/>, type: "graph" }, serverResponse);
    }
	// Start the poll timer (maybe we should check for document ready???)
	timeout = window.setTimeout(pollServer, 3000);
</script>

		</head>
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
		The first sample was taken on: 
		<xsl:value-of select="//g:geolog[1]/@dateTime"/>
	<!--xsl:for-each select="//g:geolog">
		<xsl:if test="position()=1">
		</xsl:if>
	</xsl:for-each-->
		 and the axis shows seconds after that.
		<br/>
		<br/>
		<div id="chartdiv" style="height:600px;width:800px; "></div>
		
		<div id="deviceData">
		<table border="1">
			<tr>
				<th>DateTime</th>
				<th>Status</th>
				<xsl:for-each select="//g:reading/@id[not(.=preceding::g:reading/@id)]">
				<th><xsl:value-of select="."/></th>
				</xsl:for-each>
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
