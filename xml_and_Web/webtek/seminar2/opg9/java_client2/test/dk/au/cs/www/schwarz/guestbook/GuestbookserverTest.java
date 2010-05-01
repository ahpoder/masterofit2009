

/**
 * GuestbookserverTest.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.5.1  Built on : Oct 19, 2009 (10:59:00 EDT)
 */
    package dk.au.cs.www.schwarz.guestbook;

    /*
     *  GuestbookserverTest Junit test case
    */

    public class GuestbookserverTest extends junit.framework.TestCase{

     
        /**
         * Auto generated test method
         */
        public  void testlistEntries() throws java.lang.Exception{

        dk.au.cs.www.schwarz.guestbook.GuestbookserverStub stub =
                    new dk.au.cs.www.schwarz.guestbook.GuestbookserverStub();//the default implementation should point to the right endpoint

           dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Empty empty8=
                                                        (dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Empty)getTestObject(dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Empty.class);
                    // TODO : Fill in the empty8 here
                
                        assertNotNull(stub.listEntries(
                        empty8));
                  



        }
        
         /**
         * Auto generated test method
         */
        public  void testStartlistEntries() throws java.lang.Exception{
            dk.au.cs.www.schwarz.guestbook.GuestbookserverStub stub = new dk.au.cs.www.schwarz.guestbook.GuestbookserverStub();
             dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Empty empty8=
                                                        (dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Empty)getTestObject(dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Empty.class);
                    // TODO : Fill in the empty8 here
                

                stub.startlistEntries(
                         empty8,
                    new tempCallbackN1000C()
                );
              


        }

        private class tempCallbackN1000C  extends dk.au.cs.www.schwarz.guestbook.GuestbookserverCallbackHandler{
            public tempCallbackN1000C(){ super(null);}

            public void receiveResultlistEntries(
                         dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Collection result
                            ) {
                
            }

            public void receiveErrorlistEntries(java.lang.Exception e) {
                fail();
            }

        }
      
        /**
         * Auto generated test method
         */
        public  void testgetEntry() throws java.lang.Exception{

        dk.au.cs.www.schwarz.guestbook.GuestbookserverStub stub =
                    new dk.au.cs.www.schwarz.guestbook.GuestbookserverStub();//the default implementation should point to the right endpoint

           dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title title10=
                                                        (dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title)getTestObject(dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title.class);
                    // TODO : Fill in the title10 here
                
                        assertNotNull(stub.getEntry(
                        title10));
                  



        }
        
         /**
         * Auto generated test method
         */
        public  void testStartgetEntry() throws java.lang.Exception{
            dk.au.cs.www.schwarz.guestbook.GuestbookserverStub stub = new dk.au.cs.www.schwarz.guestbook.GuestbookserverStub();
             dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title title10=
                                                        (dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title)getTestObject(dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title.class);
                    // TODO : Fill in the title10 here
                

                stub.startgetEntry(
                         title10,
                    new tempCallbackN10034()
                );
              


        }

        private class tempCallbackN10034  extends dk.au.cs.www.schwarz.guestbook.GuestbookserverCallbackHandler{
            public tempCallbackN10034(){ super(null);}

            public void receiveResultgetEntry(
                         dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Entry result
                            ) {
                
            }

            public void receiveErrorgetEntry(java.lang.Exception e) {
                fail();
            }

        }
      
        //Create an ADBBean and provide it as the test object
        public org.apache.axis2.databinding.ADBBean getTestObject(java.lang.Class type) throws java.lang.Exception{
           return (org.apache.axis2.databinding.ADBBean) type.newInstance();
        }

        
        

    }
    