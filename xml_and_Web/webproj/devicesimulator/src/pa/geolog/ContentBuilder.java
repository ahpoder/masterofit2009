package pa.geolog;

import java.io.*;
import java.text.*;
import java.util.*;

import org.jdom.*;
import org.jdom.output.*;

public class ContentBuilder {

	public static String getNextContent(int id) throws IOException {
		Random r = new Random();
		double lat = rootLattitude + (r.nextDouble() - 0.5) * locationDeviation;
		double lng = rootLongitude + (r.nextDouble() - 0.5) * locationDeviation;
		return buildContent("" + id, DeviceStatus.OK, lat, lng);
	}

	 private static String getDateTime() {
		 SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-d'T'HH:mm:ss.S");
	     Date date = new Date();
	     return dateFormat.format(date);
	 }
	 
	public static String buildContent(String id, DeviceStatus status, double lattitude, double longitude) throws IOException
	{
		Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
		Element deviceElement = new Element("device", root);
		Namespace kml = Namespace.getNamespace("k", "http://code.google.com/kml21");
		deviceElement.addNamespaceDeclaration(kml);
		Document myDocument = new Document(deviceElement);
		
		deviceElement.setAttribute(new Attribute("id", id));
		
		Element glCollection = new Element("geologCollection", root); 
		deviceElement.addContent(glCollection);
		
		Element geolog = new Element("geolog", root);
		glCollection.addContent(geolog);
		
		geolog.setAttribute("dateTime", getDateTime());
		
		Element readings = new Element("readings", root);
		geolog.addContent(readings);
		
		Element reading = new Element("reading", root);
		readings.addContent(reading);
		
		reading.setAttribute("id", "sensor1");

		Element key = new Element("key", root);
		key.addContent("altitude");
		reading.addContent(key);
		
		Element value = new Element("value", root);
		Random r = new Random();
		value.addContent("" + (r.nextDouble() * 250));
		reading.addContent(value);
		
		Element type = new Element("type", root);
		type.addContent("xs:double");
		reading.addContent(type);
		
		Element unit = new Element("unit", root);
		unit.addContent("m");
		reading.addContent(unit);

		Element eStatus = new Element("status", root);
		eStatus.addContent(status.toString());
		geolog.addContent(eStatus);
		
		Element eLocation = new Element("location", root);
		geolog.addContent(eLocation);
				
		Element coordinates = new Element("coordinates", kml);
		coordinates.addContent("" + lattitude + "," + longitude);
		eLocation.addContent(coordinates);
		
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
