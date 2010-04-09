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

public class Scopes extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
    ServletContext c = getServletContext();
    Integer n = (Integer)c.getAttribute("n");
    if (n==null) 
      n = 0;
    n = n + 1;
    c.setAttribute("n", n);
    HttpSession s = request.getSession();
    Integer k = (Integer)s.getAttribute("k");
    if (k==null) 
      k = 0;
    k = k + 1;
    s.setAttribute("k", k);
    Integer m = 0;
    m = m + 1;
    response.setContentType("text/plain");
    PrintWriter out = response.getWriter();
    out.println("ServletContext value = "+n);
    out.println("HttpSession value = "+k);
    out.println("Local value = "+m);
  }
}
