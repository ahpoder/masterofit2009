/*
   This servlet illustrates the differences between
   various scope levels i Servlets.

   Open this servlet in two different browser windows
   and reload their contents repeatedly. Explain how
   and why the different numbers change their values.
*/

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;
import java.net.*;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;

public class DevicesServlet extends HttpServlet {

  public void init() throws ServletException {
        super.init();
        System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
  }

	public static String stack2string(Exception e) {
	  try {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		e.printStackTrace(pw);
		return "------\r\n" + sw.toString() + "------\r\n";
	  }
	  catch(Exception e2) {
		return "bad stack2string";
	  }
	 }
 
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
		try {
			//Find out what to return
			String returnType = request.getParameter("type");

			URL url = new URL("http://" + request.getServerName() + ":" + request.getServerPort() + "/geolog/devices");
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setRequestMethod("GET");
			conn.setAllowUserInteraction(false); // no user interact [like pop up]

			// The servlet returns HTML.
			if (returnType == null)
			{
				response.setContentType("text/html; charset=UTF-8");
			}
			else if (returnType.toLowerCase().equals("kml"))
			{
				response.setContentType("text/xml; charset=UTF-8");
			}
			else if (returnType.toLowerCase().equals("markers"))
			{
				response.setContentType("text/xml; charset=UTF-8");
			}
			else
			{
				Debuglog.write("Internal error, invalid return type supplied to DevicesServlet");
				response.sendError(HttpServletResponse.SC_NOT_FOUND, String.format("Invalid return type supplied (" + returnType + ")"));
				return;
			}

			// Output goes in the response stream.
			PrintWriter out = response.getWriter();
			try
			{
			  //get the real path for xsl files.
			  String ctx = null;
			  if (returnType == null)
			  {
			  	ctx = getServletContext().getRealPath("/" + getInitParameter("DevicesXSLT"));
				}
			  else if (returnType.toLowerCase().equals("kml"))
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DevicesXSLT_KML"));
			  }
			  else if (returnType.toLowerCase().equals("markers"))
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DevicesXSLT_Markers"));
			  }
			  else
			  {
					Debuglog.write("Internal error, invalid return type supplied to DevicesServlet");
					response.sendError(HttpServletResponse.SC_NOT_FOUND, String.format("Invalid return type supplied (%1$)", returnType));
					return;
			  }
			  // Get the XML input document and the stylesheet.
			  Source xmlSource = new StreamSource(conn.getInputStream());
			  Source xslSource = new StreamSource(new File(ctx));
			  // Generate the transformer.
				TransformerFactory tFactory = TransformerFactory.newInstance();
			  Transformer transformer = tFactory.newTransformer(xslSource);
			  // Perform the transformation, sending the output to the response.
			  transformer.transform(xmlSource, new StreamResult(out));
			}
			catch (Exception e)
			{
				Debuglog.write("Internal error: " + e.getMessage());
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				PrintStream ps = new PrintStream(baos);
				e.printStackTrace(ps);
				ps.flush();
				Debuglog.write(baos.toString());
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal error: " + e.getMessage() + "|" + stack2string(e));
			}
			out.close();
			conn.disconnect();
			Debuglog.write("DONE");
		}
		catch (Exception e) {
			//TODO: Remove exposure of internal exceptions to the caller
			Debuglog.write("Internal error: " + e.getMessage());
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			PrintStream ps = new PrintStream(baos);
			e.printStackTrace(ps);
			ps.flush();
			Debuglog.write(baos.toString());
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal error2: " + e.getMessage() + "|" + stack2string(e));
		}
  }

	/**
		POST device readings for a specified ID. The caller knows the id.
		The device ID must be specified on the request path
	**/
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

	  simpleResponse( "You called the DevicesServlet POST handler. NOT IMPLEMENTED",
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
