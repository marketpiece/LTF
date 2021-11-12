
function calculate() { 
    var sum = 0, cupsum = 0, coinsum = 0;     
    var nm = document.getElementsByTagName("input");
    var tsum = document.getElementById("myform:totalsum");
    var cupyur = document.getElementById("myform:cupyur");
    var coin = document.getElementById("myform:coin");
    var banknote = 0;
    for ( var i = 0; i < nm.length - 1; i++) {
    //for(var i in nm) {
      if (nm[i].id != null) {
       //alert(tn.id.substr(7,2));
       if (nm[i].id.substr(7,2) == "nm") {
         banknote = parseInt(nm[i].id.substr(9));
         if (parseFloat(nm[i].value))              
          sum = sum + (parseFloat(nm[i].value) * banknote / 100);          
         if (parseInt(banknote / 100) > 1) {  
           if (parseInt(nm[i].value)) cupsum += (parseFloat(nm[i].value) * banknote / 100); 
            //alert(parseInt(banknote) + "cupsum = " + cupsum);            
         }  
         if ( 2 > parseInt(banknote / 100)) {
          if (parseInt(nm[i].value)) coinsum += (parseFloat(nm[i].value) * banknote / 100);
         }   
        //alert(FormatFloat(sum,2));        
       }  
      } 
    }
    cupyur.value = FormatFloat(cupsum,2); 
    coin.value = FormatFloat(coinsum,2); 
    tsum.value = FormatFloat(sum,2);    
  }
    
  function sm(row) {
    var sum = 0;    
    var banknote = row.id.substr(9);
    var res = document.getElementById("myform:" + "r" + banknote);    
     if (parseFloat(row.value))  
      res.value = FormatFloat(parseFloat(row.value) * banknote / 100, 2);
     //alert(res.value); 
    calculate();     
  }

  function getNumSum(name) {
    var v = document.getElementById("myform:" + name);
    return v.value;    
  }

  function printBL(urole,uname,mun) {
   var tmpl = new Array(32);
   //alert(uname);
   var ri0 = document.getElementById("myform:riPrint:0");            
   var ri1 = document.getElementById("myform:riPrint:1");
    //alert(parent.mpapplet_err);
    if (ri0.checked) { 
	   if (!mpapplet) {
			alert(parent.mpapplet_err);
			return;
	   }
	   /*if (!parent.checkjavapolicy()) { // .java.policy is used for reading permissions no more ... certificate is used
			alert(parent.nopermission_err);
			parent.grantAppletPermission();
			return;
	   } */		
	   if (parent.printer == null)
		  parent.findprinter(parent.document.getElementById("appletparam").value);
	   if (parent.printer != null) { 
	    	tmpl = genTemplateBL(urole,uname,mun);
		    conON();	
		    for(i = 0; i < tmpl.length; i++) {
		       append(tmpl[i] + "\r\n");
		    } 
		    conOFF();
		    print();
	   } else {alert(parent.noprinterdriver_err);}
	} else {
	    //openModalDialog('printdlg.jsf', tmpl, 768, 1024);
		openDialog('banknotelistpreview.jsf', 768, 1024);
	
	}    
  }
  
  function genTemplateBL(role,un,mu) {
   var arr = [];
   var n = "", s = "", n1 = "", s1 = "";
   //alert(mu.trim().length);
   arr[0] = "";
   arr[1] = center("ОПИС",80); //alert(arr[1]);
   switch (mu.toUpperCase()) {
   case 'ПЛОВДИВ':
   		if (role > 0) {
		   	  arr[2] = center("  на предадените банкноти за преброяване на инкасо в",80);
			  arr[3] = center("  ТБ .................................... клон .........................",80);
   		} else {
		   	  arr[2] = center("  на предадените банкноти за преброяване на инкасо",80);
   		} 
	  break;
   default:
	   if (role > 0) { 
		 arr[2] = center("  на предадените банкноти за преброяване на инкасо ",80);
	     arr[3] = "";
	   } else {  
		 arr[2] = center("  на предадените банкноти за преброяване на инкасо в",80);
		 arr[3] = center("  ТБ .................................... клон .........................",80);
	   }    	
	break;
  }
   arr[4] = "";
   arr[5] = "";
   arr[6] = "";
   arr[7] =   lPad("-------------------------------------------------------------------------"," ",80);
   arr[8] =   lPad("|  Брой    |Купюри |      Сума      |  Брой    | Номин. |      Сума      |"," ",80);
   arr[9] =   lPad("| банкноти |       |      /лв./     |  монети  |стойност|      /лв./     |"," ",80);
   arr[10] =  lPad("-------------------------------------------------------------------------"," ",80);
   n = lPad(getNumSum("nm10000")," ",10); s = lPad(parseFloat(getNumSum("r10000")).toFixed(2)," ",16);
   n1 = lPad(getNumSum("nm100")," ",10); s1 = lPad(parseFloat(getNumSum("r100")).toFixed(2)," ",16);   
   arr[11] =  lPad("|" +  n + "|  100  |" +     s    + "|" + n1 + "|      1 |" +   s1    +  "|"," ",80);

   n = lPad(getNumSum("nm5000")," ",10); s = lPad(parseFloat(getNumSum("r5000")).toFixed(2)," ",16);
   n1 = lPad(getNumSum("nm50")," ",10); s1 = lPad(parseFloat(getNumSum("r50")).toFixed(2)," ",16);   
   arr[12] =  lPad("|" +  n + "|   50  |" +     s    + "|" + n1 + "|   0.50 |" +   s1    +  "|"," ",80);

   n = lPad(getNumSum("nm2000")," ",10); s = lPad(parseFloat(getNumSum("r2000")).toFixed(2)," ",16);
   n1 = lPad(getNumSum("nm20")," ",10); s1 = lPad(parseFloat(getNumSum("r20")).toFixed(2)," ",16);   
   arr[13] =  lPad("|" +  n + "|   20  |" +     s    + "|" + n1 + "|   0.20 |" +   s1    +  "|"," ",80);
   
   n = lPad(getNumSum("nm1000")," ",10); s = lPad(parseFloat(getNumSum("r1000")).toFixed(2)," ",16);
   n1 = lPad(getNumSum("nm10")," ",10); s1 = lPad(parseFloat(getNumSum("r10")).toFixed(2)," ",16);   
   arr[14] =  lPad("|" +  n + "|   10  |" +     s    + "|" + n1 + "|   0.10 |" +   s1    +  "|"," ",80);

   n = lPad(getNumSum("nm500")," ",10); s = lPad(parseFloat(getNumSum("r500")).toFixed(2)," ",16);
   n1 = lPad(getNumSum("nm5")," ",10); s1 = lPad(parseFloat(getNumSum("r5")).toFixed(2)," ",16);   
   arr[15] =  lPad("|" +  n + "|    5  |" +     s    + "|" + n1 + "|   0.05 |" +   s1    +  "|"," ",80);
   
   n = lPad(getNumSum("nm200")," ",10); s = lPad(parseFloat(getNumSum("r200")).toFixed(2)," ",16);
   n1 = lPad(getNumSum("nm2")," ",10); s1 = lPad(parseFloat(getNumSum("r2")).toFixed(2)," ",16);   
   arr[16] =  lPad("|" +  n + "|    2  |" +     s    + "|" + n1 + "|   0.02 |" +   s1    +  "|"," ",80);

   n1 = lPad(getNumSum("nm1")," ",10); s1 = lPad(parseFloat(getNumSum("r1")).toFixed(2)," ",16);   
   arr[17] =  lPad("|          |       |                |" + n1 + "|   0.01 |" +   s1    +  "|"," ",80);

   arr[18] =  lPad("-------------------------------------------------------------------------"," ",80);
   arr[19] =  lPad("|                                   |                                    |"," ",80);
   s = lPad(parseFloat(getNumSum("cupyur")).toFixed(2)," ",13); s1 = lPad(parseFloat(getNumSum("coin")).toFixed(2)," ",13);   
   arr[20] =  lPad("|   ОБЩО               " +  s +    "|    ОБЩО               " + s1 +    "|"," ",80);
   arr[21] =  lPad("-------------------------------------------------------------------------"," ",80);
   arr[22] =  "";
   s = lPad(parseFloat(getNumSum("totalsum")).toFixed(2)," ",16);   
   arr[23] =  lPad(" ВСИЧКО ЗА ИНКАСО " + s + " лв."," ",60);
   arr[24] =  "";
   arr[25] =  "";
   arr[26] =  "";
   arr[27] =  lPad("Дата .............             Счетоводител на община .................."," ",80);
   arr[28] =  "";
   arr[29] =  "";
   if (parseInt(role) > parseInt(0)) 
     arr[30] =  lPad("                            Касиер: " + un," ",80);
   else arr[30] =  "";
   arr[31] =  "";
   arr[32] =  lPad("                         Касиер на обсл. банка ......................"," ",80);
   arr[33] =  "";
   arr[34] =  "";
   return arr;   
  }
/*
  function myFunc(e){
    e=e?e:window.event;
    alert(e);
    document.body.onkeydown=function(){
        if(e.keyCode == 13){
            if(e.srcElement.type !="submit")
            e.keyCode = 9;
        }
    }
  }
*/
 // ====== not in use ====== 
  function clearFrm() {	  
	 var nm = document.getElementsByTagName("input");
	 //alert(nm.length); 
	 for (i = 0; i < nm.length - 1; i++) {
      if ((nm[i] != null) && (nm[i].id != null) && (nm[i].id != '')) {
   	     if ((nm[i].id.substr(7) == "totalsum") || (nm[i].id.substr(7) == "cupyur") || (nm[i].id.substr(7) == "coin"))
   	       nm[i].value = '0';
    	 if (nm[i].id.substr(7,2) == "nm")   
          nm[i].value = '';
    	 if (nm[i].id.substr(7,1) == "r")   
          nm[i].value = '0';
    	 if (nm[i].id.substr(7,9) == "riPrint:0")
    	   nm[i].checked = true;	 
    	 if (nm[i].id.substr(7,9) == "riPrint:1")
      	   nm[i].checked = false;	 
     }
	}
  }	   
  
  function checkKey(e) {
    //alert(e.keyCode);
	var targ;
	if (!e) {
	  var e=window.event;
	}
	if (e.target) {
	  targ=e.target;
	} else if (e.srcElement) {
	  targ=e.srcElement;
	}
    //alert(targ.id.substr(7,1));
	if (targ.id.substr(7,1) == "r") {
	  if (navigator.userAgent.indexOf('MSIE') != -1) 
		e.returnValue = false; 
	  else return false;
	}  
	if( (e.keyCode == 8 || e.keyCode == 46 || e.keyCode == 37 || e.keyCode == 39) ||
		(e.keyCode == 9 || e.keyCode == 11) ||	
        (e.keyCode >= 48 && e.keyCode <= 57) || 
        (e.keyCode >= 96 && e.keyCode <= 105) ) {        
		return true; 
    }
    else {
  	  //alert(targ.id);
      if (navigator.userAgent.indexOf('MSIE') != -1)
         e.returnValue = false;
      else return false;
    }
  }
  
  //document.onkeydown = checkKey; 
  