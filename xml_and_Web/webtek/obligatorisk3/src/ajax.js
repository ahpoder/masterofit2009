var http;
if (navigator.appName == "Microsoft Internet Explorer")
  http = new ActiveXObject("Microsoft.XMLHTTP");
else
  http = new XMLHttpRequest();
  
function sendRequest(action, responseHandler) {
  http.open("GET", action);
  http.onreadystatechange = responseHandler;
  http.send(null);
}
