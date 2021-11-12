  //--------- Text print -----------------------
       var mp;  
       try{
           //mp = new ActiveXObject("FPax.FPForm");
           
    	   if (document.all)
    		 mp = parent.document.mpapplet;
    	   else mp = parent.document.getElementById("mpapplet");
    	   //alert(mp);
    	   
		   function sendtext(value) { // Print text to printer
			 mp.sendtext(value);	
		   }  
		   function newpage() { // Form Feed (new page)
			 mp.newtextdocpage();	
		   }  
		   function opentextdoc(IsCondensed) { // Open text document
			 var res = mp.opennewtextdoc(IsCondensed);	
			 return res;
		   }  
		   function closetextdoc() { // Close text document
			 mp.closetextdoc();	
		   }
		  /* function getversion() { // current ver.#1.3 20.10.2010
		     var val = mp.Version;
			 return val;
		   }*/	   
	   } catch(e) {
	       //window.alert(e);
	   }
	   
	   function test(){
           alert(mp.ShowTextMessage());
	   }
	   
       function registerOCX(){
         var s = 'За целта запишете инсталациония файл в избрана от вас директория, ' + '\r\n' +
                 'след което затворете Internet explorer и стартирайте .exe файла.';
         //MyAppAlert(s,'Error',null); return;
	     if (!mp) {
		   if (confirm('Компонентата за работа с матричен печат Не е инсталирана.' + '\r\n' +
				       'Необходима е администраторска намеса.' + '\r\n' +  
				       'Желаете ли да свалите инсталационния файл?') == true) { 
			alert(s);  
			var btnocx = document.getElementById("frmocx:btnocx");   
			//alert(isocx.value);
			//btnocx.fireEvent('onclick');
			btnocx.click();
			//installActiveX();
		  }	
		 } else {
		   var ver = getversion();
		   //alert(ver);
		   if ((typeof(ver) == "undefined") || (parseFloat(ver) < 1.3) )  	 
			 if (confirm('Версията на компонентата за работа с матричен печат, която е инсталирана е стара.' + '\r\n' +
				         'Някой от печатите няма да функционират нормално.' + '\r\n' +  
				         'Желаете ли да направите update ?') == true) {
				alert(s);  
				var btnocx = document.getElementById("frmocx:btnocx");   
			    //showDialog('Информация',s,'warning',0);
				//alert(isocx.value);
				btnocx.click();
				//installActiveX(); 
			 }	   
		 }	 
	   }
	   
       function grantAppletPermission(){
		 var btnjp = document.getElementById("frmjp:btnjp");   
  		 btnjp.click();    	   
       }
       
	   function textPrint(str,title,chr,isCondensed) {  //isCondensed: 0 - not Condensed
		 var i = 0;                                     // 1 - Condensed
		 var j = 0;
		 var s = '';
		 var re = /ff/i; // Проверка за странициране при Декларациите
		 var isDecl = Boolean(0);
		 var newdoc = '';

		 //test();
		 if (!mp) {
			alert('Матеус неуспя да инициализира java applet-а.' + '\r\n' +
			      'Най-вероятно нямате инсталирана java virtual machine или' + '\r\n' +
			      'вашия Browser е забранил или не поддържа "Scripting java applets".');
			return;
		 }
		 if (str.length > 1) {
			 newdoc = opentextdoc(Boolean(1));
			 //alert(newdoc);			 
			 if (newdoc.toUpperCase() == 'SUCCESS') {
			    while(str.search(chr)>-1) {
			     j++; // show number of rows	
				 i=str.search(chr); 
				 s = str.substr(0,i);			
			     if (re.test(s) && (j > 2)) { //paging decl
			    	newpage();
			    	s = '';
			    	isDecl = Boolean(1);
			     }
			     if ((!isDecl) && (j > 63)) { //paging not decl
			       newpage();
			       j = 0;
			     }  
			     sendtext(s);
			 	 str=str.substr(i+1);						 
			    }  	 
		      closetextdoc();
			 } else {
			    alert('Липсва разрешение за писане на локалния порт LPT1.' + '\r\n' +
			    	  'За целта запишете инсталациония файл в избрана от вас директория, до която имате' + '\r\n' +
	                  'достъп, след което затворете Browser-a и стартирайте .exe файла.');
			    grantAppletPermission();
			 }	 
		   }            
	   }   

   //--------- Text print -----------------------
         
     	function SetTypePrint(elementID) {
		var ifp = mp.IsFiscalPrinter;							 
		var ri0 = document.getElementById(elementID + ":0");            
		var ri1 = document.getElementById(elementID + ":1"); 	
		//alert( ri0.checked );
	    //alert( ifp );
		  if (ifp > -1){
			  switch (ifp) {
			       case 1: ri0.checked = true; break;
			  	   case 2: ri1.checked = true; break;
				      }
				  }    
		}
		   
		function SaveTypePrint(obj) {
		var v = obj.value;
		var ifp = mp.IsFiscalPrinter;							 
		//alert(v);							
		  if ((ifp > -1) && (v > 0)) {
		    switch(v) {
			case '1': ifp = 1; break;
			case '2': ifp = 2; break;
			} 
		    mp.IsFiscalPrinter = ifp;
		  }
		}

	    function findElementByID(){
	      var frm = document.forms;
	      var re = /txta/i; //new RegExp("txta","i");
	      var els;
	      var nid; 
	      for (i=0; i<frm.length; i++) {
	        var els = frm[i].elements;
	        for (j=0; j<els.length; j++) {
	          nid = els[j].id;
	          //window.alert(nid);
	          if (nid.search(re) > -1) return document.getElementById(nid); 	          
	        }
	      }
	    }
	    
        function PrintDocMatrix(title,isCondensed) {                  
		   	   var ta = document.getElementById('txta');
			   //alert(ta.value);
			   if (document.all && ((typeof(ta)=="undefined") || (ta==null))) 
				 ta = document.all.txta;
			   if ((!document.all) && ((typeof(ta)=="undefined") || (ta==null))) {	 //|| (ta.value=="{...}")		   	 
			     ta = findElementByID(); 
			   }			   
			   isCondensed = (isCondensed=='undefined') || (isNaN(isCondensed)) ? 0 : isCondensed;
			   //alert(isCondensed);
			   //alert(ta.value);
			   textPrint(ta.value,title,'@',isCondensed);
        }
     
        function PrintDocMatrixDecl(title,isCondensed) {                  
		   	   var p2 = /p2/g;
		   	   var p3 = /p3/g;
		   	   var ta = findElementByID();
			   /*if (document.all && ((ta==null) || (typeof(ta)=="undefined"))) 
				 ta = document.all.txta; */
			   var t = ta.value;
			   t = t.replace(p2, ""); 
			   t = t.replace(p3, ""); 
			   isCondensed = (isCondensed=='undefined') || (isNaN(isCondensed)) ? 0 : isCondensed;
			   textPrint(t,title,'@',isCondensed);
        }
    // not used     
        function createAXObject(divID) {
        	var myObject = document.createElement('object');
        	var div = document.getElementById(divID);
        	div.appendChild(myObject);
        	myObject.id = "mp"; 
        	myObject.width = "200";
        	myObject.height = "100";
        	//myObject.classid= "clsid:D2C64740-8A2A-4597-B553-A9B6BC1AC54F";
        	myObject.classid = "clsid:2ED7D10D-B2E3-40B4-9794-EF06AAD82A9";
        	//myObject.URL = "example.wmv";
        	myObject.uiMode = "none" ;        	
        	myObject.onclick = function(){
        	   document.alert(myObject.Version);	
        	};
        }