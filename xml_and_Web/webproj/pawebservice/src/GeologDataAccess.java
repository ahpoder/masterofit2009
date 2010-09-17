import java.io.*;
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
import org.jdom.xpath.*;
import org.jdom.transform.*;
import javax.servlet.*;
import java.util.*;

public class GeologDataAccess  {

	ServletContext context;
	Hashtable<String, GeologDeviceStatus> hashDevices; // For the storage of current information
	Hashtable<String, Document> hashDevicesReadings; // For the storage of all readings

	/**
	  The class will create relevant data access objects
	  on the servlet context.
		These objects are the transient storage for data
		while the service is alive
		TODO: Implement persistence
	**/
	public GeologDataAccess(ServletContext context)
			throws JDOMException, IOException {

		this.context = context;
		//Get the data object for current information from the servlet context
		hashDevices = (Hashtable)context.getAttribute("hashDevices");
		//Create the data object if it wasn't there already
		if (hashDevices==null){
			hashDevices = new Hashtable<String, GeologDeviceStatus>();
			context.setAttribute("hashDevices", hashDevices);
		}

		//Get the data object for device readings from the servlet context
		hashDevicesReadings = (Hashtable)context.getAttribute("hashDevicesReadings");
		//Create the data object if it wasn't there already
		if (hashDevicesReadings==null){
			hashDevicesReadings = new Hashtable<String, Document>();
			context.setAttribute("hashDevicesReadings", hashDevicesReadings);
		}
	}

	//****All the getters exposed by the service****

	/**
		Write the current information about all the devices registered with the system
	**/
	public void writeDevices(String serverPath, java.io.PrintWriter writer)
			throws IOException, ServletException, XSLTransformException {

		Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
		Element devicesElement = new Element("devices", root);
		Namespace kml = Namespace.getNamespace("k", "http://www.opengis.net/kml/2.2");
		devicesElement.addNamespaceDeclaration(kml);
		Document myDocument = new Document(devicesElement);

		Enumeration e = hashDevices.keys();

		//iterate through Hashtable keys Enumeration
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			Element ds = new Element("deviceSimple", root);
			Element du = new Element("deviceURL", root);
			du.setText(serverPath + "/geolog/devices/" + (String)key);
			ds.addContent(du);
			Element pt = new Element("Point", kml);
			Element co = new Element("coordinates", kml);
			GeologDeviceStatus deviceStatus = (GeologDeviceStatus)hashDevices.get(key);
			co.setText(String.format("%1$f, %2$f", deviceStatus.longitude, deviceStatus.latitude));
			pt.addContent(co);
			ds.addContent(pt);
			devicesElement.addContent(ds);
		}

		XMLOutputter xo = new XMLOutputter(Format.getPrettyFormat());
		xo.output(myDocument, writer);
	}

	/**
		Return information about a specific device registered with the system
		The id must be validated conforming to the required structure
	**/
	public boolean writeDevice(GeologDeviceID id, java.io.PrintWriter writer)
			throws IOException, ServletException, XSLTransformException {

		if (!hashDevicesReadings.containsKey(id.toString()))
		{
			return false; // ERROR
		}

		Document hashDoc = hashDevicesReadings.get(id.toString());

		XMLOutputter xo = new XMLOutputter(Format.getPrettyFormat());
		xo.output(hashDoc, writer);

		//Run the relevant XSLT transform on the global data object
//		String xslt =	context.getInitParameter("DeviceXSLT");
		//TODO: Use the supplied id (XPath?)
//		XSLTransformer t = new XSLTransformer(xslt);
//		new XMLOutputter().output(t.transform(geologData), writer);

		return true;
	}

	/**
		Return information about all the zones registered with the system
	**/
	public Document getZones() {
		//Run the relevant XSLT transform on the global data object
		return null;
	}

	/**
		Return information about a specific zone registered with the system
	**/
	public Document getZone(Long id) {
		//Run the relevant XSLT transform on the global data object
		return null;
	}
	//****All the setters exposed by the service****

	/**
		Insert information about a device into the storage
	**/
	public void storeDevice(GeologDeviceID id, Document doc)
			throws JDOMException, IOException, ServletException {
		// Relevant namespaces
		Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
		Namespace kml = Namespace.getNamespace("k", "http://www.opengis.net/kml/2.2");
		//The way that works
		//Critical region, as more servlets may try a concurrent context update
		synchronized(context)
		{
			//Check for existence of the device in the hash table with readings
			if (!hashDevicesReadings.containsKey(id.toString()))
			{

				//Create and insert a well formed document without readings
				Element deviceElement = new Element("device", root);
				deviceElement.addNamespaceDeclaration(kml);
				Document myDocument = new Document(deviceElement);

				deviceElement.setAttribute(new Attribute("id", id.toString()));

				Element glCollection = new Element("geologCollection", root);
				deviceElement.addContent(glCollection);
				hashDevicesReadings.put(id.toString(), myDocument);

			}

			//Get the document for the current device from the hashTable
			Document hashDoc = hashDevicesReadings.get(id.toString());

			Element hashDevice = hashDoc.getRootElement();
			Element hashColl = hashDevice.getChild("geologCollection", root);
			//Drill down to the readings (geolog elements) of the new document
			Element newDevice = doc.getRootElement();
			Element newColl = newDevice.getChild("geologCollection", root);
			List geologList = newColl.getChildren();
			Iterator itt = geologList.iterator();
			while (itt.hasNext())
			{
				Element e = (Element)itt.next();
				hashColl.addContent((Element)e.clone());
			}

			//Add an entry to the hash table with the current device status
			//this will replace old values for the same key
			//TODO: Write XPath to get the last (latest) coordinate
			XPath xpCoordinates = XPath.newInstance("//k:coordinates");
			xpCoordinates.addNamespace(kml);
			String coordinates = xpCoordinates.valueOf(doc);
			//TODO: Consider whether it is necessary to validate before split
			String[] acoordinates = coordinates.split(",");
			hashDevices.put(id.toString(), new GeologDeviceStatus("OK", Double.valueOf(acoordinates[0]), Double.valueOf(acoordinates[1])));
		} //synchronized
		/*

		//The XPath way with a lot of debug packed around it
		XPath geologXPath = null;
		XPath geologCollectionXPath = null;
		try {
				geologXPath = XPath.newInstance("//geolog");
				geologCollectionXPath = XPath.newInstance("//geologCollection");
		} catch (JDOMException e) {
				throw new ServletException("Unable to create XPaths", e);
		}
		synchronized(context)	{
			//Check for existence of the device in the hash table
			if (!hashDevicesReadings.containsKey(id.toString()))
			{
				//Insert the new device in the hashtable
				//TODO: Add some validation of the document
				Debuglog.write("The device doesn't exist. Adding");
				//Create and insert a well formed document without readings
				Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
				Element deviceElement = new Element("device", root);
				Namespace kml = Namespace.getNamespace("k", "http://code.google.com/kml21");
				deviceElement.addNamespaceDeclaration(kml);
				Document myDocument = new Document(deviceElement);

				deviceElement.setAttribute(new Attribute("id", id.toString()));

				Element glCollection = new Element("geologCollection", root);
				deviceElement.addContent(glCollection);
				hashDevicesReadings.put(id.toString(), myDocument);
			}//if (!hashDevicesReadings.containsKey(id.toString()))
			Debuglog.write("The device already exists. Appending readings");
			//Add the new data to the current document
			//Extract the geolog elements from the received document
			//TODO: This one return nothing. WHY? Elements are returned in the test setup
			List newgeologElements = geologCollectionXPath.selectNodes(doc);

			//Proceed if anything's returned
			//TODO: Change test to newgeologElements.size()>0
			if(newgeologElements!=null){
				//DEBUG entry below
				Debuglog.write("XPath on the new document returned " + Integer.toString(newgeologElements.size()) + " geolog elements");
				//Get the current document
				Document dcur = hashDevicesReadings.get(id.toString());
				Debuglog.write("Current document is: " + dcur.toString());

				//Get the element that shall receive the new data
				Element ecur = (Element)geologCollectionXPath.selectSingleNode(dcur);
				if(ecur==null)
					Debuglog.write("XPath for the geologCollection of the current document returned null");
				else
					Debuglog.write("The geologCollection of the current document is: " + ecur.toString());
				//Add the new data to the current data
				Iterator ite = newgeologElements.iterator();
				while(ite.hasNext())
				{
					Element e = (Element)ite.next();
					ecur.addContent((Element)e.clone());
				}//while
		  }//if(newgeologElements!=null){
		}//synchronized(context)	{
		*/
		/* This does not work - why
					XPath xp = XPath.newInstance("//geologCollection");
					xp.addNamespace(root);
					Element hashColl = (Element)xp.selectSingleNode(hashDoc.getRootElement());
					Element newColl = (Element)xp.selectSingleNode(doc.getRootElement());
		*/
	}
}
