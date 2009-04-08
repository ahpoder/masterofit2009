package gis.group3.sortingconveyor;

import lejos.nxt.*;

public class StopSensor implements Runnable {

	public StopSensor(StopSensorData stopSensorData) {
		mStopSensorData = stopSensorData;
		mTouchSensor = new TouchSensor(SensorPort.S2);
	}

	public void run() {
		if (mTouchSensor.isPressed()) {
			mStopSensorData.setButtonPressed();
		}
	}
    private StopSensorData mStopSensorData;
    private TouchSensor mTouchSensor;
}
