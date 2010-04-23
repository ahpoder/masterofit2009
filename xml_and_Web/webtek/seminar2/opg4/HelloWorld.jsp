<html>
<head>
<title>Hello world</title>
</head>
<body>
Hello <% if (request.getParameter("visitor") == null) { %>
 World!
<% } else { %>
<%= request.getParameter("visitor") %>
<% } %>
<%= new java.util.Date() %>

</body>
</html>
