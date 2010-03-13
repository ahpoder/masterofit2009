import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;


public class MaxMinVolumeHandler extends DefaultHandler {

	public void printMaxMin()
	{
		System.out.println("Max volume: " + maxVolume + " ml of " + maxVolumeName);
		System.out.println("Min volume: " + minVolume + " ml of " + minVolumeName);
	}
	
	double maxVolume = 0;
	double minVolume = Integer.MAX_VALUE;
	String minVolumeName;
	String maxVolumeName;
	
	private double unitConverter(String amountStr, String unitStr)
	{
		if (amountStr != null && unitStr != null)
		{
			double amount = Double.parseDouble(amountStr);
			if (unitStr.equals("cup"))
			{
				return amount * 240;
			}
			else if (unitStr.equals("tablespoon"))
			{
				return amount * 15;
			}
			else if (unitStr.equals("teaspoon"))
			{
				return amount * 5;
			}
		}
		return -1;
	}
	
	public void startElement(String uri, String localName, String qName, Attributes atts)
	{
		if (localName.equals("ingredient"))
		{
			String name = atts.getValue("name");
			String unit = atts.getValue("unit");
			String amount = atts.getValue("amount");
			
			double volume = unitConverter(amount, unit);
			if (volume >= 0)
			{
				if (volume > maxVolume)
				{
					maxVolume = volume;
					maxVolumeName = name;
				}
				if (volume < minVolume)
				{
					minVolume = volume;
					minVolumeName = name;
				}
			}
		}
	}
}
