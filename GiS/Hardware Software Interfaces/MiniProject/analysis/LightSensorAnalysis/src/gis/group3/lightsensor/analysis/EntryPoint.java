package gis.group3.lightsensor.analysis;

import lejos.nxt.*;

public class EntryPoint {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		LightSensor ls = new LightSensor(SensorPort.S1);
		LightSensorMeasurements lsm = new LightSensorMeasurements(ls);
//		lsm.runLinearityTest();
		lsm.runReactionTimeTest();
	}
}
