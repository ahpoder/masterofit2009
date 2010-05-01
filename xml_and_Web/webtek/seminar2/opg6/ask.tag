<%@ tag import="java.util.Date" %>
<%@ variable name-given="question" %>
<%@ variable name-given="yes" %>
<%@ variable name-given="no" %>
<%@ variable name-given="total" %>
<% if (request.getParameter("ask")!=null) { 
     long stop = 
       Long.parseLong((String)application.getAttribute("stop"));
     if (new Date().getTime()>stop) 
       application.setAttribute("timeout", "");
     else {
       jspContext.setAttribute("question",
                               application.getAttribute("question"));
%>
       <form 
         method="post" 
         action="<%= response.encodeURL(request.getRequestURI()) %>">

		 <jsp:doBody var="br"/>
<% 
   String bbodyResult = (String)jspContext.getAttribute("br");
   java.io.PrintWriter oout = response.getWriter();
   if (bbodyResult == null || bbodyResult.isEmpty()) {
     oout.print(application.getAttribute("question").toString() + "?<br>");
     oout.print("<input type=\"radio\" name=\"vote\" value=\"yes\"> Yes<br>");
     oout.print("<input type=\"radio\" name=\"vote\" value=\"no\" checked> No<br>");
     oout.print("<input type=\"submit\" value=\"vote\">");
   }
   else {
     oout.print(bbodyResult);
   }
%>  
       </form>
<%   }
   } %>
