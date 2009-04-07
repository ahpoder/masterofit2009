package gis.group3.lightsensor.analysis;

import lejos.nxt.*;

public class LightSensorMeasurements {
	public LightSensorMeasurements(LightSensor sensor)
	{
		mSensor = sensor;
		mSensor.setFloodlight(false);
	}

	public void runLinearityTest()
	{
		calibrateAndTest60W15cm();
		testRawNorm("30cm", "60W");
		testRawNorm("45cm", "60W");
		testRawNorm("60cm", "60W");
		testRawNorm("15cm", "15W");
		testRawNorm("15cm", "45W");
		testRawNorm("30cm", "15W");
		testRawNorm("30cm", "45W");
		testRawNorm("45cm", "15W");
		testRawNorm("45cm", "45W");
		testRawNorm("60cm", "15W");
		testRawNorm("60cm", "45W");
	}

	private void calibrateAndTest60W15cm()
	{
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("* 15cm tube", 2, 2);
	    LCD.drawString("+ 60W light", 4, 3);
		LCD.drawString("Press any key", 0, 5);
		LCD.drawString("when ready", 0, 6);
		Button.waitForPress();
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("Calibra. low", 2, 2);
		mSensor.calibrateLow();
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
		}
		int dark = mSensor.readNormalizedValue();
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("* turn on 60W", 2, 2);
		LCD.drawString("Press any key", 0, 4);
		LCD.drawString("when ready", 0, 5);
		Button.waitForPress();
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("Calibra. high", 2, 2);
		mSensor.calibrateHigh();
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
		}
		int light = mSensor.readNormalizedValue();
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("N dark: ", 2, 2);
		LCD.drawInt(dark, 12, 2);
		LCD.drawString("N light: ", 2, 3);
		LCD.drawInt(light, 12, 3);
		LCD.drawString("Press any key", 0, 5);
		Button.waitForPress();
	}
	
	private void testRawNorm(String length, String lightbulb)
	{
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("* " + length + " tube", 2, 2);
	    LCD.drawString("+ " + lightbulb + " light", 4, 3);
		LCD.drawString("* turn on " + lightbulb, 2, 4);
		LCD.drawString("Press any key", 0, 6);
		LCD.drawString("when ready", 0, 7);
		int light = mSensor.readNormalizedValue();
		int raw = mSensor.readValue();
		LCD.clear();
		LCD.drawString("Linearity test: ", 0, 0);
		LCD.drawString("Norm: ", 2, 2);
		LCD.drawInt(light, 8, 2);
		LCD.drawString("Raw: ", 2, 3);
		LCD.drawInt(raw, 8, 3);
		LCD.drawString("Press any key", 0, 5);
		Button.waitForPress();
	}


	public void runReactionTimeTest()
	{
		LCD.clear();
		LCD.drawString("Reaction test", 0, 0);
		LCD.drawString("* Enable farst", 2, 2);
	    LCD.drawString("changing", 4, 3);
	    LCD.drawString("light", 4, 4);
		LCD.drawString("Press any key", 0, 6);
		LCD.drawString("when ready", 0, 7);
		Button.waitForPress();
		
		int[] samples = new int[10000]; 
		for (int i = 0; i < 10000; ++i)
		{
			samples[i] = mSensor.readNormalizedValue();
		}
		int[] identical = new int[5];
		for (int i2 = 5; i2 < 10000; ++i2)
		{
			for (int i3 = 1; i3 <= 5; ++i3)
			{
				if (samples[i2] != samples[i2 - i3])
				{
					break;
				}
				++identical[i3 - 1];
			}
		}
		LCD.clear();
		LCD.drawString("Reaction test", 0, 0);
		LCD.drawString("Measured 10000", 2, 2);
		LCD.drawString("Clusters:", 2, 3);
		LCD.drawString("5 sample: ", 2, 3);
		LCD.drawInt(identical[4], 12, 3);		
		LCD.drawString("4 sample: ", 2, 4);
		LCD.drawInt(identical[3], 12, 4);		
		LCD.drawString("3 sample: ", 2, 5);
		LCD.drawInt(identical[2], 12, 5);		
		LCD.drawString("2 sample: ", 2, 6);
		LCD.drawInt(identical[1], 12, 6);		
		LCD.drawString("1 sample: ", 2, 7);
		LCD.drawInt(identical[0], 12, 7);
		Button.waitForPress();
	}

	public void testSensitivity(String lightbulb, String object)
	{
		LCD.clear();
		LCD.drawString("Sensitivity test", 0, 0);
		LCD.drawString("* " + lightbulb + " light", 2, 2);
		LCD.drawString("+ " + object + " object", 4, 3);
		LCD.drawString("Press any key", 0, 5);
		LCD.drawString("when ready", 0, 6);
		Button.waitForPress();
		
		int value1 = mSensor.readNormalizedValue();
		
		LCD.clear();
		LCD.drawString("Sensitivity test", 0, 0);
		LCD.drawString("* change ", 2, 2);
		LCD.drawString("external", 4, 3);
		LCD.drawString("light", 4, 4);
		LCD.drawString("Press any key", 0, 6);
		LCD.drawString("when ready", 0, 7);
		Button.waitForPress();

		int value2 = mSensor.readNormalizedValue();
		
		LCD.clear();
		LCD.drawString("Sensitivity test", 0, 0);
		LCD.drawString("Sample 1: ", 2, 2);
		LCD.drawInt(value1, 12, 2);
		LCD.drawString("Sample 2: ", 2, 3);
		LCD.drawInt(value2, 12, 3);
		LCD.drawString("Press any key", 0, 5);
		Button.waitForPress();
	}
	
	public void runSensitivityTest()
	{
		testSensitivity("60W", "no");
		testSensitivity("45W", "no");
		testSensitivity("15W", "no");
		testSensitivity("60W", "dark");
		testSensitivity("45W", "dark");
		testSensitivity("15W", "dark");
		testSensitivity("60W", "light");
		testSensitivity("45W", "light");
		testSensitivity("15W", "light");
	}
	private LightSensor mSensor;
}
