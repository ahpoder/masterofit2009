<%@ tag import="java.util.Date" %>
<%@ variable name-given="question" %>
<% String question = request.getParameter("question"); 
   if (question!=null) { 
     jspContext.setAttribute("question", question);
     application.setAttribute("question", question);
     application.setAttribute("yes", new Integer(0));
     application.setAttribute("no", new Integer(0));
     int duration = 
       Integer.parseInt((String)application.getAttribute("duration"));
     long stop = new Date().getTime()+(1000*duration);
     application.setAttribute("stop", String.valueOf(stop));
     application.removeAttribute("timeout");
%>
     <jsp:doBody/>
<% } %>
