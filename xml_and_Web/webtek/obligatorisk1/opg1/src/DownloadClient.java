import java.util.*;
import java.net.*;
import java.io.*;

public class DownloadClient {
  public static void main(String[] args) {
	//Added some help to remember the order of arguments (if more than one)
    if (args.length!=1) {
        System.out.println("Usage: java SimpleClient <host>");
        System.exit(-1);
      }
    try {
      String host = args[0];
      //We default the request to be on port 80
      Integer port = 80;
      //Set up the connection
      Socket con = new Socket(host, port);
      
      //Send the request on the connection output stream (based on IXVT p. 375)
      BufferedWriter out =
    	  new BufferedWriter
    	     (new OutputStreamWriter(con.getOutputStream(), "UTF8"));
      //We're interested in the host root only
      out.write("GET / HTTP/1.1\r\n"); 
      //The Host header is required (at least at the tested site: www.brics.dk)
      out.write("Host: "+host+"\r\n"); 
      //This one is merely to inform the server. It is NOT required for the request to be valid (on the server tested)
      out.write("User-Agent: IXVT\r\n");
      //Signal GET request termination with an empty line. This one is required for the request to be valid.
      //If it is missing we will be waiting 'forever' for a server response
      out.write("\r\n"); 
      out.flush();
      
      //Get a handle on the server response      
      InputStreamReader in = new InputStreamReader(con.getInputStream());
      //This one's for easy line reading
      BufferedReader inb = new BufferedReader( in );
      
      //The response status is in the first line
      String responseStatus = inb.readLine();
      
      //The response header follows - read and store it
      HashMap<String, String> header = new HashMap<String, String>();      
      String line;      
      while((line = inb.readLine()) != ""){
      	//We reached the terminating empty line. Get out of here.
      	if(line.isEmpty())
      		break;
      	//Add the (header, value) entry to the hash map
      	header.put( line.substring(0, line.indexOf(":")).trim(), line.substring(line.indexOf(":")+1).trim());
      }

      //TODO: Analyze the response status to handle a '301 Moved Permanently'
      
      //Write the header to a file
      PrintWriter pw = new PrintWriter("header.out");
      pw.printf("%1$s\r\n", responseStatus);
      Set<String> set = header.keySet();
      Iterator<String> iter = set.iterator();
      while( iter.hasNext()){
    	  String key = (String)iter.next();
    	  pw.printf("%1$s:%2$s\r\n", key, (String)header.get(key));
      }
      pw.close();
      
      //Pipe the response body into body.out 
      FileOutputStream fo = new FileOutputStream("body.out");
      int c;
      while ((c = in.read())!=-1)
        fo.write(c);
      fo.close();
      
      //Do a clean up of the resources
      con.close();
      
    } catch (IOException e) {
      System.err.println(e); 
    }
  }
}
