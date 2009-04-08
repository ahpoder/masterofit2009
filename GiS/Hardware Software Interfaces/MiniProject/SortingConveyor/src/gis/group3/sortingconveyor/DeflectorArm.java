package gis.group3.sortingconveyor;

import lejos.nxt.Motor;

public class DeflectorArm implements Runnable {

	public DeflectorArm(TransparancyData transparencyData, int delayBeforeDeflection)
	{
		mTransparencyData = transparencyData;
		mDelayBeforeDeflection = delayBeforeDeflection;
		Motor.A.setSpeed(1020); // 1020 degrees/sec ~ 170rpm @ 9V
	}
	public void run() {
		if (mTransparencyData.isNonTransparentObjectOnConvayor())
		{
			try {
				Thread.sleep(mDelayBeforeDeflection);
			} catch (InterruptedException e) {
			}
		    Motor.A.resetTachoCount();
			Motor.B.rotate(45);
			Motor.B.rotate(-45);
		}
	}
    private TransparancyData mTransparencyData;
    private int mDelayBeforeDeflection;
}
