import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import org.jdom.*;
import org.jdom.filter.*;
import org.jdom.input.*;
import org.jdom.output.XMLOutputter;

public class NutritionOutputter {
	
	public static void main(String[] args)
	{
		NutritionOutputter prc = new NutritionOutputter();
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

		Filter f = new ElementFilter("recipe", rcp);

		Document d_output = new Document();
		
		Element nutrition_output = new Element("nutrition", "rcp", "http://www.brics.dk/ixwt/recipes");
		d_output.addContent(nutrition_output);

		ArrayList<String> printed = new ArrayList<String>();
		Iterator i = d.getDescendants(f);
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			Element title = e.getChild("title", rcp);
			Element nutrition = e.getChild("nutrition", rcp);
			Attribute calories = nutrition.getAttribute("calories");
			Attribute fat = nutrition.getAttribute("fat");
			Attribute carbohydrates = nutrition.getAttribute("carbohydrates");
			Attribute protein = nutrition.getAttribute("protein");
			Attribute alcohol = nutrition.getAttribute("alcohol");
			
			Element dish = new Element("dish", "rcp", rcp.getURI());
			dish.setAttribute("name", title.getText());
			dish.setAttribute("calories", calories.getValue());
			dish.setAttribute("fat", fat.getValue());
			dish.setAttribute("carbohydrates", carbohydrates.getValue());
			dish.setAttribute("protein", protein.getValue());
			dish.setAttribute("alcohol", (alcohol == null ? "0%" : alcohol.getValue()));
			
			nutrition_output.addContent(dish);
		}
		XMLOutputter xo = new XMLOutputter();
		xo.output(d_output, new FileOutputStream("nutrition.xml"));
	}
}
