
/**
 * ExtensionMapper.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.5.1  Built on : Oct 19, 2009 (10:59:34 EDT)
 */

            package dk.au.cs.www.schwarz.guestbook.data;
            /**
            *  ExtensionMapper class
            */
        
        public  class ExtensionMapper{

          public static java.lang.Object getTypeObject(java.lang.String namespaceURI,
                                                       java.lang.String typeName,
                                                       javax.xml.stream.XMLStreamReader reader) throws java.lang.Exception{

              
                  if (
                  "http://www.cs.au.dk/schwarz/guestbook/data".equals(namespaceURI) &&
                  "collectionType".equals(typeName)){
                   
                            return  dk.au.cs.www.schwarz.guestbook.data.CollectionType.Factory.parse(reader);
                        

                  }

              
                  if (
                  "http://www.cs.au.dk/schwarz/guestbook/data".equals(namespaceURI) &&
                  "entryType".equals(typeName)){
                   
                            return  dk.au.cs.www.schwarz.guestbook.data.EntryType.Factory.parse(reader);
                        

                  }

              
             throw new org.apache.axis2.databinding.ADBException("Unsupported type " + namespaceURI + " " + typeName);
          }

        }
    