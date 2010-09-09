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
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
import org.jdom.xpath.*;
import java.util.*;
import java.net.*;

public class DeviceServlet extends HttpServlet {

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

//		simpleResponse( "You called the DeviceServlet GET handler",
//					request,
//					response);
		try {
			//The server has taken care of redirecting "devices" and "devices/*" to this servlet
			//The distinction may be made on the request.getPathInfo()
			String pathInfo = request.getPathInfo();

			//Case 1: "devices" and devices/" shall return all devices
			if ((pathInfo == null) || (pathInfo.equals("/"))) {
				response.setContentType("text/xml");
				GeologDataAccess da =	new GeologDataAccess(getServletContext());
				da.writeDevices(response.getWriter());
				return;
			}
			//Case 2: "devices/1" shall return the device with id=1
			//Here we may assume that pathInfo holds a valid device id with a / in front
			GeologDeviceID id = new GeologDeviceID(pathInfo.substring(1));
			response.setContentType("text/xml");
			GeologDataAccess da =	new GeologDataAccess(getServletContext());
			da.writeDevice(id, response.getWriter());
			return;
		}
		catch (Exception e) {
			response.sendError(500, "Internal error");
		}
  }

  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

	simpleResponse( "You called the DeviceServlet POST handler",
					request,
					response);
	return;
  }

   public void doPut(HttpServletRequest request,
                      HttpServletResponse response)
      throws IOException, ServletException {

	simpleResponse( "You called the DeviceServlet PUT handler",
					request,
					response);
	return;
   }

   private void simpleResponse( String title,
   								HttpServletRequest request,
   								HttpServletResponse response )
   		throws IOException, ServletException{

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<html>");
		out.println("<head>");
		out.println("<title>geolog</title>");
		out.println("</head>");
		out.println("<body>");
		out.println("<h1>");
		out.println( title );
		out.println("</h1>");
    out.println("Method: " + request.getMethod());
		out.println("<br/>");
    out.println("Request URI: " + request.getRequestURI());
		out.println("<br/>");
    out.println("Protocol: " + request.getProtocol());
		out.println("<br/>");
    out.println("PathInfo: " + request.getPathInfo());
		out.println("<br/>");
    out.println("Remote Address: " + request.getRemoteAddr());
		out.println("</body>");
		out.println("</html>");
		return;
   }
}
