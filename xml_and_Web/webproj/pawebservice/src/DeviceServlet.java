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
			//TODO: Remove exposure of internal exceptions to the caller
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal error: " + e.getMessage());
		}
  }

	/**
		POST device readings for a specified ID. The caller knows the id.
		The device ID must be specified on the request path
	**/
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

		try {

			//The server has taken care of redirecting "/devices" and "/devices/*" to this servlet
			//A POST request require a device id on the path
			String pathInfo = request.getPathInfo();
			//No device id specified. Get out of here with a clear message.
			if((pathInfo == null) || (pathInfo.length() == 1)) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "On POSTing a device id is required in the URI");
				return;
			}

			//When we're here the request is known to contain something.that's expected to be a device id
			//Validate the part that might be an id
			if (!GeologDeviceID.isValidID(pathInfo.substring(1))) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "The supplied device id ("+ pathInfo.substring(1) + ") does not match the expected ID pattern");
				return;
			}
			//Get and validate the payload
			String xmlSchemaPath = getServletContext().getRealPath("/" + getServletContext().getInitParameter("DeviceXSDFile"));
			SAXBuilder builder;
			builder = new SAXBuilder();
			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
													"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
													xmlSchemaPath);
			Document doc = builder.build(request.getInputStream());

			//Send the payload to the data access handler
			GeologDeviceID id = new GeologDeviceID(pathInfo.substring(1));
			GeologDataAccess da =	new GeologDataAccess(getServletContext());
			da.storeDevice(id, doc);
		}
		catch (Exception e) {
			//TODO: Remove exposure of internal exceptions to the caller
			response.sendError(500, "Internal error: " + e.getMessage());
		}
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
