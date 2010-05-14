import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;

public class ChatServer extends HttpServlet {
  private class ChatItem {
	public ChatItem(String name, String text) {
		this.name = name;
		this.text = text;
		this.dateTime = new Date();
	}
	
	public String name;
	public String text;
	public Date dateTime;
  }
  
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
    ServletContext c = getServletContext();
	
    String chat = request.getParameter("chat");
    String name = request.getParameter("name");
    String text = request.getParameter("text");

	StringBuilder sb = new StringBuilder();
	sb.append("<html>");
	sb.append("<head>");
	sb.append("<title>Chat response</title>");
	sb.append("</head>");
	sb.append("<body>>");
	sb.append("<table>");

	synchronized (this) {
		Hashtable<String,ArrayList<ChatItem> > n = (Hashtable<String,ArrayList<ChatItem> >)c.getAttribute("chats");
		if (n == null) {
			n = new Hashtable<String,ArrayList<ChatItem> >();
			c.setAttribute("chats", n);
		}
		
		if (!n.contains(chat)) {
			n.put(chat, new ArrayList<ChatItem>());
		}
		ArrayList<ChatItem> chatList = n.get(chat);
		
		if (name != null) { // If it is not null then it must be valid
			ChatItem ci = new ChatItem(name, text);
			chatList.add(0, ci); // Pust it to the front
		}
		
		// Add to result
		for (Iterator<ChatItem> i = chatList.iterator(); i.hasNext(); ) {
			ChatItem ciOut = i.next();
			sb.append("<tr>");
			sb.append("<td>");
			sb.append(ciOut.name);
			sb.append("</td>");
			sb.append("<td>");
			sb.append(ciOut.text);
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
	
	String resp = sb.toString();
	response.setContentLength(resp.length());
	response.getWriter().write(resp);
  }
}
