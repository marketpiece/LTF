function restartTimer(){
	clearTimeout(t);
	timer_is_on=false;
	startTimer();
}

function startTimer(){
	//alert(timer_is_on);
	
	if (!timer_is_on) {
		totalTime = document.getElementById('timer').innerHTML;
		timer_is_on=true;
  	}

	var myTimer = document.getElementById('timer');
	var myTimer1 = document.getElementById('timeoutForm:timer1');
	currTime = myTimer.innerHTML;
	currTime = currTime - 1;
	myTimer.innerHTML = currTime;
	

	var myTimerTime = document.getElementById('timerTime');
	myTimerTime.innerHTML = secondsToTime(currTime);

  	var percent = (currTime/totalTime)*100
	var timeSlider = document.getElementById('timeSlider');
	timeSlider.style.width = percent + "%";
	
	if (currTime < 60) {
		timeSlider.style.backgroundColor="#ff0000"; 
	}
	
	if (currTime == 60) {
		Richfaces.showModalPanel('timeoutAlert');
	}
	
	if (currTime < 60) {
		myTimer1.innerHTML = currTime;
	}
	
	if (currTime == 1) {
		Richfaces.hideModalPanel('timeoutAlert');
	}
	
	if (myTimer.innerHTML == 0) {
		clearTimeout(t);
		timer_is_on=false;
	} else {
		t = setTimeout("startTimer()", 1000);
	}	
}

function secondsToTime(secs) {
    var hours = '0' + Math.floor(secs / (60 * 60));

    var divisor_for_minutes = secs % (60 * 60);
    var minutes = '0' + Math.floor(divisor_for_minutes / 60);
 
    var divisor_for_seconds = divisor_for_minutes % 60;
    var seconds = '0' + Math.ceil(divisor_for_seconds);

    hours = hours.substring(hours.length - 2);
    minutes = minutes.substring(minutes.length - 2);
    seconds = seconds.substring(seconds.length - 2);
    
    var obj = hours + ':' + minutes + ':' + seconds;
    return obj;
}

/** <pre> позволява задаване на дължината на числото и дали да има - onkeyPress use, <br>
     Параметри: fid - id на полето; e=event; <br> 
                first - броя на числата преди дес.точка; <br> 
                second - броя на числата след дес.точка; <br>  
                dec - стойност 1 = има точка,  тойност 2 = няма точка. </pre> */
function numbersonlydigit(fid,e,first, second,dec)
{
	var tochka=0;
	var key;
	var keychar;
	
	if (window.event)
	{
		key = window.event.keyCode;
	}else if (e){
		key = e.which;
	}else{
		return true;
	}
	keychar = String.fromCharCode(key);
	// control keys
	if ((key==null) || (key==0) || (key==8) || (key==9) || (key==13) || (key==27) )
	{
		return true;
	// numbers
	}else if ((("0123456789").indexOf(keychar) > -1)){	
		 
		var str=document.getElementById(fid).value;
		if(str.indexOf(".")>-1){
			// alert("hereeee");
		ar=str.split(".");
		if(ar[0].length>first || ar[1].length>=second){return false;}
		// if(ar[0].length<first && ar[1].length=second){return false;}
		} else if(str.length<first){
		return true;}else {return false;}
	// decimal point jump
	}else if (keychar == "."){
		if( document.getElementById(fid).value.indexOf('.')>-1 || document.getElementById(fid).value.length==0){
			return false;
		}else{
			if(dec!='2'){
		return true;}else return false;
		}
	}else{
		return false;
	}
}

// e = event , symbols = string with symbols we don't want to display
function dontDisplaySymbols(e, symbols){
	var key;
	var keychar;
	if (window.event)
	{
		key = window.event.keyCode;
	}else if (e){
		key = e.which;
	}else{
		return true;
	}
	keychar = String.fromCharCode(key);
	
	// alert(keychar);
	
	// control keys
	if ((key==null) || (key==0) || (key==8) || (key==9) || (key==13) || (key==27) )
	{
		return true;
	// check symbol entered if it' s among those not to display
	}else if(symbols.indexOf(keychar) > -1){
		return false;
	}
	return true;
	
}

function displaySymbols(e, symbols){
	var code;
	var keychar;
	//var re = /[A-Z0-9]/gi;
	if (!e) var e = window.event;
	if (e.keyCode) { code = e.keyCode; }
	else if (e.which) {code = e.which;}
	keychar = String.fromCharCode(code);
	if (symbols.indexOf(keychar) > -1) {		
		return true;		
	} else {
		return false;
	}	
}

function ibanValidation(val){ // not in use
	var re = /[A-Z0-9]/g;
	var re1 = /[A-Z]/g;
	//var val = document.getElementById('frmiban:iban').value;
	var iban;
	var rem;
	if (val.length != 22) {
		alert('Невалидна дължина на IBAN!');
		return false;
	}
	if (val.toUpperCase().test(re)) {
	   alert('Невалиден символ в IBAN!');
	   return false;
	}
	iban = val.substr(0,4);
	iban = val.slice(4).concat(iban);
	var code;
	for ( var int = 0; int < iban.length; int++) {
		if (iban[int].test(re1)) {
		 	code = iban.charCodeAt(int) - 55;
		 	iban.replace(iban[int], code);
		}
	}
	rem = parseInt(iban) % 97;
	return rem == 1;
} 

function rzpSum(index) {
	var rzpObject = obtainElementById1('input', index - 1, 'rzpObject');
	var rzpCeller = obtainElementById1('input', index - 1, 'rzpCeller');
	var rzpAttic = obtainElementById1('input', index - 1, 'rzpAttic');
	var totalArea = obtainElementById1('input', index - 1, 'totalArea');
	
	if (!IsNumeric(rzpObject.value)) {
		if (isNaN(rzpObject.value)) rzpObject.value = 0;
		else rzpObject.value = parseFloat(rzpObject.value);
	}
	if (!IsNumeric(rzpCeller.value)) {
		if (isNaN(rzpCeller.value)) rzpCeller.value = 0;
		else rzpCeller.value = parseFloat(rzpCeller.value);
	}
	if (!IsNumeric(rzpAttic.value)) {
		if (isNaN(rzpAttic.value)) rzpAttic.value = 0;
		else rzpAttic.value = parseFloat(rzpAttic.value);
	}
	
	var tot = Math.round(100 * (parseFloat(rzpObject.value) + parseFloat(rzpCeller.value) + parseFloat(rzpAttic.value))) / 100;
	
	totalArea.value = tot.toFixed(2);
	
	//rzpObject.value = (parseFloat(rzpObject.value)).toFixed(2);
	//rzpCeller.value = (parseFloat(rzpCeller.value)).toFixed(2);
	//rzpAttic.value = (parseFloat(rzpAttic.value)).toFixed(2);
}

function IsNumeric(strString)
// check for valid numeric strings
{
var strValidChars = "0123456789.-";
var strChar;
var blnResult = true;

if (strString.length == 0) return false;

// test strString consists of valid characters listed above
for (i = 0; i < strString.length && blnResult == true; i++)
   {
   strChar = strString.charAt(i);
   if (strValidChars.indexOf(strChar) == -1)
      {
      blnResult = false;
      }
   }
return blnResult;
}

function obtainElementById(kind, srcId){
	var objs = new Array();
	var objects = document.getElementsByTagName(kind);
//alert(objects.length);
	for (var i=0; i < objects.length; i++){
		var obj = objects[i];
		var ids = (obj.id).split(':');
		var last = ids[ids.length - 1];
		if (last.substring(0, srcId.length) == srcId) {
//alert(last.substring(0, srcId.length) + '|' + srcId);			
			objs[objs.length] = obj;
		}
	}
	return objs;
}

function obtainElementById1(kind, index, srcId){
	var objs = new Array();
	var objects = document.getElementsByTagName(kind);
	for (var i=0; i < objects.length; i++){
		var obj = objects[i];
		var ids = (obj.id).split(':');
		var last = ids[ids.length - 2] + ':' + ids[ids.length - 1];
		if (last == index + ':' + srcId){
			return obj;
		}
	}
	return null;
}

function getScreenWidht() {
	var x;
	if (self.innerHeight) x = self.innerWidth;  // all except Explorer
	else if (document.documentElement && document.documentElement.clientHeight) x = document.documentElement.clientWidth; // Explorer
																															// 6
																															// Strict
																															// Mode
	else if (document.body) x = document.body.clientWidth; // other Explorers
	return x;
}

function getScreenHeight() {
	var y;
	if (self.innerHeight) x = y = self.innerHeight; // all except Explorer
	else if (document.documentElement && document.documentElement.clientHeight) y = document.documentElement.clientHeight; // Explorer
																															// 6
																															// Strict
																															// Mode
	else if (document.body) y = document.body.clientHeight; // other Explorers
	return y;
}

function ajaxIndicatorStart() {
	var ajaxIndicator = document.getElementById('ajaxIndicator');
	centerAjaxIndicator(ajaxIndicator);
	ajaxIndicator.style.display = 'block';
}

function ajaxIndicatorStop() {
	// if (ajaxIndicator.style.display == 'none')
	// setTimeout("ajaxIndicatorStop();",10);
	var ajaxIndicator = document.getElementById('ajaxIndicator');
	ajaxIndicator.style.display = 'none';
}

function centerAjaxIndicator(ajaxIndicator) {
	var x = getScreenWidht();
	var y = getScreenHeight(); 

	var picX = ajaxIndicator.style.width;
	var picY = ajaxIndicator.style.height;

	var picLeft = parseInt((x - parseInt(picX))/2);
	var picTop = parseInt((y - parseInt(picY))/2);

	document.getElementById('ajaxIndicator').style.left = picLeft + "px";
	document.getElementById('ajaxIndicator').style.top = picTop + "px";
}

function errMsg() {
	var modalMsgs = obtainElementById('span', 'modalMsg');
	for (var i=0; i < modalMsgs.length; i++){
		if ((modalMsgs[i].innerHTML).length > 2) {
			Richfaces.showModalPanel('msgModal');
			return true;
		}	
	}
	return false;
}
	
function setFocus(elemetId) {
   if (document.getElementById(elemetId))	
		// alert(elemetId);
		// $(elemetId).focus()
	document.getElementById(elemetId).focus();
	// }
}

function rowColorize(row) {
	var rows = document.getElementById(row.parentNode.id).getElementsByTagName('tr');
	for (var i = 0; i < rows.length; i++) {
		if (i % 2) rows[i].style.backgroundColor='#FFFFE1';
		else rows[i].style.backgroundColor='#FFFFFF';
    }
    row.style.backgroundColor='#FFc080';
    row.style.color='#FFFFFF';
}

function freeDay(element) {
	if (element.checked) element.parentNode.className = 'calendarFree';
	else element.parentNode.className = 'calendarWorking';
}

function checkPDF() {
    var isInstalled = false;
	var version = null;
   	if (window.ActiveXObject) {
	  var control = null;
	  try {
	    // version 8 & 9
	    control = new ActiveXObject('AcroPDF.dll');
	  } catch (e) {
	    // window.alert(e);
      }
	  if (!control)	  
		  try {
		    // version 7
		    control = new ActiveXObject('AcroPDF.PDF');
		  } catch (e) {
		    // window.alert(e);
	      }	      
	  if (!control)	
	    try {
	    // version 6
	      control = new ActiveXObject('PDF.PdfCtrl');
	    } catch (e) {
	     return false;
	    }	  
	  if (control) {	
	   return true ;
	  } else {
	   return false ;
	  }
	}
}


function progressPositioning() {
	var x = getScreenWidht();
	var y = getScreenHeight(); 
	var obj = document.getElementById('progressForm');
	var panel = document.getElementById('panelPr');
	var offset =  getScrollXY(); 
	var winSize = getWinSize();
	var elementTopLeft = getTopLeft(obj);
	
// panel.style.top = obj.offsetWidth + obj.offsetWidth + obj.offsetWidth;
	
	alert(elementTopLeft[0] + "/" + elementTopLeft[1]);

// alert(obj.offsetWidth + "/" + obj.offsetHeight);
// alert(offset[0] + "/" + offset[1]);
// alert(winSize[0] + "/" + winSize[1]);
}

function getScrollXY() {
	  var scrOfX = 0, scrOfY = 0;
	  if( typeof( window.pageYOffset ) == 'number' ) {
	    // Netscape compliant
	    scrOfY = window.pageYOffset;
	    scrOfX = window.pageXOffset;
	  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
	    // DOM compliant
	    scrOfY = document.body.scrollTop;
	    scrOfX = document.body.scrollLeft;
	  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
	    // IE6 standards compliant mode
	    scrOfY = document.documentElement.scrollTop;
	    scrOfX = document.documentElement.scrollLeft;
	  }
	  return [ scrOfX, scrOfY ];
	}

function getWinSize() {
	  var myWidth = 0, myHeight = 0;
	  if( typeof( window.innerWidth ) == 'number' ) {
	    // Non-IE
	    myWidth = window.innerWidth;
	    myHeight = window.innerHeight;
	  } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
	    // IE 6+ in 'standards compliant mode'
	    myWidth = document.documentElement.clientWidth;
	    myHeight = document.documentElement.clientHeight;
	  } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
	    // IE 4 compatible
	    myWidth = document.body.clientWidth;
	    myHeight = document.body.clientHeight;
	  }
	  
	  return [ myWidth, myHeight ];
	}

function GetTopLeft(elm){
	var x, y = 0;
	// set x to elm’s offsetLeft
	x = elm.offsetLeft;
	// set y to elm’s offsetTop
	y = elm.offsetTop;
	// set elm to its offsetParent
	elm = elm.offsetParent;
	
	// use while loop to check if elm is null
	// if not then add current elm’s offsetLeft to x
	// offsetTop to y and set elm to its offsetParent
	while(elm != null){
		x = parseInt(x) + parseInt(elm.offsetLeft);
		y = parseInt(y) + parseInt(elm.offsetTop);
		elm = elm.offsetParent;
	}
	
	// here is interesting thing
	// it return Object with two properties
	// Top and Left
	
	return [ y, x ];

}

function updateErr(errNo, errName) {
	document.getElementById('modpanelPanelPos:errNo').value = errNo;
	document.getElementById('modpanelPanelPos:errName').value = errName;
	if(errNo == '99')
		document.getElementById('modpanelPanelPos:timeoutButton').click();
	else
		document.getElementById('modpanelPanelPos:payButton').click();
	//document.getElementById('modpanelPanelPos:panelPOS').style = '';
	//document.getElementById('modpanelPanelPos:transactionInfo').style = '';*/
}
function updateTransactionInfo(ecrNo, terminalId, financePeriod, ac, rrn, sum, cash, cardholderId) {
	document.getElementById('modpanelPanelPos:terminalId').value = terminalId;
	document.getElementById('modpanelPanelPos:ac').value = ac;
	document.getElementById('modpanelPanelPos:rrn').value = rrn;
	document.getElementById('modpanelPanelPos:fPeriod').value = financePeriod;
	
	document.getElementById('modpanelPanelPos:errNo').value = '';
	document.getElementById('modpanelPanelPos:errName').value = '';
	
	document.getElementById('modpanelPanelPos:payButton').click();
}
