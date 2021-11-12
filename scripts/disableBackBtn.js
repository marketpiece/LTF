function disable() {
if (typeof window.event != 'undefined') // IE
  document.onkeydown = function() // IE
    {
    var t=event.srcElement.type;
    var kc=event.keyCode;
    return ((kc != 8 && kc != 13) || ( t == 'text' &&  kc != 13 ) ||
             (t == 'textarea') || ( t == 'submit' &&  kc == 13))
    }
else
  document.onkeypress = function(e)  // FireFox/Others 
    {
    var t=e.target.type;
    var kc=e.keyCode;
    if ((kc != 8 && kc != 13) || ( t == 'text' &&  kc != 13 ) ||
        (t == 'textarea') || ( t == 'submit' &&  kc == 13))
        return true;
    else {
        return false;
    }
   }

}