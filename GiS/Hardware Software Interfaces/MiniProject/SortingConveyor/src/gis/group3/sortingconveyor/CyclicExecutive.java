package gis.group3.sortingconveyor;

public class CyclicExecutive {

	/**
	 * 
	 */
	public static void main(String[] args) {
		StopSensorData touchSensorData = new StopSensorData();
		StopSensor touchSensor = new StopSensor(touchSensorData);
		BeltDrive beltDrive = new BeltDrive(touchSensorData);
		TransparancyData transparancyData = new TransparancyData();
		DeflectorArm deflectorArm = new DeflectorArm(transparancyData, 100);
		TransparencySensor transparancySensor = new TransparencySensor(transparancyData, 100);
		
		for (;;)
		{
			touchSensor.run();
			beltDrive.run();
			deflectorArm.run();
			transparancySensor.run();
		}
	}

}
