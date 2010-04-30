<%@ variable name-given="yes" %>
<%@ variable name-given="no" %>
<%@ variable name-given="total" %>
<% if (request.getParameter("results")!=null) { 
     int yes = ((Integer)application.getAttribute("yes")).intValue();
     int no = ((Integer)application.getAttribute("no")).intValue();
     jspContext.setAttribute("yes", String.valueOf(yes));
     jspContext.setAttribute("no", String.valueOf(no)); 
     jspContext.setAttribute("total", String.valueOf(yes+no));
%>
     <jsp:doBody/>
<% } %>
