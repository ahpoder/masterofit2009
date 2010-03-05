import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;

import org.jdom.*;
import org.jdom.filter.*;
import org.jdom.input.*;
import org.jdom.output.XMLOutputter;
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
