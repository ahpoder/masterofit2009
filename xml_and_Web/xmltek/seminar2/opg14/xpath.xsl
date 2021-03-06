<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
								xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">

  <xsl:template match="rcp:recipe">
Recipe name: <xsl:value-of select="rcp:title"/>
		<xsl:apply-templates select="rcp:preparation"/>
  </xsl:template>

  <xsl:template match="rcp:preparation">
    <xsl:text>
    Count of sentences (number of dots) (P) = </xsl:text>
    <xsl:variable name="tmpNSentences">
      <xsl:analyze-string select="fn:string-join(.//text(), '')" regex="[^\.]+\.">
        <xsl:matching-substring>A</xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="NSentences" select="fn:string-length($tmpNSentences)"/>
    <xsl:value-of select="$NSentences"/>
		
    <xsl:text>
    Count of words longer than six chars (L) = </xsl:text>
    <xsl:variable name="tmpWordsOverSevenChar">
      <xsl:analyze-string select="." regex="\s[a-zA-Z]{{7,}}\s">
        <xsl:matching-substring>A</xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="countWordOverSevenChar" select="fn:string-length($tmpWordsOverSevenChar)"/>
    <xsl:value-of select="$countWordOverSevenChar"/>

    <xsl:text>
    Count of words (W) = </xsl:text>
    <xsl:variable name="tmpTotalWords">
      <xsl:analyze-string select="." regex="\w">
        <xsl:matching-substring>A</xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:variable name="countTotalWords" select="fn:string-length($tmpTotalWords)"/>
    <xsl:value-of select="$countTotalWords"/>

    <xsl:text>
    LIX=W/P + 100*L/W = </xsl:text>
    <xsl:value-of select="fn:round-half-to-even($countTotalWords div $NSentences + 100 * $countWordOverSevenChar div $countTotalWords,1)"/>
  </xsl:template>
</xsl:stylesheet>
