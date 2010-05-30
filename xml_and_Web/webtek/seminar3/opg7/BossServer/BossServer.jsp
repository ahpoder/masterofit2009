<html>
<head>
<title>BossServer</title>
</head>
<body>
<%!
    StringBuilder id = new StringBuilder();
	StringBuilder msg = new StringBuilder();
%>
<% 
	String requestType = request.getParameter("type");
	String requestKey = request.getParameter("key");
	if (requestType != null && requestType.equals("ID")) { 
		id.append((char)(new Integer(requestKey).intValue()));
	} else if (requestType != null && requestType.equals("Msg")) { 
		msg.append((char)(new Integer(requestKey).intValue()));
	}
%>
<%= "ID: " + id.toString() + " - Msg: " + msg.toString() %>
</body>
</html>
