  window.onload = function() {
	var theme = getCookieValue("css");
	document.getElementById("sonarCSS").setAttribute("href", "/sonar/stylesheets/blue.css");
	if (theme == undefined || theme == "themes/photon/css/red.css") {
		document.getElementById("sonarCSS").setAttribute("href", "/sonar/stylesheets/red.css");
	}
}

function getCookieValue(c_name) {
	var i,x,y,ARRcookies = document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++) {
		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
		if (x==c_name) {
			return unescape(y);
		}
	}
}
