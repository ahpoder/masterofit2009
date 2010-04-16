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
	out.println("<html><head><title>Number guessing game</title></head><body>");

	try
	{
		String xmlPath = getInitParameter("XMLPath");
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

		Element entries = d.getRootElement();
		
		String entryName = request.getParameter("EntryName");
		String entryText = request.getParameter("EntryText");
		if (entryName != null)
		{
		  Element entry = new Element("entry");
		  Element name = new Element("name");
		  Element text = new Element("text");
		  name.setText(entryName);
		  text.setText(entryText);
		  entry.addContent(name);
		  entry.addContent(text);
		  entries.addContent(entry);
		  
		  XMLOutputter xout = new XMLOutputter();
		  java.io.FileWriter writer = new java.io.FileWriter(xmlPath);
		  xout.output(d, writer);
		  writer.flush();
		  writer.close();
		}

		out.println("<table border=1><tr><th>Name</th><th>Text</th></tr>");
		List entriesList =  entries.getChildren();
		Iterator i = entriesList.iterator();
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			String name = e.getChild("name").getText();
			String text = e.getChild("text").getText();
			out.println("<tr><td>" + name + "</td><td>" + text + "</td></tr>");
		}
		out.println("</table>");
    }
	catch (JDOMException ex)
	{
		out.println("JDOM exception occured<br>");
	}
	out.println("<br>");
    
	String url = request.getRequestURI();
	out.println("<form method=get action=\"" + response.encodeURL(url) + "\">");
	out.println("Please enter the new entry name: ");
	out.println("<input name=EntryName type=text><br>");
	out.println("Please enter the new entry text: ");
	out.println("<input name=EntryText type=text><br>");
	out.println("<input type=submit name=submit value=\"New entry\">");
	out.println("<br><br>");
	out.println("</form>");
	out.println("<form method=post action=\"" + response.encodeURL(url) + "\">");
	out.println("<input type=submit name=submit value=\"Post back\">");
	out.println("</form>");
  }

  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
  }
}
