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
	TreeMap<String, GeologDeviceStatus> tmDevices; // For the storage of current information
	TreeMap<String, Document> tmDevicesReadings; // For the storage of all readings

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
		tmDevices = (TreeMap)context.getAttribute("tmDevices");
		//Create the data object if it wasn't there already
		if (tmDevices==null){
			tmDevices = new TreeMap<String, GeologDeviceStatus>();
			context.setAttribute("tmDevices", tmDevices);
		}

		//Get the data object for device readings from the servlet context
		tmDevicesReadings = (TreeMap)context.getAttribute("tmDevicesReadings");
		//Create the data object if it wasn't there already
		if (tmDevicesReadings==null){
			tmDevicesReadings = new TreeMap<String, Document>();
			context.setAttribute("tmDevicesReadings", tmDevicesReadings);
		}
	}

	//****All the getters exposed by the service****

	/**
		Write the current information about all the devices registered with the system
	**/
	public void writeDevices(String serverPath, java.io.PrintWriter writer)
			throws IOException, ServletException, XSLTransformException {

		Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
		Namespace kml = Namespace.getNamespace("k", "http://www.opengis.net/kml/2.2");
		Element devicesElement = new Element("devices", root);
		devicesElement.addNamespaceDeclaration(kml);
		Document myDocument = new Document(devicesElement);

		//The TreeMap must not be changed while iterating
		synchronized(context)
		{
			Iterator it = tmDevices.keySet().iterator();

			//iterate through TreeMap keys and build the output
			while(it.hasNext()) {
				String key = (String)it.next();
				Element ds = new Element("deviceSimple", root);
				ds.setAttribute(new Attribute("id", key));
				Element du = new Element("deviceURL", root);
				du.setText(serverPath + "/geolog/devices/" + (String)key);
				ds.addContent(du);
				Element pt = new Element("Point", kml);
				Element co = new Element("coordinates", kml);
				GeologDeviceStatus deviceStatus = (GeologDeviceStatus)tmDevices.get(key);
				ds.setAttribute(new Attribute("status", deviceStatus.status));
				//Ensure that we get a '.' as the decimal separator in the XML output
				co.setText(String.format(Locale.US, "%1$f, %2$f", deviceStatus.longitude, deviceStatus.latitude));
				pt.addContent(co);
				ds.addContent(pt);
				devicesElement.addContent(ds);
			}
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

		if (!tmDevicesReadings.containsKey(id.toString()))
		{
			return false; // ERROR
		}

		Document hashDoc = tmDevicesReadings.get(id.toString());

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
		Namespace fn = Namespace.getNamespace("fn", "http://www.w3.org/2005/xpath-functions");
		//The way that works
		//Critical region, as more servlets may try a concurrent context update
		synchronized(context)
		{
			//Check for existence of the device in the hash table with readings
			if (!tmDevicesReadings.containsKey(id.toString()))
			{

				//Create and insert a well formed document without readings
				Element deviceElement = new Element("device", root);
				deviceElement.addNamespaceDeclaration(kml);
				Document myDocument = new Document(deviceElement);

				deviceElement.setAttribute(new Attribute("id", id.toString()));

				Element glCollection = new Element("geologCollection", root);
				deviceElement.addContent(glCollection);
				tmDevicesReadings.put(id.toString(), myDocument);

			}

			//Get the document for the current device from the TreeMap
			Document hashDoc = tmDevicesReadings.get(id.toString());

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
  		//Put the last geolog in e. Enter if geolog exists only
  		if(geologList.size()>0){
    		Element e = (Element)geologList.get(geologList.size() - 1);
  			//Add an entry to the hash table with the current device status and coordinates
				//It is assumed, that the last geolog is the latest.
				//Extract the current status and coordinates
				String status = e.getChild("status", root).getValue();
				Element ept = e.getChild("Point", kml);
				Element ecoordinates = ept.getChild("coordinates", kml);
				if(ecoordinates!=null){
  			  String coordinates = ecoordinates.getValue();
					//TODO: Consider whether it is necessary to validate before split
					//as we might have a decimal separator problem depending on locale
					//Is the decimal separator defined in the kml specification?
					String[] acoordinates = coordinates.split(",");
					//Insert the new values into the collection
			 		tmDevices.put(id.toString(), new GeologDeviceStatus(status, Double.valueOf(acoordinates[0]), Double.valueOf(acoordinates[1])));
				}

  		}
			//This XPath will find the status of the last reading
			//XPath xpStatus = XPath.newInstance("//geolog[fn:last()]/status");
			//This doesn't work as fn:last() is not recognized by the xpath evaluator
			//XPath xpCoordinates = XPath.newInstance("//geolog[fn:last()]//k:coordinates");
			//This works, but is not complete
			//XPath xpCoordinates = XPath.newInstance("//k:coordinates");
			//xpCoordinates.addNamespace(root);
			//xpCoordinates.addNamespace(kml);
			//xpCoordinates.addNamespace(fn);
			//String coordinates = xpCoordinates.valueOf(doc);
			//TODO: Consider whether it is necessary to validate before split
			//as we might have a decimal separator problem depending on locale
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
			if (!tmDevicesReadings.containsKey(id.toString()))
			{
				//Insert the new device in the TreeMap
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
				tmDevicesReadings.put(id.toString(), myDocument);
			}//if (!tmDevicesReadings.containsKey(id.toString()))
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
				Document dcur = tmDevicesReadings.get(id.toString());
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
