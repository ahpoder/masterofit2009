import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class QuickPollSetup extends HttpServlet {
  public void doPost(HttpServletRequest request, 
                     HttpServletResponse response)
      throws IOException, ServletException {
    String q = request.getParameter("question");
    ServletContext c = getServletContext();
    c.setAttribute("question", q);
    c.setAttribute("yes", new Integer(0));
    c.setAttribute("no", new Integer(0));
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    out.print("<html><head><title>QuickPoll</title></head><body>"+
              "<h1>QuickPoll</h1>"+
              "Your question has been registered. "+
              "Let the vote begin!"+
              "</body></html>");
  }
}
