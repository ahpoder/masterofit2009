<%@ page errorPage="error.jsp" %>
<html>
  <head><title>ErrorProne</title></head>
  <body>
    <h1>The Value Store</h1>
    <% String command = request.getParameter("command"); %>
    <% String variable = request.getParameter("variable"); %>
    <% if (command.equals("reset")) {
         application.setAttribute(variable, "0");
       } else if (command.equals("inc")) {
         int value = Integer.parseInt((String)application.getAttribute(variable)) + 1;
         application.setAttribute(variable, String.valueOf(value));
       }
    %>
    The value of <%= variable %> is now <%= application.getAttribute(variable) %>
  </body>
</html>
