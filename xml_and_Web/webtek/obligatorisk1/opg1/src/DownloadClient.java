//import java.util.*;
import java.net.*;
import java.io.*;
import sun.misc.BASE64Encoder;

public class DownloadClient {

  public static String encode(String username, String password) {
	BASE64Encoder encoder = new BASE64Encoder();
	  return encoder.encode(String.format("%s:%s", username,password).getBytes());
  }

  // this method performs a standard HHTP request and read the response. 
  // If a moved permanently is received follow the link.
  // If an authorazation request is received send user username and password
  public static void connectAndPerformGet(String host, int port, String username, String password, Boolean authRequired) throws UnknownHostException, IOException, UnsupportedEncodingException, FileNotFoundException
  {
      Socket con = null;
      InputStreamReader in = null;
      String[] header = null;
      int c;
      int counter = 0;
	  //Set up the connection
	  con = new Socket(host, port);
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
	  
	  // check if authorization header should be added
	  if (authRequired)
	  {
	    // Add base64 encoding of the username and password to header
		out.write("Authorization: Basic " + encode(username, password) + "\r\n");
	  }
	  
	  //Signal GET request termination with an empty line. This one is required for the request to be valid.
	  //If it is missing we will be waiting 'forever' for a server response
	  out.write("\r\n"); 
	  out.flush();
	  
	  //Get a stream on the server response      
	  in = new InputStreamReader(con.getInputStream());
	  
	  //Read the header into a string buffer. We're done when having reached an empty line (\r\n\r\n)
	  //We've avoided buffered read in order to support images etc. Mixing buffered read with character reads
	  //will fail, as the buffered reader will read ahead.
	  StringBuffer sbuf = new StringBuffer();
	  while ( ( c = in.read() ) != -1 ){
		  sbuf.append( (char)c );
		  if(sbuf.indexOf( "\r\n\r\n" ) > -1 )
			  break;
	  }
	  //Split the header at line breaks
	  header = sbuf.toString().split("[\r\n]{2}");
		  
	  //Analyze the response status to handle a '301 Moved Permanently'
	  if(header[0].contains("301")){
		  //Find and extract the location
		  String newHost = null;
		  for(int i = 0; i < header.length; i++) {
			  if(header[i].indexOf("Location:") > -1) {
				  newHost = header[i].substring(header[i].indexOf(":")+1).trim();
				  break;
			  }
		  }
		  // Call recursively self with new host.
		  // Be adviced that if there is a loop in the Moved Permanently locations this will result in
		  // an infinite loop, causing a stack overflow in Java.
		  System.out.println("Redirecting to " + newHost);
		  connectAndPerformGet(newHost, port, name, password, false);
	  }
	  // Analyse the response status to handle a 401 Unauthorized
	  else if(header[0].contains("401")){
	    System.out.println("Authorization required, sending auth");
		connectAndPerformGet(host, port, name, password, true);
	  }
	  // If not a redirect or auth request write the response to a file
	  else {
		//Write the header to a file
		PrintWriter pw = new PrintWriter("header.out");
		for(int i = 0; i < header.length; i++)
		  pw.printf("%1$s\r\n", header[i]);
		pw.close();
      
		//Pipe the response body into body.out use the InputStreamReader for this purpose 
		FileOutputStream fo = new FileOutputStream("body.out");
		// Be adviced that some servers do not close their stream, which means that end-of-stream
		// will never be reached and we will block "forever". This is true e.g. for www.google.com
		// this program do not support this behaviour, but a solution could be to have a read timeout
		// or to test for data availability before reading.
		while ((c = in.read())!=-1)
		  fo.write(c);
		fo.close();
	  }

	  // Close the connection. Granted this could be done before the recursive call to 
	  // avoid maintaining multiple simultanious connections, but since the number
	  // of Moved Permanently 
      con.close();
  }
  
  public static void main(String[] args) {
	//Added some help to remember the order of arguments (if more than one)
    if (args.length != 2 && args.length != 4) {
        System.out.println("Usage: java SimpleClient <host> <port> [<username> <password>]");
        System.exit(-1);
      }
    try {
      String host = args[0];
      Integer port = Integer.parseInt(args[1]);

	  if (args.length == 2) {
	    connectAndPerformGet(host, port, null, null, false);
	  }
	  else {
	    connectAndPerformGet(host, port, args[2], args[3], false);
	  }
	  System.out.println("DONE");
    } catch (IOException e) {
      System.err.println(e); 
    }
  }
}
