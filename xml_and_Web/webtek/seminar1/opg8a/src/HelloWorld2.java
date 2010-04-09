import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class HelloWorld2 extends HttpServlet {
  public String getServletInfo() {
    return "servlet example, by Møller & Schwartzbach";
  }

  public void init() {
    log("initializing");
  }

  public void doGet(HttpServletRequest request, 
                    HttpServletResponse response)
      throws IOException, ServletException {
    log("a thread is entering doGet");
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    out.println("<html><head><title>Servlet Example</title></head>"+
                "<body><h1>Hello World!</h1>"+
                "This page was last updated: "+new java.util.Date()+
                "</body></html>");
    log("a thread is leaving doGet");
  }

  public void doPost(HttpServletRequest request, 
                     HttpServletResponse response)
      throws IOException, ServletException {
    response.sendError(response.SC_METHOD_NOT_ALLOWED, 
                       "¿Que? - No habla POST!");
  }

  public void destroy() {
    log("shutting down");
  }
}
