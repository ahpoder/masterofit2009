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

public class GuessHS extends HttpServlet {
  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
    doPost(request, response);
  }

  public void doPost(HttpServletRequest request,
                    HttpServletResponse response)
      throws IOException, ServletException {
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println("<html><head><title>Number guessing game</title></head><body>");
    // Post is used as the posting has side-effects
	out.println("<form method=post action=GuessHS>");
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

	// TODO this should be stored in a DB, as a server-crash will otherwise 
	// clear the high-score list
	ServletContext c = getServletContext();

	String hs = request.getParameter("HighScore");
	String hsHolder = request.getParameter("HighScoreHolder");
	if (hsHolder != null && hs != null) // if one is null, then the other is too
	{
		c.setAttribute("highScoreHolder", hsHolder);
		c.setAttribute("highScore", new Integer(hs)); // As we set the hs we know it is a valid integer
	}
	
	String previousGuess = request.getParameter("Guess");
	if (previousGuess != null && hsHolder == null) // Only process the guess if it is a guess submit
	{
		try
		{
			// This is an impropper use of exceptions. We should
			// instead test if the integer is valid. Exceptions should
			// only be used for ituations that cannot be predicted, but
			// hey, it works :)
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

				Integer highScore = (Integer)c.getAttribute("highScore");
				String highScoreHolder = (String)c.getAttribute("highScoreHolder");

				if (highScore == null || guessCount.compareTo(highScore) < 0) 
				{
					out.println("<br>");
					if (highScoreHolder != null) 
					{
						out.println("<br>You beat the current high score of " + highScore.toString() + " guesses, which was held by " + highScoreHolder);
					}
					out.println("<br>Please enter your name to take you place among the greats: ");
					out.println("<input name=HighScoreHolder type=text><br>");
					out.println("<input name=HighScore type=hidden value=" + guessCount + ">");
					out.println("<input type=submit name=hs value=Submit>");
				}
				else // HighScoreHolder must be non-null
				{
					out.println("<br><br>Current high score is " + highScore.toString() + " guesses, which is held by " + highScoreHolder);
				}
				
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
