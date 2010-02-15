<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rcp="http://www.brics.dk/ixwt/recipes"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                version="2.0">

  <xsl:template match="/">

    <xsl:text>

Does needleBendt exist in haystack: </xsl:text>
    <xsl:value-of select="//haystack/el = //needleBendt "/>

    <xsl:text>

Does needleNoName exist in haystack: </xsl:text>
    <xsl:value-of select="//haystack/el = //needleNoName "/>

    <xsl:text>

The length of the longest string in haystack is: </xsl:text>
	<xsl:value-of select="fn:max(for $r in //haystack/el return fn:string-length($r))"/>

    <xsl:text>

Is haystack concat a palindrome: </xsl:text>
<!-- Attempts was made with //haystack/el = fn:reverse(//haystack/el), but this always return truem, as it is a sequence comparison. -->
<!-- Further attempts was tried suing fn:concat, fn:string-join, deep-equal. The closest we got was  fn:deep-equal(//haystack/el, fn:reverse(//haystack/el)), but -->
<!-- fn:reverse(//haystack/el) generally does not work as it reverses the sequence, not the individual letters -->
<!-- currently the only solution (or one of them, anyway) is to create a sequence of chars and then compare with the reverse (deep-equal as
eq do not work on sequences and = just needs one match to be true) -->
	<xsl:value-of select="fn:deep-equal(for $r in //haystack/el return
											for $i in 1 to string-length($r) return substring($r, $i, 1) 
										,
										fn:reverse(for $r in //haystack/el return 
													   for $i in 1 to string-length($r) return substring($r, $i, 1))
									   )"/>
	
    <xsl:text>
<!-- this also show the variable solution -->
Is haystackPalindrome concat a palindrome: </xsl:text>
	<xsl:variable name="seq-of-char" select="for $r in //haystackPalindrome/el return
											for $i in 1 to string-length($r) return substring($r, $i, 1)"/>
	<xsl:value-of select="fn:deep-equal($seq-of-char, fn:reverse($seq-of-char))"/>

    <xsl:text>

Number of haystack elements match attribute in attributes.xml: </xsl:text>
	<xsl:value-of select="//haystack/el = fn:doc('attributes.xml')//@*"/>

	</xsl:template>
</xsl:stylesheet>
