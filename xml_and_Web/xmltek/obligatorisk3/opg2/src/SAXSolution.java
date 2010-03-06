import java.io.IOException;

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
		public void startElement(String uri, String localName, String qName, Attributes atts) {
			
		}

	}
	
	private void run() throws SAXException, IOException {
		AncestryHandler handler = new AncestryHandler();
		XMLReader reader = XMLReaderFactory.createXMLReader();
		
		reader.setContentHandler(handler);
		reader.parse("recipes.xml");
	}
}
