import java.io.IOException;

import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

public class MaxMinVolume {
	
	public static void main(String[] args)
	{
		MaxMinVolume prc = new MaxMinVolume();
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
		MaxMinVolumeHandler handler = new MaxMinVolumeHandler();
		XMLReader reader = XMLReaderFactory.createXMLReader();
		
		reader.setContentHandler(handler);
		reader.parse("recipes.xml");
		handler.printMaxMin();
	}
}
