<%@ tag import="java.util.Date" %>
<%@ variable name-given="question" %>
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
       <jsp:doBody/>
       </form>
<%   }
   } %>
