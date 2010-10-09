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

// Only required for gmap pre-processing
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;

public class DeviceServlet extends HttpServlet {

  public void init() throws ServletException {
        super.init();
        System.setProperty("javax.xml.transform.TransformerFactory", "net.sf.saxon.TransformerFactoryImpl");
  }

	// This method is used to move all from an input stream into a string
	// It is required to be able to do post-processing on the XSLT transformed webpage
	public static String slurp (InputStream in) throws IOException {
		StringBuffer out = new StringBuffer();
		byte[] b = new byte[4096];
		for (int n; (n = in.read(b)) != -1;) {
			out.append(new String(b, 0, n));
		}
		return out.toString();
	}

	// This is a debugging method to extract the stacktrace from an exception and place it in a string.
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
			// Get the supported query strings
			String deviceID = request.getParameter("id");
			String displayType = request.getParameter("type");
			// The id query string is mandatory,
			// If not found return an error.
			if (deviceID == null)
			{
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "No device ID supplied");
				return;
			}

			// Create the web service request based on the website request (device id)
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
			  //get the real path to the xsl file
			  String ctx = null;
			  // Basted on the type of request (the type query string) determine the XSLT to use
			  if (displayType == null) // No type, use standard text based
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT"));
			  }
			  else if (displayType.toLowerCase().equals("ajax")) // AJAX, text based with AJAX content update
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT_AJAX"));
			  }
			  else if (displayType.toLowerCase().equals("graph")) // GRAPH, graphical viewing of data with AJAX update
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT_GRAPH"));
			  }
			  else if (displayType.toLowerCase().equals("gmap")) // GMAP, show the movement of the device on gmap with AJAX update
			  {
			    ctx = getServletContext().getRealPath("/" + getInitParameter("DeviceXSLT_GMAP"));
			  }

			  // Verify that an XSLT file was found, otherwise return error
			  if (ctx == null)
			  {
				Debuglog.write("Internal error, invalid type");
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid type supplied");
				return;
			  }

			  // Get the XML response from the service as a string.
			  // This is only necesarry in order to be able to do pre-processing on the 
			  // data before the XSLT transformation. If pre-processing was not necesarry 
			  // one could simply use:
			  // Source xmlSource = new StreamSource(conn.getInputStream());
			  // to get the source for the transformation directly.
			  String xmlSourceText = slurp(conn.getInputStream());
			  
			  // Prepare variables for gmap (must be available later)
			  double maxLat = Double.MIN_VALUE;
			  double minLat = Double.MAX_VALUE;
			  double maxLng = Double.MIN_VALUE;
			  double minLng = Double.MAX_VALUE;
			  
			  // Only GMAP require pre-processing, so we determine if this is a gmap request
			  if (displayType.toLowerCase().equals("gmap"))
			  {
				// The gmap has the problem that it needs to determine the maximum zoom and 
				// optimal center for the map, and this required calculating the smallest possible
				// square that contains all points visited by the device, determining the middle of the 
				// containing square, and then calculate the highest zoom level that will show this.

				Namespace rootNS = Namespace.getNamespace("http://www.pa.com/geolog");
				Namespace kmlNS = Namespace.getNamespace("k", "http://www.opengis.net/kml/2.2");
				SAXBuilder builder = new SAXBuilder();
				StringReader sr = new StringReader(xmlSourceText);
				Document doc = builder.build(sr);
				Element root = doc.getRootElement();
				Element collection = root.getChild("geologCollection", rootNS);
				List geologs = collection.getChildren("geolog", rootNS);
				Iterator itt = geologs.iterator();
				while(itt.hasNext()) {
					Element geolog = (Element)itt.next();
					Element point = geolog.getChild("Point", kmlNS);
					Element coordinate = point.getChild("coordinates", kmlNS);
					String lngLatStr = coordinate.getText();
					StringTokenizer st = new StringTokenizer(lngLatStr, ",");
					String lngStr = st.nextToken().trim();
					String latStr = st.nextToken().trim();
					double lng = Double.parseDouble(lngStr);
					double lat = Double.parseDouble(latStr);
					if (lng > maxLng)
					{
						maxLng = lng;
					}
					if (lng < minLng)
					{
						minLng = lng;
					}
					if (lat > maxLat)
					{
						maxLat = lat;
					}
					if (lat < minLat)
					{
						minLat = lat;
					}
				}
				if (maxLat == Double.MAX_VALUE || minLat == Double.MIN_VALUE || maxLng == Double.MAX_VALUE || minLng == Double.MIN_VALUE)
				{
					maxLat = 55;
					minLat = 53;
					maxLng = 11;
					minLng = 9;
				}
			  }

			  // Prepare the XSLT file and input source
			  StringReader strReader = new StringReader(xmlSourceText);
			  Source xmlSource = new StreamSource(strReader);
			  Source xslSource = new StreamSource(new File(ctx));
			  // Generate the transformer.
			  TransformerFactory tFactory = TransformerFactory.newInstance();
			  Transformer transformer = tFactory.newTransformer(xslSource);

			  // Perform the actual XSLT transformation. We place the output
			  // in a string in order to be able to do post-processing on
			  // the result. If post-processing was not necesarry we could pipe the
			  // result directly into the response stream as:
			  // transformer.transform(xmlSource, new StreamResult(out));
			  ByteArrayOutputStream baos = new ByteArrayOutputStream();
			  PrintWriter ps = new PrintWriter(baos);
			  transformer.transform(xmlSource, new StreamResult(ps));
			  ps.flush();
			  String result = baos.toString();
			  
			  // If this request is for a graph then post processing is required
			  if (displayType != null && displayType.toLowerCase().equals("graph"))
			  {
			    // The graph has the problem that it does not readily display 
				// dateTime in the format supplied by the service, and XSLT tranformation
				// of dateTime into unix time proved very complex, and the required functions 
				// was not supported by the transformer, so instead it is done in Java.
				
				// Use regex to extract the sections that must be modified.
				Pattern p = Pattern.compile("!!DATETIME_START_TAG!!(.*?)!!DATETIME_END_TAG!!");
				Matcher m = p.matcher(result);

				StringBuffer sb = new StringBuffer();
				// Create a parser of the dateTime format
				SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.S");
				long firstTimeStamp = 0;
				// Loop all matches of the regex 
				while (m.find()) {
					// Extract dateTime
					String timestamp = m.group();
					timestamp = timestamp.substring(22, timestamp.length() - 20);

					// Transform it into unix-time
					Date d = parser.parse(timestamp);
					long ut = d.getTime() / 1000;

					// Save the first timestamp, as all timestamps will be relative to this.
					if (firstTimeStamp == 0)
					{
						firstTimeStamp = ut;
					}
					// Create the relative time from the first sample
					ut -= firstTimeStamp;

					// Write back the unix-time instead of the dateTime
					m.appendReplacement(sb, new Long(ut).toString());
				}
				// append any data after the last section
				m.appendTail(sb);
				// Write back the updated result to the result variable
				result = sb.toString();
			  }
			  // If this request is for a gmap then post processing is also required
			  else if (displayType != null && displayType.toLowerCase().equals("gmap"))
			  {
				// The gmap has the problem that it needs to determine the maximum zoom and 
				// optimal center for the map, and this required calculating the smallest possible
				// square that contains all points visited by the device, determining the middle of the 
				// containing square, and then calculate the highest zoom level that will show this.
				// This is simply too complicated in XSLT, so we do it in pre-processing and just 
				// insert it here.
				
				// Update the generated center and zoom at the correct sections in the result 
				// (this could be done more efficient).
				result = result.replace("!!MIN_LATTITUDE!!", Double.toString(minLat));
				result = result.replace("!!MAX_LATTITUDE!!", Double.toString(maxLat));
				result = result.replace("!!MIN_LONGITUDE!!", Double.toString(minLng));
				result = result.replace("!!MAX_LONGITUDE!!", Double.toString(maxLng));
			  }
			  // else for all other types no post-processing is required.
			  
			  // Write output to HTML response
			  out.print(result);
			}
			catch (Exception e)
			{
				// If an exception occur log the error and return an error to the sender.
				Debuglog.write("Internal error: " + e.getMessage());
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				PrintStream ps = new PrintStream(baos);
				e.printStackTrace(ps);
				ps.flush();
				Debuglog.write(baos.toString());
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal error: " + e.getMessage() + "|" + stack2string(e));
			}
			// Close the connection as the GET is completed
			out.close();
			conn.disconnect();
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
	No other request types are supported on this website
	**/
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
		response.sendError(HttpServletResponse.SC_NOT_FOUND, "POST not supported");
  }

	public void doPut(HttpServletRequest request,
              			HttpServletResponse response)
  		throws IOException, ServletException {
		response.sendError(HttpServletResponse.SC_NOT_FOUND, "PUT not supported");
	}
}
