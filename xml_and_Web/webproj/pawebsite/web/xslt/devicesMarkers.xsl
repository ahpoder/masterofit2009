<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns:g="http://www.pa.com/geolog"
								xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

	<!-- match the collection -->
  <xsl:template match="g:devices">
  	<!-- wrap markers in a collection -->
		<markers>
			<xsl:apply-templates select="//g:deviceSimple"/> 
		</markers>
  </xsl:template>

	<!-- make a simple marker structure, this requires saxon to transform -->
  <xsl:template match="g:deviceSimple">
  	<!-- Define a marker with the wanted attributes -->
		<marker id="{./@id}" name="device #{./@id}" lng="{fn:substring-before(./k:Point/k:coordinates, ',')}" lat="{fn:substring-after(./k:Point/k:coordinates, ',')}"/> 
  </xsl:template>
</xsl:stylesheet>
