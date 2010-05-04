<%@ tag import="java.util.*" %>
<%-- loop.tag used in ShoppingTags.jsp --%>
<%@ variable name-given="item" %>
<%@ variable name-given="amount" %>
<%
		Map cart;
		cart = (Map)session.getAttribute( "cart" );		
		if( cart == null ) 
			return; 	
			
		Iterator i = cart.entrySet().iterator();    
    while (i.hasNext()) {
      Map.Entry me = (Map.Entry)i.next();
      jspContext.setAttribute( "item", String.valueOf( me.getKey() ) );
      jspContext.setAttribute( "amount", String.valueOf( me.getValue() ) );
%>
<jsp:doBody/>
<% }%> 



