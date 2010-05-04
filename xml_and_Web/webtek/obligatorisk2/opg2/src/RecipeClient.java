import java.io.*;
import java.util.Random;
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
import org.jdom.xpath.*;
import java.util.*;
import java.net.*;

public class RecipeClient {
    private String host;
    private Integer port;
	public RecipeClient(String hostAndPort) throws IOException {
		StringTokenizer st = new StringTokenizer(hostAndPort, ":");
		if (st.countTokens() != 2)
			throw new IOException("Invalid argument format: " + hostAndPort);
		this.host = st.nextToken();
		this.port = Integer.parseInt(st.nextToken());
	}
	
	public static void printUsage() {
		System.out.println("Usage: java RecipeClient <host>:<port>");
	}
	
	public void printMenu() {
		System.out.println();
		System.out.println("1. Send GET");
		System.out.println("2. Send POST");
		System.out.println("3. Send PUT");
		System.out.println("4. Send DELETE");
		System.out.println("0. Exit");
		System.out.println();
		System.out.print("Select: ");
	}
	
	public void performGet(String str) {
		try {
		  //Set up the connection
		  Socket con = new Socket(host, port);
		  
		  //Send the request on the connection outputstream (based on IXVT p. 375)
		  BufferedWriter out =
			  new BufferedWriter
				 (new OutputStreamWriter(con.getOutputStream(), "UTF8"));
		  //We're interested in the host root only
		  if (str == null || str.length() == 0) {
			out.write("GET /RecipeServer/recipies HTTP/1.1\r\n");
		  }
		  else {
			out.write("GET /RecipeServer/recipies/" + URLEncoder.encode(str, "UTF-8") + " HTTP/1.1\r\n");
		  }
		  //The Host header is required (at least at the tested site: www.brics.dk)
		  out.write("Host: " + host + "\r\n"); 
		  //This one is merely to inform the server. It is NOT required for the request to be valid
		  out.write("User-Agent: IXVT\r\n");
		  //Signal GET request termination with an empty line. This one is required for the request to be valid.
		  //If it is missing we just be waiting "forever" for a server response
		  out.write("\r\n"); 
		  out.flush();
		  
		  //Get a handle on the server response      
		  BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

		  System.out.println("Result: ");
		  int i = -2;
		  int length = -1;
		  boolean headerReceived = false;
		  CharArrayWriter buffer = new CharArrayWriter();
		  char[] tempBuffer = new char[1024];
		  while (i < length) {
			if (!headerReceived) {
				String line = in.readLine();
				System.out.println(line);
				if (line.indexOf("Content-Length: ") != -1) {
					length = Integer.parseInt(line.substring(16));
					i = 0;
				}
				else if (line.length() == 0) { // blank line indicates seperation between header and payload
					headerReceived = true;
				}
			}
			else {
				int temp = in.read(tempBuffer, 0, tempBuffer.length);
				if (temp > 0)
				{
					buffer.write(tempBuffer, 0, temp);
					if (length > 0) { // Only count up if we have a length
						i += temp;
					}
				}
				else {
					break;
				}
			}
		  }
		  
		  if (length > 0 && i < length) { // error
			System.err.println("Failure received full payload");
		  }
		  else {
			char[] temp = buffer.toCharArray();
			System.out.println(new String(temp, 0, temp.length));
		  }

		  //Do a clean up of the resources
		  con.close();
		} catch (IOException e) {
		  System.err.println(e);
		}
	}
	
	public void performPost(String str) {
		try {
		  //Set up the connection
		  Socket con = new Socket(host, port);
		  
		  //Send the request on the connection outputstream (based on IXVT p. 375)
		  BufferedWriter out =
			  new BufferedWriter
				 (new OutputStreamWriter(con.getOutputStream(), "UTF8"));
		  //We're interested in the host root only
		  
		  out.write("POST /RecipeServer/recipies HTTP/1.1\r\n");

		  //The Host header is required (at least at the tested site: www.brics.dk)
		  out.write("Host: " + host + "\r\n"); 
		  //This one is merely to inform the server. It is NOT required for the request to be valid
		  out.write("User-Agent: IXVT\r\n");
		  
			SAXBuilder builder;
			builder = new SAXBuilder();
			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
			"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
			"C:\\db\\recipes.xsd");

		    Document doc = builder.build(new StringReader(str));

			XMLOutputter xo = new XMLOutputter();
			CharArrayWriter caw = new CharArrayWriter();
			xo.output(doc, caw); // We could have written directly to the stream as xo.output(d, response.getWriter()) but then we would not be able to set the length
			char[] tempDoc = caw.toCharArray();

			out.write("Content-Type: text/xml\r\n");
			out.write("Content-Length: " + tempDoc.length + "\r\n");
			
		  //Signal POST termination with an empty line. This one is required for the request to be valid.
		  //If it is missing we just be waiting "forever" for a server response
		  out.write("\r\n"); 
		  
		  out.write(tempDoc, 0, tempDoc.length);
		  out.flush();

		  //Get a handle on the server response      
		  BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

		  System.out.println("Result: ");
		  int i = -2;
		  int length = -1;
		  boolean headerReceived = false;
		  CharArrayWriter buffer = new CharArrayWriter();
		  char[] tempBuffer = new char[1024];
		  while (i < length) {
			if (!headerReceived) {
				String line = in.readLine();
				System.out.println(line);
				if (line.indexOf("Content-Length: ") != -1) {
					length = Integer.parseInt(line.substring(16));
					i = 0;
				}
				else if (line.length() == 0) { // blank line indicates seperation between header and payload
					headerReceived = true;
				}
			}
			else {
				int temp = in.read(tempBuffer, 0, tempBuffer.length);
				if (temp > 0)
				{
					buffer.write(tempBuffer, 0, temp);
					if (length > 0) { // Only count up if we have a length
						i += temp;
					}
				}
				else {
					break;
				}
			}
		  }
		  
		  if (length > 0 && i < length) { // error
			System.err.println("Failure received full payload");
		  }
		  else {
			char[] temp = buffer.toCharArray();
			System.out.println(new String(temp, 0, temp.length));
		  }

		  //Do a clean up of the resources
		  con.close();
		} catch (IOException e) {
		  System.err.println(e);
		} catch (JDOMException e) {
		  System.err.println(e);
		}
	}
	
	public void performPut(String str) {
		try {
		  //Set up the connection
		  Socket con = new Socket(host, port);
		  
		  //Send the request on the connection outputstream (based on IXVT p. 375)
		  BufferedWriter out =
			  new BufferedWriter
				 (new OutputStreamWriter(con.getOutputStream(), "UTF8"));
		  //We're interested in the host root only
		  
		  out.write("PUT /RecipeServer/recipies HTTP/1.1\r\n");

		  //The Host header is required (at least at the tested site: www.brics.dk)
		  out.write("Host: " + host + "\r\n"); 
		  //This one is merely to inform the server. It is NOT required for the request to be valid
		  out.write("User-Agent: IXVT\r\n");

		  System.out.println("Document: " + str);
		  
			SAXBuilder builder;
			builder = new SAXBuilder();
			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
			"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
			"C:\\db\\recipes.xsd");

		    Document doc = builder.build(new StringReader(str));

			XMLOutputter xo = new XMLOutputter();
			CharArrayWriter caw = new CharArrayWriter();
			xo.output(doc, caw); // We could have written directly to the stream as xo.output(d, response.getWriter()) but then we would not be able to set the length
			char[] tempDoc = caw.toCharArray();

			out.write("Content-Type: text/xml\r\n");
			out.write("Content-Length: " + tempDoc.length + "\r\n");
			
		  //Signal POST termination with an empty line. This one is required for the request to be valid.
		  //If it is missing we just be waiting "forever" for a server response
		  out.write("\r\n"); 
		  
		  out.write(tempDoc, 0, tempDoc.length);
		  out.flush();

		  //Get a handle on the server response      
		  BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

		  System.out.println("\r\nResult: ");
		  int i = -2;
		  int length = -1;
		  boolean headerReceived = false;
		  CharArrayWriter buffer = new CharArrayWriter();
		  char[] tempBuffer = new char[1024];
		  while (i < length) {
			if (!headerReceived) {
				String line = in.readLine();
				System.out.println(line);
				if (line.indexOf("Content-Length: ") != -1) {
					length = Integer.parseInt(line.substring(16));
					i = 0;
				}
				else if (line.length() == 0) { // blank line indicates seperation between header and payload
					headerReceived = true;
				}
			}
			else {
				int temp = in.read(tempBuffer, 0, tempBuffer.length);
				if (temp > 0)
				{
					buffer.write(tempBuffer, 0, temp);
					if (length > 0) { // Only count up if we have a length
						i += temp;
					}
				}
				else {
					break;
				}
			}
		  }
		  
		  if (length > 0 && i < length) { // error
			System.err.println("Failure received full payload");
		  }
		  else {
			char[] temp = buffer.toCharArray();
			System.out.println(new String(temp, 0, temp.length));
		  }

		  //Do a clean up of the resources
		  con.close();
		} catch (IOException e) {
		  System.err.println(e);
		} catch (JDOMException e) {
		  System.err.println(e);
		}
	}

	public void performDelete(String str) {
		try {
		  //Set up the connection
		  Socket con = new Socket(host, port);
		  
		  //Send the request on the connection outputstream (based on IXVT p. 375)
		  BufferedWriter out =
			  new BufferedWriter
				 (new OutputStreamWriter(con.getOutputStream(), "UTF8"));
		  //We're interested in the host root only
		  
		  out.write("DELETE /RecipeServer/recipies HTTP/1.1\r\n");

		  //The Host header is required (at least at the tested site: www.brics.dk)
		  out.write("Host: " + host + "\r\n"); 
		  //This one is merely to inform the server. It is NOT required for the request to be valid
		  out.write("User-Agent: IXVT\r\n");

		  System.out.println("Document: " + str);
		  
			SAXBuilder builder;
			builder = new SAXBuilder();
			builder.setValidation(true);
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaLanguage",
			"http://www.w3.org/2001/XMLSchema");
			builder.setProperty("http://java.sun.com/xml/jaxp/properties/schemaSource",
			"C:\\db\\recipes.xsd");

		    Document doc = builder.build(new StringReader(str));

			XMLOutputter xo = new XMLOutputter();
			CharArrayWriter caw = new CharArrayWriter();
			xo.output(doc, caw); // We could have written directly to the stream as xo.output(d, response.getWriter()) but then we would not be able to set the length
			char[] tempDoc = caw.toCharArray();

			out.write("Content-Type: text/xml\r\n");
			out.write("Content-Length: " + tempDoc.length + "\r\n");
			
		  //Signal POST termination with an empty line. This one is required for the request to be valid.
		  //If it is missing we just be waiting "forever" for a server response
		  out.write("\r\n"); 
		  
		  out.write(tempDoc, 0, tempDoc.length);
		  out.flush();

		  //Get a handle on the server response      
		  BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

		  System.out.println("Result: ");
		  int i = -2;
		  int length = -1;
		  boolean headerReceived = false;
		  CharArrayWriter buffer = new CharArrayWriter();
		  char[] tempBuffer = new char[1024];
		  while (i < length) {
			if (!headerReceived) {
				String line = in.readLine();
				System.out.println(line);
				if (line.indexOf("Content-Length: ") != -1) {
					length = Integer.parseInt(line.substring(16));
					i = 0;
				}
				else if (line.length() == 0) { // blank line indicates seperation between header and payload
					headerReceived = true;
				}
			}
			else {
				int temp = in.read(tempBuffer, 0, tempBuffer.length);
				if (temp > 0)
				{
					buffer.write(tempBuffer, 0, temp);
					if (length > 0) { // Only count up if we have a length
						i += temp;
					}
				}
				else {
					break;
				}
			}
		  }
		  
		  if (length > 0 && i < length) { // error
			System.err.println("Failure received full payload");
		  }
		  else {
			char[] temp = buffer.toCharArray();
			System.out.println(new String(temp, 0, temp.length));
		  }

		  //Do a clean up of the resources
		  con.close();
		} catch (IOException e) {
		  System.err.println(e);
		} catch (JDOMException e) {
		  System.err.println(e);
		}
	}

	public static void main (String args[]) {
		if (args.length < 1) {
			RecipeClient.printUsage();
			return;
		}
		
		try
		{
			RecipeClient rc = new RecipeClient(args[0]);
			
			int selection = 0;
			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
			do
			{
				rc.printMenu();
				selection = Integer.parseInt(br.readLine());
				switch (selection)
				{
				  case 1:
				  {
					System.out.print("\nEnter title to request (empty string for all): ");
					String title = br.readLine();
					rc.performGet(title);
				  }
				  break;
				  case 2:
				  {
					System.out.print("\nEnter recipe to update (entire XML on a single line): ");
					String xml = br.readLine();
					rc.performPost(xml);
				  }
				  break;
				  case 3:
				  {
					System.out.print("\nEnter recipe to put (entire XML on a single line): ");
					String xml = br.readLine();
					rc.performPut(xml);
				  }
				  break;
				  case 4:
				  {
					System.out.print("\nEnter recipe to delete (entire XML on a single line): ");
					String xml = br.readLine();
					rc.performDelete(xml);
				  }
				  break;
				}
			}
			while (selection != 0);
		}
		catch (IOException ex)
		{
		  System.err.println(ex);
		}
	}
}