import java.io.*;
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
import org.jdom.transform.*;
import javax.servlet.*;

public class GeologDataAccess  {
	static Namespace jml =
		Namespace.getNamespace("http://localhost:8080/geolog");

	ServletContext context;
	String geologDataFile;
	Document geologData;

	/**
		Initialize and create an "geologData" attribute
		on the servlet context. The geologData object is
		the central place holder for data while the service
		is alive.
		TODO: Implement geologData persistense
	**/
	public GeologDataAccess(ServletContext context)
			throws JDOMException, IOException {

		this.context = context;
		geologData = (Document)context.getAttribute("geologData");
		geologDataFile = context.getInitParameter("GeologDataFile");
		if (geologData==null){
			try {
				geologData = new SAXBuilder().build(new File(geologDataFile));
			}
			catch (Exception e) {
				geologData = new Document(new Element("collection", jml));
			}
			context.setAttribute("geologData", geologData);
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

		//Run the relevant XSLT transform on the global data object
		String xslt =	context.getInitParameter("DeviceListXSLT");
		XSLTransformer t = new XSLTransformer(xslt);
		new XMLOutputter().output(t.transform(geologData), writer);
	}

	/**
		Return information about a specific device registered with the system
		The id must be validated conforming to the required structure
	**/
	public void writeDevice(GeologDeviceID id, java.io.PrintWriter writer)
			throws IOException, ServletException, XSLTransformException {

		//Run the relevant XSLT transform on the global data object
		String xslt =	context.getInitParameter("DeviceXSLT");
		//TODO: Use the supplied id (XPath?)
		XSLTransformer t = new XSLTransformer(xslt);
		new XMLOutputter().output(t.transform(geologData), writer);
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
		Insert information about a device into the document
	**/
	public void addDevice(Document more)
			throws JDOMException, IOException {
		//Critical region, as more servlets may try a concurrent context update
		synchronized(context) {
			//Add the received data to the context object
			geologData.getRootElement().addContent(more.getRootElement().removeContent());
		}
	}


}
