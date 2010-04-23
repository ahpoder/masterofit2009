/* 
   This servlet illustrates the differences between
   various scope levels i Servlets.

   Open this servlet in two different browser windows
   and reload their contents repeatedly. Explain how
   and why the different numbers change their values.
*/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;

public class BigBrother implements ServletContextListener, ServletRequestListener,
								   HttpSessionListener, ServletContextAttributeListener,
								   HttpSessionAttributeListener
                                    {
	ServletContext context;
	
  // Notification that the servlet context is about to be shut down.
  public void contextDestroyed(ServletContextEvent sce) {
	context.log("contextDestroyed: " + sce.getServletContext().toString());
  }
          
  // Notification that the web application is ready to process reque
  public void contextInitialized(ServletContextEvent sce) {
    context = sce.getServletContext();
	context.log("contextInitialized: " + context.toString());
  }
  
  // The request is about to go out of scope of the web application.
  public void requestDestroyed(ServletRequestEvent rre) {
	context.log("requestDestroyed: " +  rre.getServletRequest().toString());
  }

  // The request is about to come into scope of the web application.
  public void requestInitialized(ServletRequestEvent rre) {
	context.log("requestInitialized: " +  rre.getServletRequest().toString());
  }

  // Notification that a session was created.
  public void sessionCreated(HttpSessionEvent se) {
	context.log("sessionCreated: " +  se.getSession().toString());
  }
  
  // Notification that a session is about to be invalidated.
  public void sessionDestroyed(HttpSessionEvent se) {
	context.log("sessionDestroyed: " +  se.getSession().toString());
  }
  
  // Notification that a new attribute was added to the servlet context.
  public void attributeAdded(ServletContextAttributeEvent scab) {
	context.log("Servlet attributeAdded: " +  scab.getName() + " = " + scab.getValue().toString());
  }
          
  // Notification that an existing attribute has been remved from the servlet context.
  public void attributeRemoved(ServletContextAttributeEvent scab) {
	context.log("Servlet attributeRemoved: " +  scab.getName() + " = " + scab.getValue().toString());
  }

  // Notification that an attribute on the servlet context has been replaced.
  public void attributeReplaced(ServletContextAttributeEvent scab) {
	context.log("Servlet attributeReplaced: " +  scab.getName() + " = " + scab.getValue().toString());
  }
      
  // Notification that an attribute has been added to a session.
  public void attributeAdded(HttpSessionBindingEvent se) {
	context.log("Session attributeAdded: " +  se.getName() + " = " + se.getValue().toString());
  }
          
  // Notification that an attribute has been removed from a session.
  public void attributeRemoved(HttpSessionBindingEvent se) {
	context.log("Session attributeRemoved: " +  se.getName() + " = " + se.getValue().toString());
  }
          
  // Notification that an attribute has been replaced in a session.
  public void attributeReplaced(HttpSessionBindingEvent se) {
	context.log("Session attributeReplaced: " +  se.getName() + " = " + se.getValue().toString());
  }
          
}
