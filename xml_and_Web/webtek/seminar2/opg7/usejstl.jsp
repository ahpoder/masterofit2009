<table>
  <tr>
    <th>Value</th><th>Square</th>
  </tr>
<%
  java.io.PrintWriter oout = response.getWriter();
  for (int i = 0; i < 10; ++i) {
    oout.write("<tr>");
    oout.write("<td>" + x + "</td>");
    oout.write("<td>" + x * x + "</td>");
    oout.write("</tr>");
  }
%>
</table>
