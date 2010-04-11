import java.net.*;
import java.io.*;

public class SimpleClient {
  public static void main(String[] args) {
    if (args.length!=3) {
        System.out.println("Usage: java SimpleClient <host>");
        System.exit(-1);
      }
    Socket con = null;
    FileOutputStream fo = null;
    try {
      String host = args[0];
      Integer port = 80;
      con = new Socket(host, port);

      //Demo på seminar var kopieret fra bogens ImFeelingLucky eksempel
      //BufferedReader forventer text så ikke god til billeder. Laver om på bitstrengen. Brug InputStream og OutputStream
      PrintStream out = new PrintStream(con.getOutputStream());
      out.print("GET / HTTP/1.1" );
      out.write(0); // mark end of message (signal to the server)
      out.flush();
      
      fo = new FileOutputStream("response.out");
      InputStreamReader in = new InputStreamReader(con.getInputStream());
      int c;
      while ((c = in.read())!=-1)
        fo.write(c);// System.out.print((char)c);
      
    } catch (IOException e) {
      System.err.println(e); 
    }
    finally{
        con.close();
        fo.close();
    }
  }
}
