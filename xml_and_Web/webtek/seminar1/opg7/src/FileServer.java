import java.net.*;
import java.io.*;
import java.util.*;
import java.security.*;

public class FileServer {
  int port;
  String wwwhome;

  Socket con;
  BufferedReader in;
  OutputStream out;
  PrintStream pout;

  FileServer(int port, String wwwhome) {
    this.port = port;
    this.wwwhome = wwwhome;
  }

  public static void main(String[] args) {
    if (args.length!=2) {
      System.out.println("Usage: java FileServer <port> <wwwhome>");
      System.exit(-1);
    }
    int port = Integer.parseInt(args[0]);
    String wwwhome = args[1];
    FileServer fs = new FileServer(port, wwwhome);
    fs.run();
  }

  void run() {
    ServerSocket ss = null; 
    try {
      ss = new ServerSocket(port); 
    } catch (IOException e) {
      System.err.println("Could not start server: "+e);
      System.exit(-1);
    }
    System.out.println("FileServer accepting connections on port "+
                       port);
            
    while (true) {
      try {
        con = ss.accept();
        in = new BufferedReader
                   (new InputStreamReader(con.getInputStream()));
        out = new BufferedOutputStream(con.getOutputStream());
        pout = new PrintStream(out);
                
        String request = in.readLine();
        log(con, request);
        HashMap<String, String> header = new HashMap<String, String>();
        
        String line;
        
        while((line = in.readLine()) != ""){
        	//We reached the terminating empty line. Get out of here.
        	if(line.isEmpty())
        		break;
        	//Add the header, value entry to the hashtable
        	header.put( line.substring(0, line.indexOf(":")).trim(), line.substring(line.indexOf(":")+1).trim());
        }

        //Handle the further action
        processRequest(request, header);
        
        pout.flush();
        
      } catch (IOException e) { 
        System.err.println(e); 
      }
      try {
        if (con!=null) 
          con.close(); 
      } catch (IOException e) { 
        System.err.println(e); 
      }
    }
  }

  void processRequest(String request, HashMap<String, String> header) {
    if (!request.startsWith("GET") || request.length()<14 ||
        !(request.endsWith("HTTP/1.0") || 
          request.endsWith("HTTP/1.1")) ||
        request.charAt(4)!='/') {
      errorReport(pout, con, "400", "Bad Request", 
                  "Your browser sent a request that "+
                  "this server could not understand.");
    } else {
      String req = request.substring(4, request.length()-9).trim();
      if (req.indexOf("/.")!=-1 || req.endsWith("~")) {
        errorReport(pout, con, "403", "Forbidden", 
                    "You don't have permission to access "+
                    "the requested URL.");
      } else {
        String path = wwwhome+"/"+req;
        File f = new File(path);
        if (f.isDirectory() && !path.endsWith("/")) {
          pout.print("HTTP/1.0 301 Moved Permanently\r\n"+
                     "Location: http://"+
                     con.getLocalAddress().getHostAddress()+":"+
                     con.getLocalPort()+req+"/\r\n\r\n");
          log(con, "301 Moved Permanently");
        }
        //The request has passed initial tests
        //Take a closer look at the header 
        //In order to do the necessary we need a hold on the requested resource
        else {
          if (f.isDirectory()) { 
            path = path+"index.html";
            f = new File(path);
          }
          try { 
        	//Test for a conditional request
        	if( header.containsKey("If-Modified-Since") ){
  			  long lastRequest = Long.parseLong( header.get( "If-Modified-Since" ) );
  			  //If resource not modified send a 304 Not Modified response
  			  //as per http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.3.5 
  			  if ( !( lastRequest > f.lastModified() ) ){ //== should suffice 
  			  	pout.print( "HTTP/1.0 304 Not Modified\r\n" );
  			  	pout.print( "Date: " + new Date() + "\r\n" );
				pout.print( "ETag: " + createChecksum(path) + "\r\n" );
  			  	/*pout.print("Location: http://"
						+con.getLocalAddress().getHostAddress()
						+":"
						+con.getLocalPort()
						+req
						+"\r\n\r\n"); */
				log( con, "304 Not Modified" );
  			  }
        	}
			else //Return the requested resource
			{
				InputStream file = new FileInputStream(f);
				String contenttype = URLConnection.guessContentTypeFromName( path );
				pout.print( "HTTP/1.0 200 OK\r\n" );
				if ( contenttype != null )
				  pout.print( "Content-Type: " + contenttype + "\r\n" );
				//Signal that the data may be cached for one hour, 
				//and the server should confirm all uses of the cached version
				pout.print( "Cache-Control: public, no-cache, must-revalidate, max-age=3600\r\n" );				
				pout.print( "LastModified: " + f.lastModified() + "\r\n" );				
				//We'll calculate the ETag as a strong validator according to
				//http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.3.3
				//ETag is also defined here
				//http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.11
				pout.print( "ETag: " + createChecksum(path) + "\r\n" );
				pout.print( "Date: " + new Date() + "\r\n" );
				//Terminate the header with an empty line
				pout.print( "Server: IXWT FileServer 1.0\r\n\r\n" );
				//Send the raw file 
				sendFile(file, out); 
				log(con, "200 OK");
			}
          } catch (FileNotFoundException e) { 
            errorReport(pout, con, "404", "Not Found", 
                        "The requested URL was not found "+
                        "on this server.");
          }
          catch (Exception e){
              errorReport(pout, con, "500", "Internal Server Error", 
                      "An unexpected error occurred.");        	  
          }
        }
      }
    }
  }
    
  void log(Socket con, String msg) {
    System.err.println(new Date()+" ["+
                       con.getInetAddress().getHostAddress()+
                       ":"+con.getPort()+"] "+msg);
  }
  
  void errorReport(PrintStream pout, Socket con,
                   String code, String title, String msg) {
    pout.print(
      "HTTP/1.0 "+code+" "+title+"\r\n"+
      "\r\n"+
      "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\r\n"+
      "<HTML><HEAD><TITLE>"+code+" "+title+"</TITLE>\r\n"+
      "</HEAD><BODY>\r\n"+
      "<H1>"+title+"</H1>\r\n"+msg+"<P>\r\n"+
      "<HR><ADDRESS>IXWT FileServer 1.0 at "+
      con.getLocalAddress().getHostName()+
      " Port "+con.getLocalPort()+"</ADDRESS>\r\n"+
      "</BODY></HTML>\r\n");
    log(con, code+" "+title);
  }

  void sendFile(InputStream file, OutputStream out) 
      throws IOException {
    byte[] buffer = new byte[1000];
    while (file.available()>0) 
      out.write(buffer, 0, file.read(buffer));
  }
  
  //Based on http://www.rgagnon.com/javadetails/java-0416.html
  private byte[] createChecksum(String filename) throws Exception{
	     InputStream fis =  new FileInputStream(filename);

	     byte[] buffer = new byte[1024];
	     MessageDigest complete = MessageDigest.getInstance("MD5");
	     
	     int numRead;
	     do {
	       numRead = fis.read(buffer);
	       if (numRead > 0) {
	         complete.update(buffer, 0, numRead);
	       }
	     } while (numRead != -1);
	     fis.close();
	     return complete.digest();	  
  }
}
