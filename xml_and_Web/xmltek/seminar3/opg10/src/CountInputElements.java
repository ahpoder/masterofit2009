import java.io.IOException;
import java.io.PrintStream;
import java.net.URL;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

public class CountInputElements {
	
	public static void main(String[] args)
	{
		CountInputElements prc = new CountInputElements();
		try {
			prc.run();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void run() throws SAXException, IOException {
		
		InputElementHandler handler = new InputElementHandler();
		XMLReader reader = XMLReaderFactory.createXMLReader();
		
		reader.setContentHandler(handler);
		
		// TODO insert large xhtml document
/* This does not work
		URL u = new URL("http://aii.lgrace.com/documents/html/XHTML_Sample_Doc_1.xhtm");
        InputStream in = u.openStream();
		InputSource is = new InputSource(in);
		reader.parse(is);
*/
		PrintStream sw = new PrintStream("large_input.xhtml");
		
//		sw.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"); 
//		sw.println("<html xmlns=\"http://www.w3.org/1999/xhtml\">"); 
		sw.println("<html>"); 
		sw.println("<head>");
		sw.println("<title>Sample XHTML Document</title>"); 
		sw.println("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />"); 
		sw.println("</head>"); 

		sw.println("<body>"); 
		sw.println("<form>"); 

		// This takes about 1 min to execute
		for (int i = 0; i < 2000; ++i)
		{
			sw.println("<p>This is an <strong>XHTML </strong>formatted <em>document</em>.</p>"); 
			sw.println("<p>You can use ordered lists, &lt;OL/&gt;, by adding list items, &lt;LI/&gt;:</p>"); 
			sw.println("<ol>"); 
			sw.println("<li>To highlight enumerated items</li>"); 
			sw.println("<li>To autonumber a list</li>"); 
			sw.println("<li>To demonstrate your coding skills</li>"); 
			sw.println("</ol>"); 
			sw.println("<p>You can also use unordered lists, &lt;UL&gt;, by adding list items, &lt;LI/&gt;:</p>"); 
			sw.println("<ul>"); 
			sw.println("<li>To emphasize content</li>"); 
			sw.println("<li>To facilitate faster reading</li>"); 
			sw.println("<li>To format outlines"); 
			sw.println("<ul>"); 
			sw.println("<li>All lists have sub elements</li>"); 
			sw.println("</ul>"); 
			sw.println("</li>"); 
			sw.println("</ul>"); 
			sw.println("<p>Go to <a href=\"http://validator.w3.org/\" target=\"_blank\">http://validator.w3.org/</a>"); 
			sw.println("to validate this XHTML</p>"); 
			
			sw.println("<input type=\"checkbox\" name=\"ckbx" + i + "1\" value=\"true\" />");
		}
		
		sw.println("</form>"); 
		sw.println("</body>"); 
		sw.println("</html>"); 
		sw.close();
		
		reader.parse("large_input.xhtml");
		handler.printInputCount();
	}
}
