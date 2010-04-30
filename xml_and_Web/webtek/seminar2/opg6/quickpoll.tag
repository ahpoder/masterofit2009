<%@ attribute name="title" required="true" %>
<%@ attribute name="duration" required="true" %>
<%@ attribute name="sheet" %>
<% response.addDateHeader("Expires", 0); 
   application.setAttribute("duration",
                            jspContext.findAttribute("duration")); 
%>
<html>
  <head>
    <title>${title}</title>
<%  if (jspContext.findAttribute("sheet")!=null) { %>
    <link rel="stylesheet" href="${sheet}" type="text/css">
<%  } %>
  </head>
  <body>
    <jsp:doBody/>
  </body>
</html>
