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

public class RecipeServer extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
    
	// Retrieve the XML file path from the init param (relative to the location of the servlet)
	String xmlPath = getInitParameter("RecipeXMLPath");
	try {
	    // Load the content of the XML file. If the file does not exist
		// we simply create a new document with the correct root element
		Document d = loadXML(xmlPath);
		if (d == null)
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "No recipes XML fil found");
		  return;
		}

	    String uri = request.getRequestURI();
		int reqStart = uri.indexOf("RecipeServer");
		if (reqStart == -1)
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "You managed to get the RecipeServer servlet to handle a non-RecipeServer request - impossible");
		  return;
		}
		uri = uri.substring(reqStart + 12);
		if (!uri.startsWith("/recipies/") && !uri.equals("/recipies"))
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid request URI - must begin with /recipies");
		  return;
		}
		if (uri.equals("/recipies") || uri.equals("/recipies/"))
		{
			response.setContentType("text/xml");
			XMLOutputter xo = new XMLOutputter();
			xo.output(d, response.getWriter());
		}
		else
		{
			String recipeName = uri.substring(reqStart + 10);
			// What if there is more than one???
		    Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[rcp:title='" + recipeName + "']");
			if (r == null)
			{
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe not found");
				return;
			}

			response.setContentType("text/xml");
			XMLOutputter xo = new XMLOutputter();
			xo.output(r, response.getWriter());
		}
	}
	catch (JDOMException ex) {
	    // If an error occur when parsing the XML file write a site down warning
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unkonwn server side error occured: " + ex.getMessage());
	}
  }

  // This method is a utility method used by both GET and POST and reads the 
  // XML document into memory with JDOM
  private Document loadXML(String xmlPath) throws JDOMException, IOException
  {
	File f = new File(xmlPath);
	SAXBuilder sx = new SAXBuilder();
	Document d = null;
	if (f.exists())
	{
	  d = sx.build(f);
	}
	else
	{
	  d = new Document();
	  // TODO copy rest.
	}
	return d;
  }
  
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
	  
	// Retrieve the XML file path from the init param (relative to the location of the servlet)
	String xmlPath = getInitParameter("RecipeXMLPath");
	String xmlSchemaPath = getInitParameter("RecipeSchemaXMLPath");
	try {
		SAXBuilder builder =
		  new SAXBuilder("org.apache.xerces.parsers.SAXParser", true);
		builder.setFeature(
		  "http://apache.org/xml/features/validation/schema", true);
		builder.setProperty(
		  "http://apache.org/xml/properties/schema/external-schemaLocation",
		  xmlSchemaPath);
		Document doc = builder.build(request.getInputStream());
		
	    Attribute id = (Attribute)XPath.selectSingleNode(doc, "//rcp:recipe/@id");
		
		Document d = loadXML(xmlPath);
		if (d == null)
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "No recipes XML fil found");
		  return;
		}
		
		Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[@id='" + id.getValue() + "']");

		if (r == null)
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe not found - use PUT to add a new recipe");
		  return;
		}

		d.removeContent(r);
		d.addContent(doc.getRootElement()); // TODO is this added the right place???
	}
	catch (JDOMException ex) {
	    // If an error occur when parsing the XML file write a site down warning
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unkonwn server side error occured: " + ex.getMessage());
	}
  }
  
    public void doPut(HttpServletRequest request,
                      HttpServletResponse response)
      throws IOException, ServletException {
	  
		// Retrieve the XML file path from the init param (relative to the location of the servlet)
		String xmlPath = getInitParameter("RecipeXMLPath");
		String xmlSchemaPath = getInitParameter("RecipeXMLSchemaPath");
		try {
			SAXBuilder builder =
			  new SAXBuilder("org.apache.xerces.parsers.SAXParser", true);
			builder.setFeature(
			  "http://apache.org/xml/features/validation/schema", true);
			builder.setProperty(
			  "http://apache.org/xml/properties/schema/external-schemaLocation",
			  xmlSchemaPath);
			Document doc = builder.build(request.getInputStream());
			
			Attribute id = (Attribute)XPath.selectSingleNode(doc, "//rcp:recipe/@id");
			
			Document d = loadXML(xmlPath);
			if (d == null)
			{
			  response.sendError(HttpServletResponse.SC_NOT_FOUND, "No recipes XML fil found");
			  return;
			}
			
			Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[@id='" + id.getValue() + "']");

			if (r != null)
			{
			  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe already exists - use POST to update a recipe");
			  return;
			}
			d.addContent(doc.getRootElement()); // TODO is this added the right place???
		}
		catch (JDOMException ex) {
			// If an error occur when parsing the XML file write a site down warning
			  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unkonwn server side error occured: " + ex.getMessage());
		}
	  
    }
    public void doDelete(HttpServletRequest request,
                         HttpServletResponse response)
      throws IOException, ServletException {

	  // Retrieve the XML file path from the init param (relative to the location of the servlet)
		String xmlPath = getInitParameter("RecipeXMLPath");
		String xmlSchemaPath = getInitParameter("RecipeSchemaXMLPath");
		try {
			SAXBuilder builder =
			  new SAXBuilder("org.apache.xerces.parsers.SAXParser", true);
			builder.setFeature(
			  "http://apache.org/xml/features/validation/schema", true);
			builder.setProperty(
			  "http://apache.org/xml/properties/schema/external-schemaLocation",
			  xmlSchemaPath);
			Document doc = builder.build(request.getInputStream());
			
			Attribute id = (Attribute)XPath.selectSingleNode(doc, "//rcp:recipe/@id");
			
			Document d = loadXML(xmlPath);
			if (d == null)
			{
			  response.sendError(HttpServletResponse.SC_NOT_FOUND, "No recipes XML fil found");
			  return;
			}
			
			Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[@id='" + id.getValue() + "']");

			if (r == null)
			{
			  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe not found - nothing to DELETE");
			  return;
			}

			d.removeContent(r);
		}
		catch (JDOMException ex) {
			// If an error occur when parsing the XML file write a site down warning
			  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unkonwn server side error occured: " + ex.getMessage());
		}
    }
}
