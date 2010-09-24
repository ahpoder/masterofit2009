package pa.geolog;
import java.util.*;

public enum DeviceStatus {
	OK,
	DISCONNECTED,
	ERROR,
	DEPRECATED;

	/**
		Return a random status with OK being prevalent
	*/
	public static DeviceStatus getRandomStatus(){
		//counter++;
		//Random r = new Random(counter);
		int i = r.nextInt(10);
		DeviceStatus result = null;
		switch(i){
			case 0:
			case 1:
			case 2:
			case 3: result = DeviceStatus.OK; break;
			case 4:
			case 5: result = DeviceStatus.ERROR;break;
			case 6: result = DeviceStatus.DISCONNECTED; break;
			case 7: result = DeviceStatus.DEPRECATED;break;
			case 8:
			case 9: result = DeviceStatus.OK; break;
		}
		return result;
	}

	private static Random r = new Random(new Date().getTime());
}
