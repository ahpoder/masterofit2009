package pa.geolog;

import java.io.*;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class DeviceMain {

	private void printRootMenu() {
		System.out.println();
		System.out.println("1. Send single POST");
		System.out.println("2. Start POST daemon");
		System.out.println("3. Toggle Verbose output");
		System.out.println("0. Exit");
		System.out.println();
		System.out.print("Select: ");
	}

	private ArrayList<DeviceConnection> connections = new ArrayList<DeviceConnection>();
	private boolean verbose = false;
	private void runRootMenu()
	{
		int selection = 0;
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		do
		{
			printRootMenu();
			try
			{
				selection = Integer.parseInt(br.readLine());
				switch (selection)
				{
				  case 1:
				  {
					System.out.print("\nEnter address to send to (e.g. http://www.pa.com:8080/geolog/devices/27): ");
					String address = br.readLine();
					System.out.print("\nEnter Device ID (must match string entered in address: ");
					String id = br.readLine();
					System.out.print("\nEnter Status of device (OK, DEPRECATED, ...): ");
					String status = br.readLine();
					System.out.print("\nEnter Lattitude of device (e.g. 57.1234): ");
					String lattitude = br.readLine();
					System.out.print("\nEnter Longitude of device (e.g. 57.1234): ");
					String longitude = br.readLine();
					
					DeviceStatus dStatus = DeviceStatus.valueOf(status);
					double dLattitude = Double.valueOf(lattitude);
					double dLongitude = Double.valueOf(longitude);
					
					String payload = ContentBuilder.buildContent(id, dStatus, dLattitude, dLongitude);
					DeviceConnection.postInfo(address, payload);
				  }
				  break;
				  case 2:
				  {
					System.out.print("\nEnter address to send to (e.g. http://www.pa.com:8080/geolog/devices/27): ");
					String address = br.readLine();
					System.out.print("\nEnter Device ID range (e.g. 100-200, must be integers: ");
					String idRange = br.readLine();
					System.out.print("\nEnter root lattitude of devices (e.g. 57.1234): ");
					String rLattitude = br.readLine();
					System.out.print("\nEnter root longitude of devices (e.g. 57.1234): ");
					String rLongitude = br.readLine();
					System.out.print("\nEnter location deviation (e.g. 2.74): ");
					String deviation = br.readLine();
					System.out.print("\nEnter transmission interval in seconds (e.g. 60): ");
					String interval = br.readLine();
					
					StringTokenizer st = new StringTokenizer(idRange, "-");
					if (st.countTokens() != 2)
					{
						throw new IOException("Invalid ID range supplied");
					}
					int fromID = Integer.valueOf(st.nextToken());
					int toID = Integer.valueOf(st.nextToken());
					
					double dLattitude = Double.valueOf(rLattitude);
					double dLongitude = Double.valueOf(rLongitude);
					double dDeviation = Double.valueOf(deviation);

					ContentBuilder.registerRootLocation(dLattitude, dLongitude, dDeviation);
					
					int iInterval = Integer.valueOf(interval);
					
					for (int i = fromID; i <= toID; ++i)
					{
						DeviceConnection dc = new DeviceConnection(address, iInterval * 1000, i);
						dc.start();
						connections.add(dc);
					}
				  }
				  break;
				  case 3:
				  {
					  verbose = !verbose;
					  // TODO implement
				  }
				  break;
				}
			}
			catch (IOException ex)
			{
				System.out.println("An exception occured: " + ex.toString() + "\r\n");
				if (verbose)
				{
					ex.printStackTrace();
				}
			}
		}
		while (selection != 0);
	}
	
	public static void main(String[] args) {
		DeviceMain dm = new DeviceMain();
		dm.runRootMenu();
	}
}