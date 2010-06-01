<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table>
  <tr>
    <th>Value</th><th>Square</th>
  </tr>
  <c:forEach var="x" begin="0" end="10" step="1">
    <tr>
      <td><c:out value="${x}"/></td>
      <td><c:out value="${x * x}"/></td>
    </tr>
  </c:forEach>
</table>
