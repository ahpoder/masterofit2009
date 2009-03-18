package gis.group3.lightsensor.analysis;

import lejos.nxt.*;

public class LightSensorSpeedMeasurement {
	public LightSensorSpeedMeasurement(LightSensor sensor)
	{
		mSensor = sensor;
	}
	
	public void runTest()
	{
		int val = mSensor.readNormalizedValue();
		System.out.println("" + val);
	}
	
	private LightSensor mSensor;
}
