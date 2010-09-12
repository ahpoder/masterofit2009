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
	Hashtable<String, GeologDeviceStatus> hashDevices;
	Hashtable<String, Document> hashDevicesReadings;

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
		//Get the data object from the servlet context
		hashDevices = (Hashtable)context.getAttribute("hashDevices");
		//Create the data object if it wasn't there already
		if (hashDevices==null){
			hashDevices = new Hashtable<String, GeologDeviceStatus>();
			context.setAttribute("hashDevices", hashDevices);
		}

		//Get the data object from the servlet context
		hashDevicesReadings = (Hashtable)context.getAttribute("hashDevicesReadings");
		//Create the data object if it wasn't there already
		if (hashDevicesReadings==null){
			hashDevicesReadings = new Hashtable<String, Document>();
			context.setAttribute("hashDevicesReadings", hashDevicesReadings);
		}
	}

	//****All the getters exposed by the service****

	/**
		Write the information about all the devices registered with the system
		formatted for the final output. In the final implementation we might
		chose to have the
	**/
	public void writeDevices(java.io.PrintWriter writer)
			throws IOException, ServletException, XSLTransformException {

		//Create a well formed XML document with the relevant information
		//even if the collection is empty

		//Run the relevant XSLT transform on the global data object
		//String xslt =	context.getInitParameter("DeviceListXSLT");
		//XSLTransformer t = new XSLTransformer(xslt);
		//new XMLOutputter().output(t.transform(geologData), writer);
	}

	/**
		Return information about a specific device registered with the system
		The id must be validated conforming to the required structure
	**/
	public void writeDevice(GeologDeviceID id, java.io.PrintWriter writer)
			throws IOException, ServletException, XSLTransformException {

		//Run the relevant XSLT transform on the global data object
//		String xslt =	context.getInitParameter("DeviceXSLT");
		//TODO: Use the supplied id (XPath?)
//		XSLTransformer t = new XSLTransformer(xslt);
//		new XMLOutputter().output(t.transform(geologData), writer);
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
			throws JDOMException, IOException {
		//Critical region, as more servlets may try a concurrent context update
		synchronized(context) {
			//Check for existence of the device in the hash table
			//if exists add to the present document
			//if not exists insert it

			if (!hashDevicesReadings.containsKey(id.toString()))
			{
				Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
				Element deviceElement = new Element("device", root);
				Namespace kml = Namespace.getNamespace("k", "http://code.google.com/kml21");
				deviceElement.addNamespaceDeclaration(kml);
				Document myDocument = new Document(deviceElement);
				
				deviceElement.setAttribute(new Attribute("id", id.toString()));
				
				Element glCollection = new Element("geologCollection", root); 
				deviceElement.addContent(glCollection);
				hashDevicesReadings.put(id.toString(), myDocument);
			}
			Document hashDoc = hashDevicesReadings.get(id.toString());
			
			Namespace root = Namespace.getNamespace("http://www.pa.com/geolog");
			Element hashDevice = hashDoc.getRootElement();
			Element hashColl = hashDevice.getChild("geologCollection", root);
			
			Element newDevice = doc.getRootElement();
			Element newColl = newDevice.getChild("geologCollection", root);
			
/*
			// Try this
			XPath xp = XPath.newInstace("//geologCollection");
			xp.addNamespace(root);
			Element hashColl = (Element)xp.selectSingleNode(hashDoc.getRootElement());
			Element newColl = (Element)xp.selectSingleNode(doc.getRootElement());
*/			
			List geologList = newColl.getChildren();
			Iterator itt = geologList.iterator();
			while (itt.hasNext())
			{
				hashColl.addContent((Element)((Element)itt.next()).clone());
			}
		}
	}


}
