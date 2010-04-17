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
import java.util.*;

public class Guestbook extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
    
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println("<html><head><title>Guest book</title></head><body>");

	// Retrieve the XML file path from the init param
	String xmlPath = getInitParameter("XMLPath");
	try {
	    // Load the content of the XML file. If the file does not exist
		// we simply create a new document with the correct root element
		Document d = loadXML(xmlPath);

		Element entries = d.getRootElement();
		
		// Create the table of entries
		out.println("<table border=1><tr><th>Name</th><th>Text</th></tr>");
		List entriesList =  entries.getChildren();
		Iterator i = entriesList.iterator();
		// Iterate through the entries and add them to the table one at a time.
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			String name = e.getChild("name").getText();
			String text = e.getChild("text").getText();
			out.println("<tr><td>" + htmlEscape(name) + "</td><td>" + htmlEscape(text) + "</td></tr>");
		}
		out.println("</table>");
	
		out.println("<br>");
		
		// Create the form for post back of a new entry.
		String url = request.getRequestURI();
		out.println("<form method=post action=\"" + response.encodeURL(url) + "\">");
		out.println("Please enter the new entry name: ");
		out.println("<input name=EntryName type=text><br>");
		out.println("Please enter the new entry text: ");
		out.println("<input name=EntryText type=text><br>");
		out.println("<input type=submit name=submit value=\"New entry\">");
		out.println("<br><br>");
		out.println("</form>");
	}
	catch (JDOMException ex) {
	    // If an error occur when parsing the XML file write a site down warning
		out.println("<h2>FAILURE PROCESSING XML FILE - SITE DOWN</h2>");
	}
	out.println("</body></html>");
  }

  // This method is a utility method used by both GET and POST and reads the 
  // XML document into memory with JDOM
  private Document loadXML(String xmlPath) throws JDOMException, IOException
  {
	File f = new File(xmlPath);
	SAXBuilder sx = new SAXBuilder();
	Document d;
	if (f.exists())
	{
	  d = sx.build(f);
	}
	else
	{
	  d = new Document();
	  Element root = new Element("entries");
	  d.setRootElement(root);
	}
	return d;
  }
  
  private String htmlEscape(String s) {
    StringBuffer b = new StringBuffer();
	for (int i = 0; i < s.length(); ++i) {
	  char c = s.charAt(i);
	  switch (c) {
	    case '<': b.append("&lt;"); break;
	    case '>': b.append("&gt;"); break;
	    case '"': b.append("&quot;"); break;
	    case '\'': b.append("&apos;"); break;
	    case '&': b.append("&amp;"); break;
		default: b.append(c);
	  }
	}
	return b.toString();
  }
  
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
	String entryName = request.getParameter("EntryName");
	String entryText = request.getParameter("EntryText");
	
	String xmlPath = getInitParameter("XMLPath");
	try {
	    // Load the document that must have the new entry added.
		// If the file does not exist a new document with correct root element is created
		Document d = loadXML(xmlPath);
		
		Element entries = d.getRootElement();

		// As the "only" way to post is to send these values (other than malicious posting, 
		// and we do not need to protect against that in this type of app.
		Element entry = new Element("entry");
		Element name = new Element("name");
		Element text = new Element("text");
		name.setText(entryName);
		text.setText(entryText);
		entry.addContent(name);
		entry.addContent(text);
		entries.addContent(entry);

		// Use XML outputter to write new entry to file
		// We merely override the file with the new complete XML
		XMLOutputter xout = new XMLOutputter();
		java.io.FileWriter writer = new java.io.FileWriter(xmlPath);
		xout.output(d, writer);
		writer.flush();
		writer.close();
		
		// Finish by performing the normal GET, as we want the entires to be displayed
		doGet(request, response);
	}
	catch (JDOMException ex) {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<html><head><title>Guest book</title></head><body>");
	    // If an error occur when parsing the XML file write a site down warning
		out.println("<h2>FAILURE PROCESSING XML FILE - SITE DOWN</h2>");
		out.println("</body></html>");
	}
  }
}
