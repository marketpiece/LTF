   mpapplet_err = 'Матеус, не успя да инициализира java applet-а, необходим за матричен печат.' + '\r\n' +
		         'Най-вероятно нямате инсталирана java virtual machine или' + '\r\n' +
		         'вашия Browser е забранил, или не поддържа "Scripting java applets".';
   nopermission_err = 'Липсват права за ползване на принтер услугите.' + '\r\n' +
	  			      'За целта, ще започне сваляне на файл "jpsetup.exe", след като потвърдите това съобщение,' + '\r\n' +
	  			      'като същия запишете в избрана от вас директория, до която имате достъп,' + '\r\n' + 
	  			      'след което затворете Browser-a и стартирайте .exe файла.';
   noprinterdriver_err = 'Матеус, не успя да намери конфигуриран принтер с име "mateus"' + '\r\n' +
	                     '(Default driver "Generic / Text Only").' + '\r\n' + 
   						 'Моля, обърнете се към системния администратор.';
   nojvm_err = 'Матеус, не успя да отркие инсталирана Java Virtual Machine.';
   var mp;
   var printer = null;
   
    try {
	    if (document.all)
			 mp = document.mpapplet;
	    else mp = document.getElementById("mpapplet");
		
		function grantAppletPermission(){
		  var btnjp = document.getElementById("frmjp:btnjp");   
		      btnjp.click();    	   
	    }
		
 	    function findprinter(pn){
 	      this.printer = mp.FindPrinter(pn);	
  		  return(this.printer);  
  	    }

        function checkfindprinter(){
          findprinter(document.getElementById("appletparam").value);
          if (printer == null) 
    		alert(noprinterdriver_err); 
          //alert(printer);          
        }
 	    
 	    function checkjavapolicy(){
		  var res = mp.checkJavaPolicyExists();
		  return res;
		}
		
 	    function checkjavavmversion(){
 	      var res = mp.checkJavaVMVersion();
 	      return res;
 	    }
 	    
		function checkprintjobsaccess(){
		  var res = mp.checkPrintJobAccess();
		  return res;
		}
		
		function threadstarted(){
		  return mp.isThreadStarted();	
		}
	} catch (e) {
		// TODO: handle exception
	}
	
	function startAppletThread() {
	   try {
		   if (!mp) {
			  alert(mpapplet_err);
			  return false;
		   }
		 /*  if (!checkjavapolicy()) {  // .java.policy is used for reading permissions no more ... certificate is used
			  alert(nopermission_err);
			  grantAppletPermission();
			  return false;
		   } */
	 	   if (!threadstarted())
	 		  mp.threadStart();
	 	   return true;
		} catch (e) {
			// TODO: handle exception
		}
		return false;
	} 

	
	if (startAppletThread()) {
		//alert(document.getElementById("appletparam").value);
		//window.setTimeout("checkfindprinter();", 5000);
		//window.setTimeout("mp.PrintCodePage();", 10000);
	} 	

