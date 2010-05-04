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

		// Retrieve the URI
	    String uri = request.getRequestURI();
		int reqStart = uri.indexOf("RecipeServer");
		if (reqStart == -1) // Extra, unnecesarry, check.
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "You managed to get the RecipeServer servlet to handle a non-RecipeServer request - impossible");
		  return;
		}
		// Remove the RecipeServer part
		uri = uri.substring(reqStart + 12);
		// Verify that the request begins with /recepies (otherwise malformed)
		if (!uri.startsWith("/recipies/") && !uri.equals("/recipies"))
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid request URI - must begin with /recipies");
		  return;
		}
		// Determine if we are to list all recipies
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
		// Or just the Recipe in question
		else
		{
			// Remove the /recipies/
			String recipeName = uri.substring(reqStart + 9);
			// Decode the recipe name
			recipeName = URLDecoder.decode(recipeName, "UTF-8");
			// Use XPath to find the recipe with the given title
			// TODO What if there is more than one???
		    Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[rcp:title='" + recipeName + "']");
			// If no recipe is found return error
			if (r == null)
			{
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe not found: " + recipeName);
				return;
			}

			// Write found recipe to requester.
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
	    // An unspecified server error occured, e.g. missing jar
		  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unkonwn server side error occured: " + ex.getMessage());
	}
  }

  // This method is a utility method used by both GET and POST and reads the 
  // XML document into memory with JDOM
  private Document loadXML(String xmlPath) throws JDOMException, IOException
  {
	File f = new File(xmlPath);
	SAXBuilder sx = new SAXBuilder();
	Document d = null;
	if (f.exists()) {
	  d = sx.build(f);
	}
	else {
	  // Creation af a new well-formed recipe-xml document is not 
	  // implemented.
	  throw new IOException("Recipe XML Document missing");
	}
	return d;
  }
  
  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

	// Retrieve the XML file path and XML Schema path from the init param
	String xmlPath = getInitParameter("RecipeXMLPath");
	String xmlSchemaPath = getInitParameter("RecipeXMLSchemaPath");
	try {
		// Set the schema in the SAXBuilder for validation
		SAXBuilder builder;
		builder = new SAXBuilder();
		builder.setValidation(true);
		builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
		"http://www.w3.org/2001/XMLSchema");
		builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
		xmlSchemaPath);

		// Parse the received POST and validate against XML Schema
        Document doc = builder.build(request.getInputStream());

		// Retrieve the id attribute of the recipe
	    Attribute id = (Attribute)XPath.selectSingleNode(doc, "//rcp:recipe/@id");
		
		// Load the Recipe XML
		Document d = loadXML(xmlPath);
		if (d == null)
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "No recipes XML fil found");
		  return;
		}
		
		// Locate the Recipe with the given ID
		Element r = (Element)XPath.selectSingleNode(d, "//rcp:recipe[@id='" + id.getValue() + "']");

		// If non is found it is considered an invalid POST request.
		if (r == null)
		{
		  response.sendError(HttpServletResponse.SC_NOT_FOUND, "Recipe not found - use PUT to add a new recipe");
		  return;
		}
		
		// Otherwise delete the existing recipe and add the new one.
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
		
		// Write the canges to the file
		XMLOutputter xout = new XMLOutputter();
		java.io.FileWriter xwriter = new java.io.FileWriter(xmlPath);
		xout.output(d, xwriter);
		xwriter.flush();
		xwriter.close();

		// Write response to requester
		String resp = "Recipe successfully updated";
		response.setContentLength(resp.length());
		response.getWriter().write(resp);
	}
	catch (JDOMException ex) {
	    // An unspecified server error occured, e.g. missing jar
		// TODO we should check if it is a schema violation or something else that triggered the exception:
		// Schema violation => SC_BAD_REQUEST
		  response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Unkonwn server side error occured: " + ex.getMessage());
	}
  }
  
    public void doPut(HttpServletRequest request,
                      HttpServletResponse response)
      throws IOException, ServletException {

		// Please see doPost for a description of the individual parts of this method
	  
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
			// TODO we should check if it is a schema violation or something else that triggered the exception:
			// Schema violation => SC_BAD_REQUEST
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR , "Unkonwn server side error occured: " + ex.getMessage());
		}
    }
    public void doDelete(HttpServletRequest request,
                         HttpServletResponse response)
      throws IOException, ServletException {

		// Please see doPost for a description of the individual parts of this method

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
