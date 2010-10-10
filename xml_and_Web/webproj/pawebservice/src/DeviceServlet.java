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

	/**Self descriptive string.
	*/
	public String getServletInfo(){
		return "Web-project Autumn 2010: PA Web-service servlet to handle device requests (/devices and /device/...). Author: XX, Version: XX, Copyright:XX";
	}

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
				Debuglog.write("On POSTing a device id is required in the URI");
				return;
			}

			//When we're here the request is known to contain something.that's expected to be a device id
			//Validate the part that might be an id
			if (!GeologDeviceID.isValidID(pathInfo.substring(1))) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "The supplied device id ("+ pathInfo.substring(1) + ") does not match the expected ID pattern");
				Debuglog.write("The supplied device id ("+ pathInfo.substring(1) + ") does not match the expected ID pattern");
				return;
			}
			//Get and validate the payload
			String xmlSchemaPath = getServletContext().getRealPath("/" + getInitParameter("DeviceXSDFile"));
			SAXBuilder builder = new SAXBuilder();

			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
													"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
													xmlSchemaPath);
													
			Document doc = builder.build(request.getInputStream());

			//Send the payload to the data access handler
			GeologDeviceID id = new GeologDeviceID(pathInfo.substring(1));
			GeologDataAccess da = new GeologDataAccess(getServletContext());
			da.storeDevice(id, doc);

			Debuglog.write("POST DONE");
		}
		catch (Exception e) {
			//TODO: Remove exposure of internal exceptions to the caller
			response.sendError(500, "Internal error: " + e.getMessage());
			Debuglog.write("Internal error: " + e.getMessage());
			try
			{
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				PrintStream ps = new PrintStream(baos);
				e.printStackTrace(ps);
				ps.flush();
				Debuglog.write(baos.toString());
			}
			catch (Exception ex)
			{
				Debuglog.write("Error writing error: " + e.getMessage());
			}
		}
  }

	public void doPut(HttpServletRequest request,
              			HttpServletResponse response)
  		throws IOException, ServletException {

		response.sendError(HttpServletResponse.SC_NOT_FOUND, "PUT not supported");
		return;
	}
}
