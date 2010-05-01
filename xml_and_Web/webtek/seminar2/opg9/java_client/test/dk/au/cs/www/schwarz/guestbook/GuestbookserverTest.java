

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
        public  void testgetEntry() throws java.lang.Exception{

        dk.au.cs.www.schwarz.guestbook.GuestbookserverStub stub =
                    new dk.au.cs.www.schwarz.guestbook.GuestbookserverStub();//the default implementation should point to the right endpoint

           dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title title4=
                                                        (dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title)getTestObject(dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title.class);
                    // TODO : Fill in the title4 here
                
//                        dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Entry e = stub.getEntry(title4);
//						assertNotNull(e);
						assertNotNull(stub.getEntry(title4));
						
                  



        }
        
         /**
         * Auto generated test method
         */
        public  void testStartgetEntry() throws java.lang.Exception{
            dk.au.cs.www.schwarz.guestbook.GuestbookserverStub stub = new dk.au.cs.www.schwarz.guestbook.GuestbookserverStub();
             dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title title4=
                                                        (dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title)getTestObject(dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Title.class);
                    // TODO : Fill in the title4 here
                

                stub.startgetEntry(
                         title4,
                    new tempCallbackN1000C()
                );
              


        }

        private class tempCallbackN1000C  extends dk.au.cs.www.schwarz.guestbook.GuestbookserverCallbackHandler{
            public tempCallbackN1000C(){ super(null);}

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
    