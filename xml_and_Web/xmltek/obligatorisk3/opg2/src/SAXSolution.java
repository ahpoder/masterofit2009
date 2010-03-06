import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Namespace;
import org.jdom.filter.ElementFilter;
import org.jdom.filter.Filter;
import org.jdom.input.SAXBuilder;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class SAXSolution {
	
	public static void main(String[] args)
	{
		SAXSolution prc = new SAXSolution();
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

	private class AncestryHandler extends DefaultHandler {
		boolean insideFooElement = false;
		long _maxMemoryUsed = 0;
		public void startElement(String uri, String localName, String qName, Attributes atts) {
			// TODO we only want to print the text that is directly inside foo, not the text that is 
			// inside an element inside foo
			insideFooElement = uri.equals("http://cs.au.dk/A") && localName.equals("foo");
		}
		
		public void endElement(String uri, String localName, String qName)
		{
			insideFooElement = false;
		}
		public void characters(char[] ch, int start, int length)
		{
			long temp = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			if (temp > _maxMemoryUsed)
			{
				_maxMemoryUsed = temp;
			}
			if (insideFooElement)
			{
				System.out.print(new String(ch, start, length));
			}
		}

		public long maxMemoryUsed() {
			return _maxMemoryUsed;
		}
	}
	
	private void run() throws SAXException, IOException {
		long start = System.currentTimeMillis();
		long startMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

		AncestryHandler handler = new AncestryHandler();
		XMLReader reader = XMLReaderFactory.createXMLReader();
		
		reader.setContentHandler(handler);
		reader.parse("handin3.xml");
		
		long end = System.currentTimeMillis();
		
		long endMemory = handler.maxMemoryUsed();
		
		System.out.println();
		System.out.println();
		System.out.println("Total time elapsed[ms]: " + (end - start));
		System.out.println("Total memory used[byte]: " + (endMemory - startMemory));
	}
}
