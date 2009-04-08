package gis.group3.lightsensor.analysis;

import lejos.nxt.*;

public class LightSensorMeasurements {
	public LightSensorMeasurements(LightSensor sensor)
	{
		mSensor = sensor;
		mSensor.setFloodlight(false);
	}

	public static void main(String[] args) {
		LightSensor ls = new LightSensor(SensorPort.S1);
		LightSensorMeasurements lsm = new LightSensorMeasurements(ls);
		lsm.runTestMenu();
	}

	public void runTestMenu()
	{
		boolean terminate = false;
		int selection = 2;
		while (!terminate)
		{
			LCD.clear();
			LCD.drawString("Test menu: ", 0, 0);
			LCD.drawString("Linearity", 1, 2);
			LCD.drawString("Sensitivity", 1, 3);
			LCD.drawString("Reaction time", 1, 4);
			LCD.drawString("Terminate app", 1, 5);
			LCD.drawString(">", 0, selection);
			Button.waitForPress();
			if(Button.LEFT.isPressed())
			{
				--selection;
				if (selection < 2)
				{
					selection = 5;
				}
			}
			else if (Button.RIGHT.isPressed())
			{
				++selection;
				if (selection > 5)
				{
					selection = 2;
				}
			}
			else if (Button.ENTER.isPressed())
			{
				switch (selection)
				{
				case 2:
					runSampleTest("Linearity");
					break;
				case 3:
					runSampleTest("Sensitivity");
					break;
				case 4:
					runReactionTimeTest();
					break;
				case 5:
					terminate = true;
					break;
				}
			}
		}		
	}
	
	private void runSampleTest(String testType)
	{
		boolean terminate = false;
		int selection = 2;
		while (!terminate)
		{
			LCD.clear();
			LCD.drawString(testType + " test: ", 0, 0);
			LCD.drawString("Calibrate", 1, 2);
			LCD.drawString("Sample", 1, 3);
			LCD.drawString("Done", 1, 4);
			LCD.drawString(">", 0, selection);
			Button.waitForPress();
			if(Button.LEFT.isPressed())
			{
				--selection;
				if (selection < 2)
				{
					selection = 4;
				}
			}
			else if (Button.RIGHT.isPressed())
			{
				++selection;
				if (selection > 4)
				{
					selection = 2;
				}
			}
			else if (Button.ENTER.isPressed())
			{
				switch (selection)
				{
				case 2:
					calibrate();
					break;
				case 3:
					testRawNorm();
					break;
				case 4:
					terminate = true;
					break;
				}
			}
		}		
	}

	private void calibrate()
	{
		LCD.clear();
		LCD.drawString("Calibration: ", 0, 0);
		LCD.drawString("* Min light", 2, 2);
		LCD.drawString("Press any key", 0, 4);
		LCD.drawString("when ready", 0, 5);
		Button.waitForPress();
		LCD.clear();
		LCD.drawString("Calibration: ", 0, 0);
		LCD.drawString("Calibra. low", 2, 2);
		mSensor.calibrateLow();
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
		}
		int Ndark = mSensor.readNormalizedValue();
		int dark = mSensor.getLow();
		LCD.clear();
		LCD.drawString("Calibration: ", 0, 0);
		LCD.drawString("* Max light", 2, 2);
		LCD.drawString("Press any key", 0, 4);
		LCD.drawString("when ready", 0, 5);
		Button.waitForPress();
		LCD.clear();
		LCD.drawString("Calibration: ", 0, 0);
		LCD.drawString("Calibra. high", 2, 2);
		mSensor.calibrateHigh();
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
		}
		int Nlight = mSensor.readNormalizedValue();
		int light = mSensor.getHigh();
		LCD.clear();
		LCD.drawString("Calibration: ", 0, 0);
		LCD.drawString("Raw low: ", 2, 2);
		LCD.drawInt(dark, 12, 2);
		LCD.drawString("N low: ", 2, 3);
		LCD.drawInt(Ndark, 12, 3);
		LCD.drawString("Raw high: ", 2, 4);
		LCD.drawInt(light, 12, 4);
		LCD.drawString("N high: ", 2, 5);
		LCD.drawInt(Nlight, 12, 5);
		LCD.drawString("Press any key", 0, 7);
		Button.waitForPress();
	}
	
	private void testRawNorm()
	{
		LCD.clear();
		LCD.drawString("Sampling: ", 0, 0);
		LCD.drawString("* prepare", 2, 2);
	    LCD.drawString("setup", 4, 3);
		LCD.drawString("Press any key", 0, 5);
		LCD.drawString("when ready", 0, 6);
		int light = mSensor.readNormalizedValue();
		int raw = mSensor.readValue();
		LCD.clear();
		LCD.drawString("Sampling: ", 0, 0);
		LCD.drawString("Norm: ", 2, 2);
		LCD.drawInt(light, 8, 2);
		LCD.drawString("Raw: ", 2, 3);
		LCD.drawInt(raw, 8, 3);
		LCD.drawString("Press any key", 0, 5);
		Button.waitForPress();
	}


	private void runReactionTimeTest()
	{
		LCD.clear();
		LCD.drawString("Reaction test:", 0, 0);
		LCD.drawString("* Enable rapid", 2, 2);
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
	private LightSensor mSensor;
}
