package gis.group3.sortingconveyor;

public class StopSensorData {
	public boolean isButtonPressed()
	{
		return mButtonPressed;
	}
	public void setButtonPressed()
	{
		mButtonPressed = true;
	}
	private boolean mButtonPressed = false;

}
