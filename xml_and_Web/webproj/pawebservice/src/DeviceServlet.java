/*
   This servlet illustrates the differences between
   various scope levels i Servlets.

   Open this servlet in two different browser windows
   and reload their contents repeatedly. Explain how
   and why the different numbers change their values.
*/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;
import org.jdom.*;
import org.jdom.input.*;
import org.jdom.output.*;
import org.jdom.xpath.*;
import java.util.*;
import java.net.*;

public class DeviceServlet extends HttpServlet {

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

	simpleResponse( "You called the DeviceServlet GET handler",
					response);
	return;
  }

  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {

	simpleResponse( "You called the DeviceServlet POST handler",
					response);
	return;
  }

   public void doPut(HttpServletRequest request,
                      HttpServletResponse response)
      throws IOException, ServletException {

	simpleResponse( "You called the DeviceServlet PUT handler",
					response);
	return;
   }

   private void simpleResponse( String title,
   								HttpServletResponse response )
   		throws IOException, ServletException{

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<html>");
		out.println("<head>");
		out.println("<title>geolog</title>");
		out.println("</head>");
		out.println("<body>");
		out.println("<h1>");
		out.println( title );
		out.println("</h1>");
		out.println("</body>");
		out.println("</html>");
		return;
   }
}
