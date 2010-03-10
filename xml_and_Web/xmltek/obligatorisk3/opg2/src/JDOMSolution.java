import java.io.File;
import java.io.IOException;
import java.util.Iterator;

import org.jdom.*;
import org.jdom.filter.*;
import org.jdom.input.*;

public class JDOMSolution {
	
	public static void main(String[] args)
	{
		JDOMSolution prc = new JDOMSolution();
		try {
			prc.run();
		} catch (JDOMException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void run() throws JDOMException, IOException {
		long start = System.currentTimeMillis();
		long startMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
		SAXBuilder sx = new SAXBuilder();
		Document d = sx.build(new File("handin3.xml"));
		long parse = System.currentTimeMillis();
		Namespace rcp = Namespace.getNamespace("http://cs.au.dk/A");
		
		Filter f = new ElementFilter("foo", rcp);
		
		Iterator i = d.getDescendants(f);
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			System.out.print(e.getText());
		}
		long end = System.currentTimeMillis();
		long endMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();

		System.out.println();
		System.out.println();
		System.out.println("Total time elapsed[ms]: " + (end - start));
		System.out.println("Total spent parsing[ms]: " + (parse - start));
		System.out.println("Total memory used[byte]: " + (endMemory - startMemory));
	}
}
