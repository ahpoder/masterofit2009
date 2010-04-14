import java.net.*;
import java.io.*;

public class SimpleClient {
  public static void main(String[] args) {
	//Added some help to remember the order of arguments (if more than one)
    if (args.length!=1) {
        System.out.println("Usage: java SimpleClient <host>");
        System.exit(-1);
      }
    try {
      String host = args[0];
      //We default this to be a http request on port 80
      Integer port = 80;
      //Set up the connection
      Socket con = new Socket(host, port);
      
      //Send the request on the connection outputstream (based on IXVT p. 375)
      BufferedWriter out =
    	  new BufferedWriter
    	     (new OutputStreamWriter(con.getOutputStream(), "UTF8"));
      //We're interested in the host root only
      out.write("GET / HTTP/1.1\r\n"); 
      //The Host header is required (at least at the tested site: www.brics.dk)
      out.write("Host: "+host+"\r\n"); 
      //This one is merely to inform the server. It is NOT required for the request to be valid
      out.write("User-Agent: IXVT\r\n");
      //Signal GET request termination with an empty line. This one is required for the request to be valid.
      //If it is missing we just be waiting "forever" for a server response
      out.write("\r\n"); 
      out.flush();
      
      //Get a handle on the server response      
      InputStreamReader in = new InputStreamReader(con.getInputStream());
      //We default the output to be piped into response.out 
      FileOutputStream fo = new FileOutputStream("response.out");
      int c;
      while ((c = in.read())!=-1)
        fo.write(c);
      
      //Do a clean up of the resources
      con.close();
      fo.close();
    } catch (IOException e) {
      System.err.println(e); 
    }
  }
}
