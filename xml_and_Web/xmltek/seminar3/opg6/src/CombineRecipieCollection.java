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

public class CombineRecipieCollection {
	
	
	public static void main(String[] args)
	{
		CombineRecipieCollection prc = new CombineRecipieCollection();
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
		SAXBuilder sx = new SAXBuilder();
		Document d = sx.build(new File("recipes.xml"));
		Namespace rcp = Namespace.getNamespace("http://www.brics.dk/ixwt/recipes");
		
		Document d_mutant = sx.build(new File("recipes_mutant.xml"));
		
		Filter f = new ElementFilter("recipe", rcp);

		Document d_output = new Document();
		
		Element recipes = new Element("collection", "rcp", "http://www.brics.dk/ixwt/recipes");
		d_output.addContent(recipes);
		Element description = new Element("description", "rcp", "http://www.brics.dk/ixwt/recipes");
		recipes.addContent(description);
		description.addContent("This is a combined collection");

		ArrayList<String> printed = new ArrayList<String>();
		Iterator i = d.getDescendants(f);
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			recipes.addContent((Element)e.clone());
			printed.add(e.getAttributeValue("id"));
		}
		
		Iterator i_mutant = d_mutant.getDescendants(f);
		while (i_mutant.hasNext())
		{
			Element e_mutant = (Element)i_mutant.next();
			if (!printed.contains(e_mutant.getAttributeValue("id")))
			{
				recipes.addContent((Element)e_mutant.clone());
			}
		}
		XMLOutputter xo = new XMLOutputter();
		xo.output(d_output, new FileOutputStream("combinedRecipes.xml"));
	}
}
