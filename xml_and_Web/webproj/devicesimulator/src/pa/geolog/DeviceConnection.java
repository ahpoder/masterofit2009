package pa.geolog;

import java.io.*;
import java.net.*;

public class DeviceConnection extends Thread {

	// http://server/uri
	private String address;
	private int intervalMS;
	private int id;
	public DeviceConnection(String address, int intervalMS, int ID)
	{
		this.address = address + "/geolog/devices/" + ID;
		this.intervalMS = intervalMS;
		this.id = ID;
	}
	
	public static synchronized void postInfo(String address, String payload) throws IOException
	{
		URL url = new URL(address);
		HttpURLConnection conn = (HttpURLConnection)url.openConnection();
		
		conn.setRequestMethod("POST");
		conn.setAllowUserInteraction(false); // no user interact [like pop up]
		conn.setDoOutput(true); // want to send
		conn.setRequestProperty( "Content-type", "text/xml" );
		conn.setRequestProperty( "Content-length", Integer.toString(payload.length()));
		OutputStream ost = conn.getOutputStream();
		PrintWriter pw = new PrintWriter(ost);
		pw.print(payload); // here we "send" our body!
		pw.flush();
		pw.close();

		int i=1;// this will print all header parameter
		String hKey;
		int contentLength = 0;
		while ((hKey=conn.getHeaderFieldKey(i))!=null){
		   String hVal = conn.getHeaderField(i);
		   System.out.println(hKey+"="+hVal);
		   if (hKey.equals("Content-Length"))
		   {
			   contentLength = Integer.valueOf(hVal); 
		   }
		   i++;
		}
		//and InputStream from here will be body
        Reader in = new BufferedReader
        (new InputStreamReader(conn.getInputStream()));
        for (i = 0; i < contentLength; ++i)
        {
        	System.out.print((char)in.read());
        }
    	System.out.println();
/*
        while (in.ready())
        {
        	System.out.println((char)in.read());
        }
*/
		conn.disconnect();
	}
	
	/*
	 */
	
	public void dispose()
	{
		running = false;
		this.interrupt();
	}
	
	private boolean running;
    public void run() {
    	running = true;
		try {
	    	while (running)
	    	{
	    		postInfo(address, ContentBuilder.getNextContent(id));
	    		sleep(intervalMS);
	    	}				
		} catch (InterruptedException e1) {
			// TODO Auto-generated catch block
			if (running)
			{
				e1.printStackTrace();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
