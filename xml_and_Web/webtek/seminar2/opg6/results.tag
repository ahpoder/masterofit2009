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
   <jsp:doBody var="br"/>
<% 
   String bbodyResult = (String)jspContext.getAttribute("br");
   java.io.PrintWriter oout = response.getWriter();
   if (bbodyResult == null || bbodyResult.isEmpty()) {
     oout.print("<table border="1">");
     oout.print("<tr><td>yes</td><td>" + yes + </td></tr>);
     oout.print("<table border="1">");
     oout.print("<table border="1">");
     oout.print("<table border="1">");
     oout.print("<table border="1">");
	
	${yes}
	<tr><td>no</td><td>${no}</td></tr>
	<tr><td>total</td><td>${total}</td></tr>
	</table>
   }
   else {
     oout.print(bbodyResult);
   }
%>  

<% } %>
