package gis.group3.touchsensor.analysis;

import lejos.nxt.Button;
import lejos.nxt.SensorPort;
import lejos.nxt.TouchSensor;


public class EntryPoint {

	/**
	 * @param args
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws InterruptedException {
		// TODO Auto-generated method stub
		TouchSensor ts = new TouchSensor(SensorPort.S1);
		SensorPort.S1.addSensorPortListener(new TouchSensorListener(ts));
		Button.ESCAPE.waitForPressAndRelease();
	}

}
