<%@ page isErrorPage="true" %>
<html>
<head>
<title>Error page</title>
</head>
<body>
ERROR occured!<br><br>Exception: 
<% if (exception != null) { %>
<%= exception.getMessage() %>
<% } else { %>
You requested the error page directly, you idiot!
<% } %>
</body>
</html>
