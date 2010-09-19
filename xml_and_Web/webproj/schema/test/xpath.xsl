<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
								xmlns:g="http://www.pa.com/geolog"
								xmlns:k="http://www.opengis.net/kml/2.2"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">
  <xsl:template match="/">


    <xsl:text>
    Current dateTime :
    </xsl:text>

    <xsl:value-of select="fn:current-dateTime()"/>

		<!-- TIME -->	
    <xsl:text>

    All geolog reading times :
    </xsl:text>
    
    <xsl:value-of select="//g:geolog/@dateTime"/>
    <xsl:text> </xsl:text>
    
    <!-- 
    How is an xsd associated with these XPath expressions? 
    When the type is unknown fn:min will not be able to compare 
    the geolog/@dateTime attributes. A solution using fn:last and
    not fn:min() was written. 
    -->

    <!--
		<xsl:text>
    Latest reading time :
    </xsl:text>
    
    <xsl:value-of select="min(//g:geolog/@dateTime)"/>
    <xsl:text> </xsl:text>
    -->
    
		<xsl:text>
    The time of the last reading (will it always be the latest?) :
    </xsl:text>
    
    <xsl:value-of select="//g:geolog[fn:last()]/@dateTime"/>
    <xsl:text> </xsl:text>

		<!-- STATUS -->	
    <xsl:text>

    All geolog statuses :
    </xsl:text>
    
    <xsl:value-of select="//g:geolog/g:status"/>
    <xsl:text> </xsl:text>

		<xsl:text>
    The status of the last reading (will it always be the latest?) :
    </xsl:text>
    
    <xsl:value-of select="//g:geolog[fn:last()]/g:status"/>
    <xsl:text> </xsl:text>

		<!-- COORDINATES -->	
    <xsl:text>
    
    All geolog coordinates :
    </xsl:text>
    
    <xsl:value-of select="//g:geolog//k:coordinates"/>
    <xsl:text> </xsl:text>
    
		<xsl:text>
    The coordinates of the last reading (will it always be the latest?) :
    </xsl:text>
    
    <xsl:value-of select="//g:geolog[fn:last()]//k:coordinates"/>
    <xsl:text> </xsl:text>

  </xsl:template>
</xsl:stylesheet>
