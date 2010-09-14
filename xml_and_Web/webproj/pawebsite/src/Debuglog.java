import java.io.*;

public class Debuglog {

  public static void write(String msg)
  {
	try {
		// Create file 
		FileWriter fstream = new FileWriter("c:\\debuglog.txt",true);
			BufferedWriter out = new BufferedWriter(fstream);
		out.write("\r\n\r\n" + msg + "\r\n\r\n");
		//Close the output stream
		out.close();
		}catch (Exception e){//Catch exception if any
		  System.err.println("Error: " + e.getMessage());
	}
  }
}
