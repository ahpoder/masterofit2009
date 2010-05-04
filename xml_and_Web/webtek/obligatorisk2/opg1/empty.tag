<%@ tag import="java.util.*" %>
<%-- empty.tag used in ShoppingTags.jsp --%>
<%
		Map cart;
		cart = (Map)session.getAttribute( "cart" );		
		if( cart == null ) 
			return; 			
		if( cart.isEmpty() ) {
%>
<jsp:doBody/>
<% } %>