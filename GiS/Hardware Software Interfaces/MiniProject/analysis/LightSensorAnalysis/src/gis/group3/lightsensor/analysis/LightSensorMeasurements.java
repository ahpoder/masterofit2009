package gis.group3.lightsensor.analysis;

import lejos.nxt.*;

public class LightSensorMeasurements {
	public LightSensorMeasurements(LightSensor sensor)
	{
		mSensor = sensor;
	}
	
	public void runConfigurationTest()
	{
		int val = mSensor.readNormalizedValue();
		System.out.println("" + val);
	}

	public void runFloodLightTest()
	{
		int val = mSensor.readNormalizedValue();
		System.out.println("" + val);
	}

	public void runSpeedExtLightingTest()
	{
		int val = mSensor.readNormalizedValue();
		System.out.println("" + val);
	}
	
	private LightSensor mSensor;
}
