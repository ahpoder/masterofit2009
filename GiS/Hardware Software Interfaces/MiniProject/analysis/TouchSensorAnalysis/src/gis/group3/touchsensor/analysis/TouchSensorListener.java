package gis.group3.touchsensor.analysis;
import lejos.nxt.LCD;
import lejos.nxt.SensorPort;
import lejos.nxt.SensorPortListener;
import lejos.nxt.TouchSensor;


public class TouchSensorListener implements SensorPortListener
{
	public TouchSensorListener(TouchSensor ts)
	{
		mts = ts;
	}
	public void stateChanged(SensorPort port, int oldValue, int newValue){
		
		if (mts.isPressed())
		{
			LCD.drawString("Touch pressed", 1, 2);
		}
		else
		{
			LCD.clear();
		}
		LCD.refresh();
	}
	TouchSensor mts;
}


