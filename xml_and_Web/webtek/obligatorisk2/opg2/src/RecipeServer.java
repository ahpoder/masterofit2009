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
			CharArrayWriter caw = new CharArrayWriter();
			xo.output(d, caw); // We could have written directly to the stream as xo.output(d, response.getWriter()) but then we would not be able to set the length
			char[] temp = caw.toCharArray();
			response.setContentLength(temp.length);
			response.getWriter().write(temp, 0, temp.length);
		}
		else
		{
			String recipeName = uri.substring(reqStart + 9);
			recipeName = URLDecoder.decode(recipeName, "UTF-8");
			// What if there is more than one???
		    Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[rcp:title='" + recipeName + "']");
			if (r == null)
			{
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe not found: " + recipeName);
				return;
			}

			response.setContentType("text/xml");
			XMLOutputter xo = new XMLOutputter();
			CharArrayWriter caw = new CharArrayWriter();
			xo.output(r, caw); // We could have written directly to the stream as xo.output(d, response.getWriter()) but then we would not be able to set the length
			char[] temp = caw.toCharArray();
			response.setContentLength(temp.length);
			response.getWriter().write(temp, 0, temp.length);
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
	String xmlSchemaPath = getInitParameter("RecipeXMLSchemaPath");
	try {
		SAXBuilder builder;
		builder = new SAXBuilder();
		builder.setValidation(true);
		builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
		"http://www.w3.org/2001/XMLSchema");
		builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
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
		
		Element eCollection = d.getRootElement(); // Root (the document itself)
		Element eRecipe = doc.getRootElement();
		if (!eCollection.removeContent(r)) {
		  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Failure deleting recipe");
		  return;
		}
		
		if (eCollection.addContent((Element)eRecipe.clone()) == null) {
		  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Failure adding recipe");
		  return;
		}
		
		XMLOutputter xout = new XMLOutputter();
		java.io.FileWriter xwriter = new java.io.FileWriter(xmlPath);
		xout.output(d, xwriter);
		xwriter.flush();
		xwriter.close();

		String resp = "Recipe successfully updated";
		response.setContentLength(resp.length());
		response.getWriter().write(resp);
	}
	catch (JDOMException ex) {
	    // If an error occur when parsing the XML file write a site down warning
		  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Unkonwn server side error occured: " + ex.getMessage());
	}
  }
  
    public void doPut(HttpServletRequest request,
                      HttpServletResponse response)
      throws IOException, ServletException {

		// Retrieve the XML file path from the init param (relative to the location of the servlet)
		String xmlPath = getInitParameter("RecipeXMLPath");
		String xmlSchemaPath = getInitParameter("RecipeXMLSchemaPath");
		try {
			SAXBuilder builder;
			builder = new SAXBuilder();
			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
			"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
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
			  response.sendError(HttpServletResponse.SC_BAD_REQUEST , "Recipe with supplied ID already exists");
			  return;
			}
			
			Element eCollection = d.getRootElement(); // Root (the document itself)
			Element eRecipe = doc.getRootElement();
			
			if (eCollection.addContent((Element)eRecipe.clone()) == null) {
			  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Failure adding recipe");
			  return;
			}
			
			XMLOutputter xout = new XMLOutputter();
			java.io.FileWriter xwriter = new java.io.FileWriter(xmlPath);
			xout.output(d, xwriter);
			xwriter.flush();
			xwriter.close();

			String resp = "Recipe successfully added";
			response.setContentLength(resp.length());
			response.getWriter().write(resp);
		}
		catch (JDOMException ex) {
			// TODO we should c heck if it is a schema violation or something else that triggered the exception:
			// Schema violation => SC_BAD_REQUEST
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Unkonwn server side error occured: " + ex.getMessage());
		}
    }
    public void doDelete(HttpServletRequest request,
                         HttpServletResponse response)
      throws IOException, ServletException {

		// Retrieve the XML file path from the init param (relative to the location of the servlet)
		String xmlPath = getInitParameter("RecipeXMLPath");
		String xmlSchemaPath = getInitParameter("RecipeXMLSchemaPath");
		try {
			SAXBuilder builder;
			builder = new SAXBuilder();
			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
			"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
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
			  response.sendError(HttpServletResponse.SC_NOT_FOUND , "Recipe with supplied ID not found");
			  return;
			}
			
			Element eCollection = d.getRootElement(); // Root (the document itself)
			Element eRecipe = doc.getRootElement();
			
			if (!eCollection.removeContent(r)) {
			  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Failure deleting recipe");
			  return;
			}
			
			XMLOutputter xout = new XMLOutputter();
			java.io.FileWriter xwriter = new java.io.FileWriter(xmlPath);
			xout.output(d, xwriter);
			xwriter.flush();
			xwriter.close();

			String resp = "Recipe successfully deleted";
			response.setContentLength(resp.length());
			response.getWriter().write(resp);
		}
		catch (JDOMException ex) {
			// TODO we should c heck if it is a schema violation or something else that triggered the exception:
			// Schema violation => SC_BAD_REQUEST
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Unkonwn server side error occured: " + ex.getMessage());
		}
    }
}
