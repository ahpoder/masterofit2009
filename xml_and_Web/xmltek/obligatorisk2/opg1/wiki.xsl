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
		  <element ref="w:image"/>
		  <element ref="w:wikilink"/>
		  <element ref="w:link"/>
		  <element ref="w:italics"/>
		  <element ref="w:tt"/>
		  <element ref="w:bold"/>
		  <element ref="w:header"/>
		  <element ref="w:rule"/>
		  <element ref="w:character"/>
		  <element ref="w:list"/>
		  <element ref="w:br"/>
		  <element ref="w:text"/>
		  <element ref="w:ws"/>
		</all>
    </complexType>
  </element>
  
<!-- Requirement 4. This defines the image element and its attribute. -->
	<element name="image" type="anyURI" minOccurs="0" maxOccurs="unbounded"/>
	<element name="wikilink" type="w:wikilinkType" minOccurs="0" maxOccurs="unbounded"/>
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
				<pattern value="[a-zA-Z_]+"/>
			</restriction>
    </simpleContent>
	<attribute name="url" type="anyURI"/>
  </complexType>

<!-- Requirement 8. This defines the italics element -->
  <complexType name="italicsType">
		<all>
		  <element ref="w:image"/>
		  <element ref="w:wikilink"/>
		  <element ref="w:link"/>
		  <element ref="w:tt"/>
		  <element ref="w:bold"/>
		  <element ref="w:header"/>
		  <element ref="w:rule"/>
		  <element ref="w:character"/>
		  <element ref="w:list"/>
		  <element ref="w:br"/>
		  <element ref="w:text"/>
		  <element ref="w:ws"/>
		</all>
  </complexType>

<!-- Requirement 9. This defines the tt element. -->
  <complexType name="ttType">
		<all>
		  <element ref="w:image"/>
		  <element ref="w:wikilink"/>
		  <element ref="w:link"/>
		  <element ref="w:italics"/>
		  <element ref="w:bold"/>
		  <element ref="w:header"/>
		  <element ref="w:rule"/>
		  <element ref="w:character"/>
		  <element ref="w:list"/>
		  <element ref="w:br"/>
		  <element ref="w:text"/>
		  <element ref="w:ws"/>
		</all>
  </complexType>

<!-- Requirement 10. This defines the bold element. -->
  <complexType name="boldType">
		<all>
		  <element ref="w:image"/>
		  <element ref="w:wikilink"/>
		  <element ref="w:link"/>
		  <element ref="w:italics"/>
		  <element ref="w:tt"/>
		  <element ref="w:header"/>
		  <element ref="w:rule"/>
		  <element ref="w:character"/>
		  <element ref="w:list"/>
		  <element ref="w:br"/>
		  <element ref="w:text"/>
		  <element ref="w:ws"/>
		</all>
  </complexType>

<!-- Requirement 11. This defines the header element. -->
  <complexType name="headerType">
		<all>
		  <element ref="w:image"/>
		  <element ref="w:wikilink"/>
		  <element ref="w:link"/>
		  <element ref="w:italics"/>
		  <element ref="w:tt"/>
		  <element ref="w:bold"/>
			<element ref="w:character"/>
		  <element ref="w:br"/>
		  <element ref="w:text"/>
		  <element ref="w:ws"/>
		</all>
  </complexType>

<!-- Requirement 12. This defines the rule element. -->
  <complexType name="ruleType"/>

<!-- Requirement 13. This defines the character element. -->
<!-- TODO : limit to XHTML character entity reference -->
  <complexType name="characterType">
		<attribute name="entity" type="string"/>
  </complexType>

<!-- Requirement 14. This defines the list elements. -->
  <complexType name="listType">
		<element name="item" type="w:itemType" minOccurance="0" maxOccurance="unbounded"/>
  </complexType>

<!-- Requirement 14. This defines the item elements. -->
  <complexType name="itemType">
		<all>
		  <element ref="w:image"/>
		  <element ref="w:wikilink"/>
		  <element ref="w:link"/>
		  <element ref="w:italics"/>
		  <element ref="w:tt"/>
		  <element ref="w:bold"/>
			<element ref="w:character"/>
		  <element ref="w:br"/>
		  <element ref="w:text"/>
		  <element ref="w:ws"/>
		</all>
  </complexType>

<!-- Requirement 15. This defines the br element. -->
  <complexType name="brType"/>

<!-- Requirement 16. This defines the text element. !!! Unfortunately any char is allowed -->
<!--!ELEMENT text (#PCDATA)-->

<!-- Requirement 17. This defines the ws element. -->
  <complexType name="wsType"/>

<!-- Requirement 18. !!! Cannot be expressed in DTD -->
<!-- Requirement 19. !!! Cannot be expressed in DTD -->

</schema>
