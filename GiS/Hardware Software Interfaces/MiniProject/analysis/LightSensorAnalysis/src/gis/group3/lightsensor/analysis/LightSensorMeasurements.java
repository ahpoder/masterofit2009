package gis.group3.lightsensor.analysis;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;

import lejos.nxt.*;

public class LightSensorMeasurements {
	public LightSensorMeasurements(LightSensor sensor)
	{
		mSensor = sensor;
	}
		
	FileOutputStream fos =  null; 
	public void runConfigurationTest()
	{
		try {
			File f = new File("samples.dat");
			if (f.exists())
			{
				f.delete();
			}
			f.createNewFile();
			fos = new FileOutputStream(f);
		} catch (IOException e) {
		}
		finally
		{
			if (fos != null)
			{
				try {
					fos.close();
				} catch (IOException e) {
				}
			}
		}
		int[] samples = new int[1024];
		// Read the values in their raw form
		LCD.drawString("Sampling raw", 1, 2);
		int i = 0;
		long now = System.currentTimeMillis();
		while (!Button.ENTER.isPressed())
		{
			int val = mSensor.readValue();
			samples[i++] = val;
			if (i % 1024 == 0 && i != 0)
			{
				fos.write(samples);
				long diff = System.currentTimeMillis() - now;
				float speed = (i * 1000) / diff;
				LCD.drawString("Sample-speed: ", 1, 2);
			}
		}
		// Calibrate
		LCD.drawString("Calibrating", 1, 2);
		LCD.drawString("Light object", 2, 2);
		Button.waitForPress();
		mSensor.calibrateHigh();
		LCD.drawString("Calibrating", 1, 2);
		LCD.drawString("Dark object", 2, 2);
		Button.waitForPress();
		mSensor.calibrateHigh();
		LCD.drawString("Sampling normalized", 1, 2);
		while (!Button.ENTER.isPressed())
		{
			int val = mSensor.readNormalizedValue();
			// TODO Store samples
		}
	}

	public void runFloodLightTest()
	{
		LCD.drawString("Sampling floodlight", 1, 2);
		// TODO What is default - on or off???
		mSensor.setFloodlight(true);
		while (!Button.ENTER.isPressed())
		{
			int val = mSensor.readValue();
			// TODO Store samples
		}
		// Calibrate
		LCD.drawString("Calibrating", 1, 2);
		LCD.drawString("Light object", 2, 2);
		Button.waitForPress();
		mSensor.calibrateHigh();
		LCD.drawString("Calibrating", 1, 2);
		LCD.drawString("Dark object", 2, 2);
		Button.waitForPress();
		mSensor.calibrateHigh();
		LCD.drawString("Sampling floodlight configured", 1, 2);
		while (!Button.ENTER.isPressed())
		{
			int val = mSensor.readValue();
			// TODO Store samples
		}
	}

	public void runSpeedExtLightingTest()
	{
		// TODO should we configure first???
		LCD.drawString("Sampling speed", 1, 2);
		while (!Button.ENTER.isPressed())
		{
			int val = mSensor.readValue();
			// TODO Store samples
		}
	}
	
	// TODO how do we access the data stored???
	
	private LightSensor mSensor;
}
