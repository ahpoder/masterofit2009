//import java.util.*;
import java.net.*;
import java.io.*;

public class DownloadClient {
  public static void main(String[] args) {
	//Added some help to remember the order of arguments (if more than one)
    if (args.length!=2) {
        System.out.println("Usage: java SimpleClient <host> <port>");
        System.exit(-1);
      }
    try {
      String host = args[0];
      Integer port = Integer.parseInt(args[1]);

      Socket con = null;
      InputStreamReader in = null;
      String[] header = null;
      int c;
      int counter = 0;
      //While loop to follow redirects
      while(true){
    	  counter++;
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
        	  for(int i = 0; i < header.length; i++)
        		  if(header[i].indexOf("Location:") > -1)
        			  host = header[i].substring(header[i].indexOf(":")+1).trim();
          }
          else
        	  //Other response - get out of here
        	  break;
          //This is supposed to be a sefety valve for multiple 301 responses
          //if(counter > 3)
          //	break;      
      }
      
      //Write the header to a file
      PrintWriter pw = new PrintWriter("header.out");
	  for(int i = 0; i < header.length; i++)
		  pw.printf("%1$s\r\n", header[i]);
      pw.close();
      
      //Pipe the response body into body.out use the InputStreamReader for this purpose 
      FileOutputStream fo = new FileOutputStream("body.out");
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
