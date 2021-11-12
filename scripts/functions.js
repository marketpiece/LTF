
var deafultWinWidth = 745;
var deafultWinHeight = 500;

function getFormElement(e) {
	if (document.all) {
		return document.all.e;
	} else if (document.getElementById) {
		return document.getElementById(e);
	}
	return null;
}

function openDialog (url, dh, dw) {
	if (dh <= 0) dh = deafultWinHeight;
	if (dw <= 0) dw = deafultWinWidth;
	return window.open(url,'_blank','height=' + dh + ', width=' + dw + ', left=30, top=30, ' +
 	                   'status=yes,menubar=yes,resizable=yes,scrollbars=yes,toolbar=yes,titlebar=yes,location=no,directories=no');
 	                   
}

function openModalDialog (url, arg, dh, dw) {
	if (dh <= 0) dh = deafultWinHeight;
	if (dw <= 0) dw = deafultWinWidth;
	if (!window.showModalDialog) {
	 var wind = window.open(url, '', 'resizable=yes,scrollbars=yes,location=no, width='+dw+',height='+dh);
	     wind.dialogArguments = window;
	     return wind;
	}
	//dh += 34;
	return window.showModalDialog(url, arg, 'dialogWidth:'+dw+'px; dialogHeight:'+dh+'px; center:yes; toolbar:yes; ' + 
	                              'resizable:yes; scrollbars:yes; status:yes; help:yes');
}

function toArray(str, chr) {      
  if (str.length > 1) {       	       
   var arr = new Array();
   var ns="";
   var i=0; j=0;
   while(str.search(chr)>-1) {
	 i=str.search(chr); 
	 arr[j]=str.substr(0,i);			
	 str=str.substr(i+1);
	 //alert(arr[j]);
	 j++;
   } return arr; 	 
 }   
}
   
function isJavaAvailable(){
  return ( navigator.javaEnabled && navigator.javaEnabled() );
}

function appLoaded() {
 if (!document.applets[0].isActive) {
    // in IE: isActive returns an error if the applet IS loaded, 
    // false if not loaded
    // in NS: isActive returns true if loaded, an error if not loaded, 
    // so never reaches the next statement
    alert("IE: Applet could not be loaded");    
  }
}

function changeAL_(v,formid,elementid,al) { // change actionListener      
  //var aa = document.getElementById("btnsave"); doesn't work
  var alr = document.forms[formid].elements[elementid].actionListener;
  alert(alr);
  if (v == 1) {         
    alr="#" + "{" + al + "}";
    alert(alr);        
  } 
  else { 
   alr="#" + "{" + al + "}"; 
   alert(alr);
  }    
} 

function FormatFloat(pFloat, pDp){
    var m = Math.pow(10, pDp);
    return Math.round(pFloat * m) / m;
}

function lPad(s, ch, len) {
 len = (len >= s.length) ? len - s.length : 0;  
 for (i=0; i<len; i++) {
   s=ch + s; 
 }
 return s;
}

function rPad(s, ch, len) {    
 len = (len >= s.length) ? len - s.length : 0;  
 for (i=0; i<len; i++) {
  s=s + ch; 
} 
 return s;
} 

function center(s, len) {
 return rPad(lPad(" "," ",(len - s.length) / 2) + s," ",len); 	
}

function isBrowser_Chrome() {
  if (navigator.userAgent.indexOf('Chrome') != -1) 
	return true;
  else return false; 
}

function isBrowser_Firefox() {
  if (navigator.userAgent.indexOf('Firefox') != -1) 
	return true;
  else return false; 
}

function isBrowser_MSIE() {
  if (navigator.userAgent.indexOf('MSIE') != -1) 
	return true;
  else return false; 
}
//if(event.keyCode==13)

function downloadFile(filePath) {
   //window.location.href = filePath;
   //openDialog(filePath, 400, 600);
   var wnd = window.open(filePath,'','');
   wnd.location.reload();
}	    

function downloadSocFile(filePath) {
  var anchor = document.getElementById("genform:genfileId");
   anchor.href = filePath;
   alert(anchor.href);
   anchor.click();  	
}	