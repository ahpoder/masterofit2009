<!-- Please search for !!! for all descriptions of non-compliance -->
<!-- Requirement 1. This ensures that the namespace is what it should be -->
<schema xmlns="http://www.w3.org/2001/XMLSchema"
        xmlns:w="http://cs.au.dk/~schwarz/XMLTek"
        targetNamespace="http://cs.au.dk/~schwarz/XMLTek"
        elementFormDefault="qualified">

<!-- Requirement 2. This ensures that the root element is wiki -->
  <element name="wiki">
    <complexType>
<!-- Requirement 2. This defines the wiki name attribute -->
		<attribute name="name" type="string"/>
<!-- Requirement 3. This ensures that the wiki element can contain the required sub elements -->
		<all>
<!-- Requirement 4. This defines the image element and its attribute. -->
		  <element ref="w:image"/>
		  <element ref="wikilink"/>
		  <element ref="link"/>
		  <element ref="italics"/>
		  <element ref="tt"/>
		  <element ref="bold"/>
		  <element ref="header"/>
		  <element ref="rule"/>
		  <element ref="character"/>
		  <element ref="list"/>
		  <element ref="br"/>
		  <element ref="text"/>
		  <element ref="ws"/>
		</all>
    </complexType>
  </element>
  
	<element name="image" type="anyURI" minOccurs="0" maxOccurs="unbounded">
	<element name="wikilink" type="w:wikilinkType" minOccurs="0" maxOccurs="unbounded">
	<element name="link" type="w:wikilinkType" minOccurs="0" maxOccurs="unbounded"/>
	<element name="italics" type="w:italicsType" minOccurs="0" maxOccurs="unbounded"/>
	<element name="tt" minOccurs="0" maxOccurs="unbounded"/>
	<element name="bold" minOccurs="0" maxOccurs="unbounded"/>
	<element name="header" minOccurs="0" maxOccurs="unbounded"/>
	<element name="rule" minOccurs="0" maxOccurs="unbounded"/>
	<element name="character" minOccurs="0" maxOccurs="unbounded"/>
	<element name="list" minOccurs="0" maxOccurs="unbounded"/>
	<element name="br" minOccurs="0" maxOccurs="unbounded"/>
	<element name="text" minOccurs="0" maxOccurs="unbounded"/>
	<element name="ws" minOccurs="0" maxOccurs="unbounded"/>

<!-- Requirement 5. This defines the wikilink element and its attributes. -->
  <complexType name="wikilinkType">
	<attribute name="word" type="string"/>
	<attribute name="wiki" type="anyURI" minOccurs="0"/>
  </complexType>
  
<!-- Requirement 6. This defines the link link element and its attributes. -->
  <complexType name="linkType">
		<attribute name="word" type="linkWordType"/>
		<attribute name="url" type="anyURI"/>
  </complexType>

<!-- Requirement 7. This defines the word attribute. -->
  <complexType name="linkWordType">
    <simpleContent>
	  <restriction base="string">
	    <xs:pattern value="[a-zA-Z_]+"/>
	  </restriction>
	<attribute name="url" type="anyURI"/>
  </complexType>

<!ELEMENT wiki ((image | wikilink | link | italics | tt | bold | header | rule | character | list | br | text | ws)*)>
<!ATTLIST wiki name CDATA #IMPLIED>

<!ELEMENT image EMPTY>
<!ATTLIST image url CDATA #REQUIRED>

<!ELEMENT wikilink EMPTY>
<!ATTLIST wikilink word CDATA #REQUIRED
                   wiki CDATA #IMPLIED>

<!ELEMENT link EMPTY>
<!ATTLIST link word CDATA #REQUIRED
               url CDATA #REQUIRED>

<!-- Requirement 8. This defines the italics element -->
<!ELEMENT italics ((image | wikilink | link | tt | bold | header | rule | character | list | br | text | ws)*)> <!-- all elements from wiki list except italics -->

<!-- Requirement 9. This defines the tt element. -->
<!ELEMENT tt ((image | wikilink | link | italics | bold | header | rule | character | list | br | text | ws)*)> <!-- all elements from wiki list except tt -->

<!-- Requirement 10. This defines the bold element. -->
<!ELEMENT bold ((image | wikilink | link | italics | tt | header | rule | character | list | br | text | ws)*)> <!-- all elements from wiki list except bold -->

<!-- Requirement 11. This defines the header element. -->
<!ELEMENT header ((image | wikilink | link | italics | tt | bold | character | br | text | ws)*)> <!-- all elements from wiki list except header, list, rule -->

<!-- Requirement 12. This defines the rule element. -->
<!ELEMENT rule EMPTY>

<!-- Requirement 13. This defines the character element. -->
<!ELEMENT character EMPTY>
<!ATTLIST character entity CDATA #REQUIRED>

<!-- Requirement 14. This defines the list and item elements. -->
<!ELEMENT list (item*)>
<!ELEMENT item ((image | wikilink | link | italics | tt | bold | character | br | text | ws)*)> <!-- all elements from wiki list except header, list, rule -->

<!-- Requirement 15. This defines the br element. -->
<!ELEMENT br EMPTY>

<!-- Requirement 16. This defines the text element. !!! Unfortunately any char is allowed -->
<!ELEMENT text (#PCDATA)>

<!-- Requirement 17. This defines the ws element. -->
<!ELEMENT ws EMPTY>

<!-- Requirement 18. !!! Cannot be expressed in DTD -->
<!-- Requirement 19. !!! Cannot be expressed in DTD -->

</schema>
