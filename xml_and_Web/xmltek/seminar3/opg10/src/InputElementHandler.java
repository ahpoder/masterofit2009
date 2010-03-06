import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;


public class InputElementHandler extends DefaultHandler {

	public void printInputCount()
	{
		System.out.println("Number of input elements: " + count);
	}
	
	int count = 0;
	
	public void startElement(String uri, String localName, String qName, Attributes atts)
	{
		if (localName.equals("input"))
		{
			++count;
		}
	}
}
