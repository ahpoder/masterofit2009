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
		this.address = address;
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
	}
	
	/*
	   int i=1;// this will print all header parameter
		String hKey;
		while ((hKey=conn.getHeaderFieldKey(i))!=null){
		   String hVal = conn.getHeaderField(i);
		   System.out.println(hKey+"="+hVal);
		   i++;
		}
		//and InputStream from here will be body
		conn.getInputStream()
	 */
	
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
			e1.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
