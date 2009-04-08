package gis.group3.sortingconveyor;

import lejos.nxt.LightSensor;
import lejos.nxt.SensorPort;

public class TransparencySensor implements Runnable {

	public TransparencySensor(TransparancyData transparencyData, int sensitivityLevel)
	{
		mTransparencyData = transparencyData;
		mSensitivityLevel = sensitivityLevel;
		mLightSensor = new LightSensor(SensorPort.S1);
		configurationValue = mLightSensor.readNormalizedValue();
	}
	
	public void run() {
		mTransparencyData.setNonTransparentObjectOnConvayor(mLightSensor.readNormalizedValue() < (configurationValue - mSensitivityLevel));
	}
	private int mSensitivityLevel;
    private TransparancyData mTransparencyData;
    private LightSensor mLightSensor;
    private int configurationValue;
}
