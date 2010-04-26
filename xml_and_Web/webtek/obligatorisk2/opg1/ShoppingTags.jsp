<%@ taglib prefix="s" tagdir="/WEB-INF/tags/shopping" %>
<%@ taglib prefix="u" tagdir="/WEB-INF/tags/urls" %>
<html>
  <head>
    <title>Widget Inc.</title>
  </head>
  <body>
    <h1>Widget Inc. Online Shopping</h1>
    <s:cart>
      <s:add item="${param.item}" amount="${param.amount}"/>
      <u:url target="##self">
        <form method=post action="${url}">
          Item: <input type=text name=item size=20>
          Amount: <input type=text name=amount size=5>
          <input type=submit name=submit value="Add to shopping cart">
        </form>
      </u:url>
      <p>
      <s:process>
        <s:empty>Your shopping cart is empty.</s:empty>
        <s:nonempty>
          Your shopping cart now contains:<p>
          <table border=1><tr><th>Item<th>Amount 
          <s:loop>
            <tr><td>${item}<td>${amount}
          </s:loop>
          </table><p>
          <u:url target="buy">
            <form method=post action="${url}">
              <input type=submit name=submit value="Proceed to cashier">
            </form>
          </u:url>
        </s:nonempty>
      </s:process>
    </s:cart>
  </body>
</html>
