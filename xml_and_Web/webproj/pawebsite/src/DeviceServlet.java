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
import java.util.regex.*;
import java.net.*;
import java.text.SimpleDateFormat;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;

public class DeviceServlet extends HttpServlet {

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
		try {
			String deviceID = request.getParameter("id");
			String displayType = request.getParameter("type");
			if (deviceID == null)
			{
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "No device ID supplied");
				return;
			}
		
			URL url = new URL("http://" + request.getServerName() + ":" + request.getServerPort() + "/geolog/devices/" + deviceID);
			HttpURLConnection conn = (HttpURLConnection)url.openConnection();
			conn.setRequestMethod("GET");
			conn.setAllowUserInteraction(false); // no user interact [like pop up]

			// The servlet returns HTML.
			response.setContentType("text/html; charset=UTF-8");    
			// Output goes in the response stream.
			PrintWriter out = response.getWriter();
			try
			{	
			  TransformerFactory tFactory = TransformerFactory.newInstance();
			  //get the real path for xsl files.
			  String ctx = null;
			  if (displayType == null)
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT"));
			  }
			  else if (displayType.toLowerCase().equals("ajax"))
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT_AJAX"));
			  }
			  else if (displayType.toLowerCase().equals("graph"))
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT_GRAPH"));
			  }
			  
			  if (ctx == null)
			  {
				Debuglog.write("Internal error, invalid type");
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid type supplied");
				return;
			  }
				
			  // Get the XML input document and the stylesheet.
			  Source xmlSource = new StreamSource(conn.getInputStream());
			  Source xslSource = new StreamSource(new File(ctx));
			  // Generate the transformer.
			  Transformer transformer = tFactory.newTransformer(xslSource);
			  // Perform the transformation, sending the output to the response.

			  // This is a short-hand version, but as we need to do post-processing it is not possible
			  //transformer.transform(xmlSource, new StreamResult(out));
			  
			  ByteArrayOutputStream baos = new ByteArrayOutputStream();
			  PrintWriter ps = new PrintWriter(baos);
			  transformer.transform(xmlSource, new StreamResult(ps));
			  ps.flush();
			  String result = baos.toString();
			  if (displayType.toLowerCase().equals("graph"))
			  {
				Pattern p = Pattern.compile("!!DATETIME_START_TAG!!(.*?)!!DATETIME_END_TAG!!");
				Matcher m = p.matcher(result);
								
				StringBuffer sb = new StringBuffer();
				SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.S");  
 				while (m.find()) {
					String timestamp = m.group();
					timestamp = timestamp.substring(22, timestamp.length() - 20);
					
					Date d = parser.parse(timestamp);
					long ut = d.getTime() / 1000;
					
//					long startTimestamp = System.currentTimeMillis() / 1000;

					Debuglog.write("Found timestamp: " + timestamp + " and converted it to: " + ut);
					
					m.appendReplacement(sb, new Long(ut).toString());
					// m.group(), m.start(), m.end()
				}
				m.appendTail(sb);
				result = sb.toString();
			  }
			  
			  out.print(result);
			}
			catch (Exception e)
			{
				Debuglog.write("Internal error: " + e.getMessage());
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				PrintStream ps = new PrintStream(baos);
				e.printStackTrace(ps);
				ps.flush();
				Debuglog.write(baos.toString());
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal error: " + e.getMessage());
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
