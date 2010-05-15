import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

public class ChatServer extends HttpServlet {
  // Private class representing the information about a single chat entry.
  private class ChatItem {
	public ChatItem(String name, String text) {
		this.name = name; 
		this.text = text;
		this.dateTime = new Date(); 
	}
	
	public String name; // Name identifies the sender
	public String text; // Text is the text of the entry
	public Date dateTime; // Date shows when it was entered. This can also be used to identify how long ago there was activity on a given chat.
  }
  
  // Private member function used to escape the html chars. For some strange reason this method does
  // not exist in the Java API, only URLEncode, hwich also encodes " ".
  private static String htmlEscape(String s) {
    StringBuffer b = new StringBuffer();
	for (int i = 0; i < s.length(); ++i) {
	  char c = s.charAt(i);
	  switch (c) {
	    case '<': b.append("&lt;"); break;
	    case '>': b.append("&gt;"); break;
	    case '"': b.append("&quot;"); break;
	    case '\'': b.append("&apos;"); break;
	    case '&': b.append("&amp;"); break;
		default: b.append(c);
	  }
	}
	return b.toString();
  }

  // We only support GET, as the entire service is implemented using GET.
  // Acording to the principle of HTTP GET should not have side effects, but
  // since this ChatServer is only accessed by out "application" (AJAX),
  // We have allowed it. POST could just as well have been used.
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
    ServletContext c = getServletContext();
	
	// Get the three parameters - only chat is mandetory.
    String chat = request.getParameter("chat");
	if (chat == null) {
		// "impossible" unless someone accessed the ChatServer outside the ChatClient AJAX access.
		response.sendError(HttpServletResponse.SC_BAD_REQUEST, "This service is not designed to be accessed directly! - chat may not be absent");
		return;
	}
	
    String name = request.getParameter("name");
    String text = request.getParameter("text");
	if (name == null ^ text == null) {
		// "impossible" unless someone accessed the ChatServer outside the ChatClient AJAX access.
		response.sendError(HttpServletResponse.SC_BAD_REQUEST, "This service is not designed to be accessed directly! - either name and text is both non-null or both null");
		return;
	}

	// Create the response in a StringBuilder so we are able to set the 
	// resonse length.
	StringBuilder sb = new StringBuilder();
	sb.append("<html>");
	sb.append("<head>");
	sb.append("<title>Chat response</title>"); // title is only decorative, it serves no purpose.
	sb.append("</head>");
	sb.append("<body>");
	sb.append("<table>");

	// Protect all access to the static (ServletContext-vide) data.
	synchronized (this) {
		// Extract the static (ServletContext-vide) Hashtable of all ongoing chats on the servlet.
		Hashtable<String,ArrayList<ChatItem> > n = (Hashtable<String,ArrayList<ChatItem> >)c.getAttribute("chats");
		if (n == null) {
			// If this is the first time the ChatServer is accessed since last restart,
			// create the Hashtable of chats.
			n = new Hashtable<String,ArrayList<ChatItem> >();
			// And add it to the ServletContext
			c.setAttribute("chats", n);
		}
		
		if (!n.containsKey(chat)) {
			// If the requested chat is unknown, add it to the active chat list.
			n.put(chat, new ArrayList<ChatItem>());
		}
		
		// Get the active chat from the chat list
		ArrayList<ChatItem> chatList = n.get(chat);
		
		if (name != null) { // If name is non-null, then text is also non-null.
			// If name is non-null then we should add to the chat, so e create a new ChatItem
			ChatItem ci = new ChatItem(name, text);
			// And pust it to the front.
			chatList.add(0, ci); 
		}
		
		// Regardless of whether a new ChatItem was added, all items of the chat must be returned.
		for (Iterator<ChatItem> i = chatList.iterator(); i.hasNext(); ) {
			ChatItem ciOut = i.next();
			sb.append("<tr>");
			sb.append("<td>");
			sb.append(htmlEscape(ciOut.name));
			sb.append("</td>");
			sb.append("<td>");
			sb.append(htmlEscape(ciOut.text));
			sb.append("</td>");
			sb.append("<td>");
			sb.append(ciOut.dateTime.toString());
			sb.append("</td>");
			sb.append("</tr>");
		}
	}
	sb.append("</table>");
	sb.append("</body>");
	sb.append("</html>");
	
	// We set the response length and write the response to the requester.
	String resp = sb.toString();
	response.setContentLength(resp.length());
	response.getWriter().write(resp);
  }
}
