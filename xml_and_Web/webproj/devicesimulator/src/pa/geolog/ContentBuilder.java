package pa.geolog;

import java.io.*;
import java.text.*;
import java.util.*;

import org.jdom.*;
import org.jdom.output.*;

public class ContentBuilder {

	public static String getNextContent(int id) {
		Random r = new Random();
		double lat = rootLattitude + (r.nextDouble() - 0.5) * locationDeviation;
		double lng = rootLongitude + (r.nextDouble() - 0.5) * locationDeviation;
		return buildContent("" + id, DeviceStatus.OK, lat, lng);
	}

	 private static String getDateTime() {
		 DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-ddTHH:mm:ss");
	     Date date = new Date();
	     return dateFormat.format(date);
	 }
	 
	public static String buildContent(String id, DeviceStatus status, double lattitude, double longitude) throws IOException
	{
		Element deviceElement = new Element("device");
		Document myDocument = new Document(deviceElement);
		
		deviceElement.setAttribute(new Attribute("id", id));
		
		Element glCollection = new Element("geologCollection"); 
		deviceElement.addContent(glCollection);
		
		Element geolog = new Element("geolog");
		glCollection.addContent(geolog);
		
		geolog.setAttribute("dateTime", getDateTime());
		
		Element readings = new Element("readings");
		geolog.addContent(readings);
		
		Element reading = new Element("reading");
		readings.addContent(reading);
		
		reading.setAttribute("id", "sensor1");

		Element key = new Element("key");
		key.addContent("altitude");
		reading.addContent(key);
		
		Element value = new Element("VALUE");
		value.addContent("125.0001");
		reading.addContent(value);
		
		Element type = new Element("type");
		type.addContent("xs:double");
		reading.addContent(type);
		
		Element unit = new Element("unit");
		unit.addContent("m");
		reading.addContent(unit);

		// Add remaining
		
		StringWriter sw = new StringWriter();
		XMLOutputter outputter = new XMLOutputter();
		outputter.output(myDocument, sw);
		return sw.toString();
	}

	private static double rootLattitude = 0; 
	private static double rootLongitude = 0; 
	private static double locationDeviation = 0; 
	public static void registerRootLocation(double lattitude, double longitude, double deviation) {
		rootLattitude = lattitude;
		rootLongitude = longitude;
		locationDeviation = deviation;
	}
}
