<%@ tag %>
<%-- url.tag used in ShoppingTags.jsp --%>
<%@ attribute name="target" %>
<% 
	if( target=="##self" ) {
		String url = request.getRequestURI();
		session.setAttribute( "url", response.encodeURL(url) );
	}
	else if( target=="buy" ) {
		session.setAttribute( "url", response.encodeURL( "buy" ) );
	}
%>
<jsp:doBody/>