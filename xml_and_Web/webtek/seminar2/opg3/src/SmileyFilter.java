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
public class SmileyFilter implements Filter {
	ServletContext context;
	
	@Override
	public void init(FilterConfig c) throws ServletException {
		context = c.getServletContext();
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletResponse hresp = (HttpServletResponse)response;
		
		// Wrap the response so we can post-process it.
		ServletResponse res = new BufferingResponseWrapper(hresp);
		// Perform the request
		chain.doFilter( request, res );
		// Analyze and replace :-) with <img src="<uri>/Smiley.jpg" alt="(Smiley face)" /> where <uri> is the request URI
		String resp = new String(((BufferingResponseWrapper)res).getResponseArray());
		resp = resp.replaceAll(":-\\)", "<img src=\"/images/Guestbook/Smiley.jpg\" alt=\"\\(Smiley face\\)\" />");
		// Write the changed response to the response stream
		hresp.getWriter().write(resp);
	}
	
	// Unimplemented alternative. Override the writer and scan the stream at runtime.

	public void destroy() {
	}

	class BufferingResponseWrapper extends HttpServletResponseWrapper {
	  CharArrayWriter buffer;
	  PrintWriter writer;

	  public BufferingResponseWrapper(HttpServletResponse res) {
		super(res);
		buffer = new CharArrayWriter();
		writer = new PrintWriter(buffer);
	  }

	  public PrintWriter getWriter() {
		return writer;
	  }
/*
	  Reader getResponse() { // Should never be called
		return new CharArrayReader(buffer.toCharArray());
	  }
*/
	  public char[] getResponseArray() {
	    return buffer.toCharArray();
	  }
	}
	
	class SmileyWriter extends Writer {
	  Writer finalWriter;
	  char[] smileyBuffer = new char[3];
	  public SmileyWriter(Writer finalWriter) {
	    this.finalWriter = finalWriter;
	  }
	  public void close() throws java.io.IOException {
	    finalWriter.close();
	  }

	  public void flush() throws java.io.IOException {
	    finalWriter.flush();
	  }

      public void write(char[] cbuf, int off, int len) throws java.io.IOException {
	    for (int i = off; i < len; ++i)
		{
		  finalWriter.flush();
		}
	    // TODO incomplete
	  }
	}
	
}
