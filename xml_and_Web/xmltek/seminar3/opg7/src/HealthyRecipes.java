import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import org.jdom.*;
import org.jdom.filter.*;
import org.jdom.input.*;
import org.jdom.output.XMLOutputter;

public class HealthyRecipes {
	
	public static void main(String[] args)
	{
		HealthyRecipes prc = new HealthyRecipes();
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

		Filter fIngredient = new ElementFilter("ingredient", rcp);
		Filter fStep = new ElementFilter("step", rcp);
		
		Iterator i = d.getDescendants(fIngredient);
		ArrayList<Attribute> ingredientsWithSugar = new ArrayList<Attribute>(); 
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			Attribute a = e.getAttribute("name");
			if (a.getValue().contains("sugar"))
			{
				ingredientsWithSugar.add(a);
			}
		}
		
		Iterator<Attribute> ai = ingredientsWithSugar.iterator();
		while (ai.hasNext())
		{
			Attribute a = ai.next();
			a.setValue(a.getValue().replace("sugar", "nutrasweet"));
		}
		ingredientsWithSugar.clear();
				
		ArrayList<Element> stepsWithSugar = new ArrayList<Element>(); 
		i = d.getDescendants(fStep);
		while (i.hasNext())
		{
			Element e = (Element)i.next();
			if (e.getText().contains("sugar"))
			{
				stepsWithSugar.add(e);
			}
		}
		
		Iterator<Element> ei = stepsWithSugar.iterator();
		while (ei.hasNext())
		{
			Element e = ei.next();
			e.setText(e.getText().replace("sugar", "nutrasweet"));
		}
		stepsWithSugar.clear();

		
		XMLOutputter xo = new XMLOutputter();
		xo.output(d, new FileOutputStream("healthy_recipes.xml"));
	}
}
