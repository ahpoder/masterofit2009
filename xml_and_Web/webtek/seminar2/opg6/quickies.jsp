<%@ taglib prefix="poll" tagdir="/WEB-INF/tags/poll" %>
<poll:quickpoll title="Quickies" duration="3600">
  <poll:setup>
    The question has been set to "${question}".
  </poll:setup>
  <poll:ask>
    ${question}?
    <select name="vote">
      <option value="yes">yes
      <option value="no">no
    </select>
    <input type="submit" value="vote">
	<br>
	Andre har stemt:
	<table border="1">
	<tr><td>yes</td><td>${yes}</td></tr>
	<tr><td>no</td><td>${no}</td></tr>
	<tr><td>total</td><td>${total}</td></tr>
	</table>
  </poll:ask>
  <poll:vote>
    You have voted ${vote}.
  </poll:vote>
  <poll:results>
    In favor: ${yes}<br>
    Against: ${no}<br>
    Total: ${total}
  </poll:results>
  <poll:timeout>
    Sorry, the polls have closed.
  </poll:timeout>
</poll:quickpoll>
