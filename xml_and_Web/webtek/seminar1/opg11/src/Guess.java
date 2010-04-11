/* 
   This servlet illustrates the differences between
   various scope levels i Servlets.

   Open this servlet in two different browser windows
   and reload their contents repeatedly. Explain how
   and why the different numbers change their values.
*/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Random;

public class Guess extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println("<html><head><title>Number guessing game</title></head><body>");
	out.println("<form method=get action=Guess>");
	out.println("Please enter your guess [0;99]eN0: ");
	out.println("<input name=Guess type=text><br>");
	out.println("<input type=submit name=submit value=Guess>");

    HttpSession s = request.getSession();
    Integer correctValue = (Integer)s.getAttribute("correctValue");
    if (correctValue == null) 
	{
	  Random random = new Random();
	  int pick = random.nextInt(99);
      correctValue = new Integer(pick);
      s.setAttribute("correctValue", correctValue);
	}
	
	Integer guessCount = (Integer)s.getAttribute("guessCount");
    if (guessCount == null) 
	{
      guessCount = 0;
      s.setAttribute("guessCount", guessCount);
	}

	String previousGuess = request.getParameter("Guess");
	if (previousGuess != null)
	{
		try
		{
			Integer guess = new Integer(previousGuess);
			int res = guess.compareTo(correctValue);
			if (res > 0)
			{
				out.println("<br><br>Your guess of " + previousGuess + " was too high, please guess again");
				guessCount = guessCount + 1;
				s.setAttribute("guessCount", guessCount);
			}
			else if (res < 0)
			{
				out.println("<br><br>Your guess of " + previousGuess + " was too low, please guess again");
				guessCount = guessCount + 1;
				s.setAttribute("guessCount", guessCount);
			}
			else
			{
				guessCount = guessCount + 1;
				out.println("<br><br>Your guess of " + previousGuess + " was spot on, and you did it in only " + guessCount.toString() + " guesses.<br>Please guess again for a new game");
				Random random = new Random();
				int pick = random.nextInt(99);
				correctValue = new Integer(pick);
				s.setAttribute("correctValue", correctValue);
			    guessCount = 0;
				s.setAttribute("guessCount", guessCount);
			}
		}
		catch (Exception ex)
		{
			out.println("<br><br>Your guess of " + previousGuess + " is not an integer - shame on you, please guess again");
		}
	}
	
	out.println("</form>");
	out.println("</body></html>");
  }
}
