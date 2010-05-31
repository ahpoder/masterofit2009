// Internet Explorer users, look here: http://krijnhoetmer.nl/stuff/html/bug-internet-explorer-submit-button/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class TicTacToe extends HttpServlet {
  public void init() {
    ServletContext c = getServletContext();
    Integer[][] board = new Integer[3][3];
    for (int i = 0; i<3; i++) 
      for (int j = 0; j<3; j++) 
	board[i][j] = new Integer(0);
    c.setAttribute("board", board);
    c.setAttribute("players", new Integer(0));
    c.setAttribute("winner", new Integer(0));
    c.setAttribute("next", new Integer(1));
    c.setAttribute("free", new Integer(9));
  }
  
  public void doPost(HttpServletRequest request, 
		    HttpServletResponse response)
      throws IOException, ServletException {
    doGet(request, response);
  }

  public void doGet(HttpServletRequest request, 
		    HttpServletResponse response)
      throws IOException, ServletException {
    boolean post = request.getMethod().equals("POST");
    ServletContext c = getServletContext();
    Integer[][] board;
    int next;
    int winner;
    int player;
    int free;
    synchronized(c) {
      if (post && request.getParameter("reset")!=null) {
	init();
	for (int p = 1; p<=2; p++) {
	  HttpSession s = (HttpSession)c.getAttribute("player"+p);
	  if (s!=null) {
	    try {
	      s.invalidate();
	    } catch (IllegalStateException e) {}
	  }
	}
	PrintWriter out = response.getWriter();
	out.print("<html><head><title>TicTacToe</title></head><body>");
	out.print("Service is reset!");
	out.print("<p><form action=\"play\" method=\"post\">");
	out.print("<input type=\"submit\" name=\"play\" value=\"Play\"></form>");
	out.print("</body></html>");
	return;
      }
      board = (Integer[][])c.getAttribute("board");
      next = ((Integer)c.getAttribute("next")).intValue();
      winner = ((Integer)c.getAttribute("winner")).intValue();
      free = ((Integer)c.getAttribute("free")).intValue();
      HttpSession ses = request.getSession(false);
      if (ses==null) {
	ses = request.getSession(true);
	ses.setMaxInactiveInterval(60);
	ses.setAttribute("invalid", null);
	int players = ((Integer)c.getAttribute("players")).intValue();
	if (players<2) {
	  player = ++players;
	  c.setAttribute("players", new Integer(players));
	  c.setAttribute("player"+player, ses);
	  ses.setAttribute("player", new Integer(player));	  
	} else{
	  response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Too many users!");
	  return;
	}
      } else {
	player = ((Integer)ses.getAttribute("player")).intValue();
	String move = request.getParameter("move");
	if (post && move!=null && next==player && winner==0) {
	  int i = move.charAt(0)-'0';
	  int j = move.charAt(1)-'0';
	  if (board[i][j]==0) {
	    board[i][j] = new Integer(player);
	    if (next==1)
	      next = 2;
	    else
	      next = 1;
	    c.setAttribute("next", new Integer(next));
	    for (int p = 1; p<=2; p++) {
	      if ((board[0][0]==p && board[0][1]==p && board[0][2]==p) ||
		  (board[1][0]==p && board[1][1]==p && board[1][2]==p) ||
		  (board[2][0]==p && board[2][1]==p && board[2][2]==p) ||
		  (board[0][0]==p && board[1][0]==p && board[2][0]==p) ||
		  (board[0][1]==p && board[1][1]==p && board[2][1]==p) ||
		  (board[0][2]==p && board[1][2]==p && board[2][2]==p) ||
		  (board[0][0]==p && board[1][1]==p && board[2][2]==p) ||
		  (board[2][0]==p && board[1][1]==p && board[0][2]==p)) {
		winner = p;
		c.setAttribute("winner", new Integer(p));
	      }
	    }
	    c.setAttribute("free", new Integer(--free));
	  }
	}
      }
    }
    boolean me = next==player;

    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", 
		       "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    PrintWriter out = response.getWriter();
    out.print("<html><head><title>TicTacToe</title></head>");
    if (me || winner!=0)
      out.print("<body>");
    else
      out.print("<body onLoad=\"setTimeout('window.location.href=window.location.href', 1000)\">");
    out.print("<h1>Player "+player+"</h1>");
    out.print("<form action=\""+response.encodeURL("play")+"\" method=\"post\"><table>");
    for (int i = 0; i<3; i++) {
      out.write("<tr>");
      for (int j = 0; j<3; j++) {
	Integer m = board[i][j];
	String s = i+""+j;
	if (m.intValue()==1)
	  out.write("<td><button style=\"border: none; padding: 0 0 0 0\"  type=\"button\">"+
		    "<img src=\"http://www.brics.dk/ixwt/X.gif\" alt=\"X\"></button></td>");
	else if (m.intValue()==2)
	  out.write("<td><button style=\"border: none; padding: 0 0 0 0\" type=\"button\">"+
		    "<img src=\"http://www.brics.dk/ixwt/O.gif\" alt=\"O\"></button></td>");
	else
	  out.write("<td><button style=\"border: none; padding: 0 0 0 0\" name=\"move\" type=\"submit\" value=\""+s+"\">"+
		    "<img src=\"http://www.brics.dk/ixwt/empty.gif\" alt=\" \"></button></td>");
      }
      out.write("</tr>");
    }
    out.print("</table></form><p>");
    if (winner!=0) {
      if (winner==player) 
	out.print("You win :-)");
      else
	out.print("Opponent wins :-(");
    } else if (free>0) {
      if (me) 
	out.print("Your move!");
      else
	out.print("Waiting for opponent...");
    } else {
      out.print("It's a draw.");
    }
    out.print("<p><form action=\""+response.encodeURL("play")+"\" method=\"post\">");
    out.print("<input type=\"submit\" name=\"reset\" value=\"Reset game\"></form>");
    out.print("</body></html>");
  }
}
