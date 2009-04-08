package gis.group3.sortingconveyor;

import lejos.nxt.*;

public class BeltDrive implements Runnable {
	public BeltDrive(StopSensorData stopSensorData) {
		mStopSensorData = stopSensorData;
		Motor.A.setSpeed(500);
	}

	public void run() {
		if (mStopSensorData.isButtonPressed())
		{
			Motor.A.stop();
			System.exit(0);
		}
	}
    private StopSensorData mStopSensorData;
}
