<%@ tag import="java.util.*" %>
<%-- cart.tag used in ShoppingTags.jsp --%>
<%-- The cart will hold a map of items and amounts --%>
<% Map cart;
	 if (session.isNew()) {
		 cart = new TreeMap();
		 session.setAttribute("cart", cart);
	 }
%>
<jsp:doBody/>