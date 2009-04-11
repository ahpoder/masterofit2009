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

	private static final int OK_BUTTON = 0x01;
	private static final int LEFT_BUTTON = 0x02;
	private static final int RIGHT_BUTTON = 0x04;
	private static final int ESCAPE_BUTTON = 0x08;
	
	public void runTestMenu()
	{
		boolean terminate = false;
		int selection = 2;
		while (!terminate)
		{
			LCD.clear();
			LCD.drawString("Test menu: ", 0, 0);
			LCD.drawString("Configure", 1, 2);
			LCD.drawString("Reaction time", 1, 3);
			LCD.drawString("Transfer func", 1, 4);
			LCD.drawString("Sensitivity", 1, 5);
			LCD.drawString("Stability", 1, 6);
			LCD.drawString("Terminate app", 1, 7);
			LCD.drawString(">", 0, selection);
			int button = Button.waitForPress();
			if(button == LEFT_BUTTON)
			{
				--selection;
				if (selection < 2)
				{
					selection = 7;
				}
			}
			else if (button == RIGHT_BUTTON)
			{
				++selection;
				if (selection > 7)
				{
					selection = 2;
				}
			}
			else if (button == OK_BUTTON)
			{
				switch (selection)
				{
				case 2:
					calibrate();
					runSampleTest("Configuration");
					break;
				case 3:
					runVariansTest("Reaction");
					break;
				case 4:
					runSampleTest("Transfer");
					break;
				case 5:
					runVariansTest("Sensitivity");
					break;
				case 6:
					runVariansTest("Stability");
					break;
				case 7:
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

	private void runSampleTest(String testType)
	{
		boolean terminate = false;
		int selection = 2;
		while (!terminate)
		{
			LCD.clear();
			LCD.drawString(testType + " test: ", 0, 0);
			LCD.drawString("Sample", 1, 2);
			LCD.drawString("Done", 1, 3);
			LCD.drawString(">", 0, selection);
			int button = Button.waitForPress();
			if(button == LEFT_BUTTON)
			{
				--selection;
				if (selection < 2)
				{
					selection = 3;
				}
			}
			else if (button == RIGHT_BUTTON)
			{
				++selection;
				if (selection > 3)
				{
					selection = 2;
				}
			}
			else if (button == OK_BUTTON)
			{
				switch (selection)
				{
				case 2:
					testRawNorm();
					break;
				case 3:
					terminate = true;
					break;
				}
			}
		}		
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
	
	private void runVariansTest(String test) {
		LCD.clear();
		LCD.drawString(test + " test:", 0, 0);
		LCD.drawString("* setup in", 2, 2);
	    LCD.drawString("unchanging", 4, 3);
	    LCD.drawString("environment", 4, 4);
		LCD.drawString("Press any key", 0, 6);
		LCD.drawString("when ready", 0, 7);
		Button.waitForPress();
		
		LCD.clear();
		LCD.drawString(test + " test:", 0, 0);
		LCD.drawString("Sampling", 2, 2);
		long start = System.currentTimeMillis();
		int[] samples = new int[10000]; 
		for (int i = 0; i < 10000; ++i)
		{
			samples[i] = mSensor.readNormalizedValue();
		}
		long done = System.currentTimeMillis();

		LCD.clear();
		LCD.drawString(test + " test:", 0, 0);
		LCD.drawString("Calculating", 2, 2);
		LCD.drawString("Please wait...", 2, 4);
		// Identify the samples with matching neighbors
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
		// Find max and min
		// find the average
		// Find the varians
		int max = samples[0];
		int min = samples[0];
		long average = 0;
		int[] varians = new int[1023];
		for (int i2 = 0; i2 < 1023; ++i2)
		{
			varians[i2] = 0;
		}
		
		for (int i2 = 1; i2 < 10000; ++i2)
		{
			average += samples[i2];
			if (samples[i2] < min)
			{
				min = samples[i2];
			}
			if (samples[i2] > max)
			{
				max = samples[i2];
			}
			++varians[samples[i2]];
		}
		average /= 10000;
		LCD.clear();
		LCD.drawString(test + " test", 0, 0);
		LCD.drawString("Measured 10000", 2, 2);
		LCD.drawString("samples", 2, 3);
		LCD.drawString("in ", 2, 4);
		LCD.drawInt((int)(done - start), 6, 4);
		LCD.drawString("ms", 9, 4);
		LCD.drawString("Press any key", 0, 6);
		Button.waitForPress();
		
		LCD.clear();
		LCD.drawString(test + " test", 0, 0);
		LCD.drawString("High val: ", 2, 2);
		LCD.drawInt(max, 12, 2);		
		LCD.drawString("Low val: ", 2, 3);
		LCD.drawInt(min, 12, 3);		
		LCD.drawString("Average: ", 2, 4);
		LCD.drawInt((int)average, 12, 4);		
		LCD.drawString("Press any key", 0, 6);
		Button.waitForPress();
		
		LCD.clear();
		LCD.drawString(test + " test", 0, 0);
		LCD.drawString("Varians: ", 2, 2);
		int index = 0;
		for (int i = 0; i < 1023; ++i)
		{
			if (varians[i] != 0)
			{
				LCD.drawInt(i, 4, index + 3);		
				LCD.drawString(": ", 4 + 3, index + 3);
				LCD.drawInt(varians[i], 4 + 3 + 2, index + 3);
				++index;
				if (index > 2)
				{
					LCD.drawString("Press any key", 0, 7);
					Button.waitForPress();
					LCD.clear();
					LCD.drawString(test + " test", 0, 0);
					LCD.drawString("Varians: ", 2, 2);
					index = 0;
				}
			}
		}
		LCD.drawString("Press any key", 0, index + 3 + 2);
		Button.waitForPress();
		
		LCD.clear();
		LCD.drawString(test + " test", 0, 0);
		LCD.drawString("Clusters:", 2, 2);
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
