<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:g="http://www.pa.com/geolog"
				xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="g:devices">
		<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
		<Document>
			<name>devices.kml</name>
			<Style id="sn_ylw-pushpin">
				<IconStyle>
					<scale>1.1</scale>
					<Icon>
						<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
					</Icon>
					<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
				</IconStyle>
				<LabelStyle>
					<color>ff0000ff</color>
				</LabelStyle>
				<ListStyle>
				</ListStyle>
			</Style>
			<Style id="sh_ylw-pushpin">
				<IconStyle>
					<scale>1.3</scale>
					<Icon>
						<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
					</Icon>
					<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
				</IconStyle>
				<LabelStyle>
					<color>ff0000ff</color>
				</LabelStyle>
				<ListStyle>
				</ListStyle>
			</Style>
			<StyleMap id="msn_ylw-pushpin">
				<Pair>
					<key>normal</key>
					<styleUrl>#sn_ylw-pushpin</styleUrl>
				</Pair>
				<Pair>
					<key>highlight</key>
					<styleUrl>#sh_ylw-pushpin</styleUrl>
				</Pair>
			</StyleMap>
			<Folder>
				<name>devices</name>
				<open>1</open>
					<xsl:apply-templates mode="placemark" select="//g:deviceSimple"/> 				
			</Folder>
		</Document>
		</kml>
  </xsl:template>

	<!-- Display each device as a KML placemark 
				TODO: The pin color depends on the status 
				through the class attribute and the CSS stylesheet -->
  <xsl:template mode="placemark" match="g:deviceSimple">
		<Placemark>
			<name>device <xsl:value-of select="@id"/></name>
			<description>dette er en beskrivelse</description>
			<styleUrl>#msn_ylw-pushpin</styleUrl>
				<xsl:apply-templates select="./k:Point"/> 				
		</Placemark>
  </xsl:template>

  <xsl:template match="k:Point">
		<Point>
			<xsl:apply-templates select="./k:coordinates"/> 				
		</Point>
  </xsl:template>

  <xsl:template match="k:coordinates">
		<coordinates>
			<xsl:value-of select="./text()"/>
		</coordinates>
  </xsl:template>

</xsl:stylesheet>
