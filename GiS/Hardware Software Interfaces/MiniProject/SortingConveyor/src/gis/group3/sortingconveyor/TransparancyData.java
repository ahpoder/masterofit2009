package gis.group3.sortingconveyor;

public class TransparancyData {
	public boolean isNonTransparentObjectOnConvayor()
	{
		return mNonTransparentObjectOnConvayor;
	}
	public void setNonTransparentObjectOnConvayor(boolean nonTransparentObjectOnConvayor)
	{
		mNonTransparentObjectOnConvayor = nonTransparentObjectOnConvayor;
	}
	private boolean mNonTransparentObjectOnConvayor = false;
}
