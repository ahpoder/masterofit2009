<%@ variable name-given="vote" %>
<% String vote = request.getParameter("vote");
   if (vote!=null) {
     jspContext.setAttribute("vote", vote);
     if (vote.equals("yes")) {
       int yes = ((Integer)application.getAttribute("yes")).intValue();
       application.setAttribute("yes", new Integer(yes+1));
     } else {
       int no = ((Integer)application.getAttribute("no")).intValue();
       application.setAttribute("no", new Integer(no+1));
     }
%>
     <jsp:doBody/>
<% } %>
