<%@ tag import="java.util.*" %>
<%-- add.tag used in ShoppingTags.jsp --%>
<%@ attribute name="item" required="true" %>
<%@ attribute name="amount" type="java.lang.Integer" required="true" %>
<%	if ( amount > 0 && !item.isEmpty() ){
			Map cart;
			cart = (Map)session.getAttribute( "cart" );
		
			if ( cart == null ) 
				return; 
		
	    Integer a = (Integer)cart.get( item );
	    if ( a == null ) 
	    	a = new Integer(0);
    
	    cart.put(item, new Integer( a.intValue() + amount ) );
	   }
%>
