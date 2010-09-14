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
import java.util.*;
import java.net.*;

public class DeviceServlet extends HttpServlet {

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
/*
		try {
			//The server has taken care of redirecting "devices" and "devices/*" to this servlet
			//The distinction may be made on the request.getPathInfo()
			String pathInfo = request.getPathInfo();

			//Case 1: "devices" and devices/" shall return all devices
			if ((pathInfo == null) || (pathInfo.equals("/"))) {
				response.setContentType("text/xml");
				GeologDataAccess da =	new GeologDataAccess(getServletContext());
				// Write the URL to use for details about the devices registered with the system. The serverName and port is 
				// required to build these URLs.
				da.writeDevices("http://" + request.getServerName() + ":" + request.getServerPort(), response.getWriter());
				return;
			}
			//Case 2: "devices/1" shall return the device with id=1
			// Here we may assume that pathInfo holds a valid device id with a / in front
			GeologDeviceID id = new GeologDeviceID(pathInfo.substring(1));
			response.setContentType("text/xml");
			GeologDataAccess da =	new GeologDataAccess(getServletContext());
			// Write the device details in the response. If the device ID is not know 
			// simply return false, which triggers a resource not found error response.
			if (!da.writeDevice(id, response.getWriter()))
			{
				response.sendError(HttpServletResponse.SC_NOT_FOUND , "Device with ID (" + id.toString() + ") not found");
			}
		}
		catch (Exception e) {
			//TODO: Remove exposure of internal exceptions to the caller
			Debuglog.write("Internal error: " + e.getMessage());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal error: " + e.getMessage());
		}
*/
  }

	/**
		POST device readings for a specified ID. The caller knows the id.
		The device ID must be specified on the request path
	**/
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
		simpleResponse( "You called the DeviceServlet POST handler. NOT IMPLEMENTED",
							request,
							response);
  }

	public void doPut(HttpServletRequest request,
              			HttpServletResponse response)
  		throws IOException, ServletException {

		simpleResponse( "You called the DeviceServlet PUT handler. NOT IMPLEMENTED",
							request,
							response);
		return;
	}

	/**
		Internal member to create a usable output when request handlers aren't implemented
	**/
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
