import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * 
 */

/**
 * @author pmd
 *
 */
public class IPFilter implements Filter {
	ServletContext context;
	
	@Override
	public void init(FilterConfig c) throws ServletException {
		context = c.getServletContext();
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		//Forward request only when request from an accepted remote host
		if( request.getRemoteHost().equals("127.0.0.1") ){
			chain.doFilter( request, response );
		}
		else {
			HttpServletResponse resp = (HttpServletResponse)response;
			resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Your IP address does not have access to the requested resource");
		}
	}

	public void destroy() {
	}

}
