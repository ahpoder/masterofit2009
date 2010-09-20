package pa.geolog;

import java.util.StringTokenizer;

public class CommandArguments {
	private boolean help = false;
	public boolean hasHelp() { return help; }

	private String host = null;
	public boolean hasHost() { return host != null; }
	public String getHost() { return host; }

	private DeviceStatus status = null;
	public boolean hasStatus() { return status != null; }
	public DeviceStatus getStatus() { return status; }

	private String id = null;
	public boolean hasSingleID() { return id != null; }
	public String getSingleID() { return id; }

	private int fromID = -1;
	private int toID = -1;
	public boolean hasIDRange() { return fromID != -1 && toID != -1; }
	public int getFromID() { return fromID; }
	public int getToID() { return toID; }

	private double longitude = Double.MAX_VALUE;
	public boolean hasLongitude() { return longitude != Double.MAX_VALUE; }
	public double getLongitude() { return longitude; }

	private double latitude = Double.MAX_VALUE;
	public boolean hasLatitude() { return latitude != Double.MAX_VALUE; }
	public double getLatitude() { return latitude; }

	private double deviation = 0;
	public boolean hasDeviation() { return deviation != 0; }
	public double getDeviation() { return deviation; }

	private int interval = -1;
	public boolean hasInterval() { return interval != -1; }
	public int getInterval() { return interval; }

	public CommandArguments(String[] args) throws Exception
	{
		for (int i = 0; i < args.length; ++i)
		{
			if (args[i].equals("--help"))
			{
				help = true;
			}
			else if (args[i].equals("--host"))
			{
				++i;
				host = args[i];
			}
			else if (args[i].equals("--status"))
			{
				++i;
				status = DeviceStatus.valueOf(args[i]);
			}
			else if (args[i].equals("--id"))
			{
				++i;
				String temp = args[i];
				if (temp.contains("-"))
				{
					StringTokenizer st = new StringTokenizer(temp, "-");
					if (st.countTokens() != 2)
					{
						id = temp;
					}
					else
					{
						try
						{
							fromID = Integer.parseInt(st.nextToken());
							toID = Integer.parseInt(st.nextToken());
						}
						catch (NumberFormatException ex)
						{
							id = temp;
							fromID = -1;
							toID = -1;
						}
					}
				}
				else
				{
					id = temp;
				}
			}
			else if (args[i].equals("--longitude"))
			{
				++i;
				longitude = Double.valueOf(args[i]);
			}
			else if (args[i].equals("--latitude"))
			{
				++i;
				latitude = Double.valueOf(args[i]);
			}
			else if (args[i].equals("--deviation"))
			{
				++i;
				deviation = Double.valueOf(args[i]);
			}
			else if (args[i].equals("--interval"))
			{
				++i;
				interval = Integer.valueOf(args[i]);
			}
			else
			{
				throw new Exception("Invalid argument found: " + args[i]);
			}
		}
	}

	public static void printHelp()
	{
		System.out.println("Usage:");
		System.out.println("java pa.geolog.DeviceMain [arguments]");
		System.out.println("  If no arguments are supplied a menu is printed");
		System.out.println("  Arguments:");
		System.out.println("    --help: print this menu");
		System.out.println("    --host <host>: The host containing the service, e.g. www.pa.com");
		System.out.println("    --status <status>: The status to report, e.g. OK");
		System.out.println("    --id <id>[-<id>]: The id (or ids) of the device(s), e.g. 27 or 10-20");
		System.out.println("    --latitude <latitude>: The latitude of the device(s), e.g. 54.124353");
		System.out.println("    --longitude <longitude>: The longitude of the device(s), e.g. 9.124353");
		System.out.println("    --deviation <deviation>: The range by which the latitude and longitude is allowed to change, e.g. 0.25324");
		System.out.println("    --interval <seconds>: The interval between transmissions, e.g. 60");
		System.out.println("  host, status, id, longitude and latitude are mandatory, if the remaining");
		System.out.println("  two arguments are omitted only a single device packet is transmitted -");
		System.out.println("  identical to interval = -1 and deviation = 0");
	}
}
