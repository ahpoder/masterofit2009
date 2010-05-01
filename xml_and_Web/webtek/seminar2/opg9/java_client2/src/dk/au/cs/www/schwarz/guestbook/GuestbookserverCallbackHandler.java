
/**
 * GuestbookserverCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.5.1  Built on : Oct 19, 2009 (10:59:00 EDT)
 */

    package dk.au.cs.www.schwarz.guestbook;

    /**
     *  GuestbookserverCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class GuestbookserverCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public GuestbookserverCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public GuestbookserverCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for listEntries method
            * override this method for handling normal response from listEntries operation
            */
           public void receiveResultlistEntries(
                    dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Collection result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from listEntries operation
           */
            public void receiveErrorlistEntries(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getEntry method
            * override this method for handling normal response from getEntry operation
            */
           public void receiveResultgetEntry(
                    dk.au.cs.www.schwarz.guestbook.GuestbookserverStub.Entry result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getEntry operation
           */
            public void receiveErrorgetEntry(java.lang.Exception e) {
            }
                


    }
    