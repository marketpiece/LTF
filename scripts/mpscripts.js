  //--------- Text print -----------------------
       var mpapplet;  
       try{
    	   if (document.all)
    		 mpapplet = parent.document.mpapplet;
    	   else mpapplet = parent.document.getElementById("mpapplet");
    	   //alert(mpapplet);
    	   
   // ======== Java Applet functions  ==============
    	   function append(value) {
    		 mpapplet.Append(value);   
    	   }      	   
    	   function print() {
      		 mpapplet.Print();   
      	   }
    	   function getprinter() {
    		 return mpapplet.getPrinter();    		 
       	   }  
    	   function setendofdocument(endofpage) {
    	     mpapplet.setEndofDocument(endofpage);
    	   }    	   
    	   function test(){
               alert(mpapplet.ShowTextMessage());
    	   }    	   
   // ================================  	   
   /* The old way by OCX	   
		   function sendtext(value) { // Print text to printer
			 mpapplet.sendtext(value);	
		   }  
		   function newpage() { // Form Feed (new page)
			 mpapplet.newtextdocpage();	
		   }  
		   function opentextdoc(IsCondensed) { // Open text document
			 var res = mpapplet.opennewtextdoc(IsCondensed);	
			 return res;
		   }  
		   function closetextdoc() { // Close text document
			 mpapplet.closetextdoc();	
		   }
		   function getversion() { // current ver.#1.3 20.10.2010
		     var val = mpapplet.Version;
			 return val;
		   }     */	   
	   } catch(e) {
	       //window.alert(e);
	   }
	   
	   function conON(){ // condensed ON
		  return append("\x0F"); 
	   }
	   function conOFF(){ // condensed OFF 
		  return append("\x12");
       }
	   function newpage(){ // Form Feed 
		  return append("\x0C");
       }
	   
       function grantAppletPermission(){
		 var btnjp = document.getElementById("frmjp:btnjp");   
  		 btnjp.click();    	   
       }
       
	/*	char ff = 0x0C;           : 12 Form Feed
		char cp = 0x0F;           : 15 Condensed ON
		char cpoff = 0x12;        : 18 Condensed OFF
		String lf = "\r\n";       : Carriage Return, New Line */		 
	   function zebraPrint(str, chr) {
		  var re = /ff/i; // Проверка за странициране при Декларациите
		  var list;
		  var j = 0;
 		  if (!mpapplet) {
			alert(parent.mpapplet_err);
			return;
 		  }
 		  
 		 /* if (!parent.checkjavapolicy()) { // .java.policy is used for reading permissions no more ... certificate is used
 			alert(parent.nopermission_err);
 			parent.grantAppletPermission();
 			return;
 		  } */ 		
 		  if (parent.printer == null)
 		     parent.findprinter(parent.document.getElementById("appletparam").value);
 		  //alert(printer);
		  if (parent.printer != null) {			  
			  if (str.length > 1) {
				conON();
				if (re.test(str)) { // Declaration's print 
				  var decllist = str.split('ff');
				  for ( var int = 0; int < decllist.length; int++) {
				     list = decllist[int].split(chr);
				     j = 0;
					 for (var i = 0; i < list.length; i++) {
						j++; 
					    if (j > 62) { //paging decl parts
						    newpage();
						    j = 0;
						}  
 					    append(list[i] + "\r\n");  
				     }
					 if (int < (decllist.length - 1))
					  newpage();
				  }	 
				} else { // All others print
				   	list = str.split(chr);
				   	for (var i = 0; i < list.length; i++) {
				   	  j++;	
					 /* if (j > 62) { //paging not decl(all others)
					    newpage();
					    j = 0;
					  }*/  
				   	  append(list[i] + "\r\n");			   	  	
				   	}
				}
				conOFF();

				print();
		     }
		  } else {
			alert(parent.noprinterdriver_err);  
		  }	  
	   }
	   
   //--------------- Text print -----------------------
         
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
			   //textPrint(ta.value,title,'@',isCondensed);
			   zebraPrint(ta.value, '@');
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
			   //textPrint(t,title,'@',isCondensed);
			   zebraPrint(t, '@');
        }
