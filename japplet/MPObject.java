package net.is_bg.ltf.japplet;

import java.awt.FlowLayout;
import java.awt.TextArea;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import net.is_bg.ltf.japplet.jzebra.PrintApplet;


/**
 * The Class MPObject.
 *
 * @author i.kamov
 * <p> MPObject клас, който управлява матричен печат като изпраща необходимите команди.
 */
public class MPObject extends PrintApplet implements MPLibrary, IZEBRA {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 5502435590589323776L;
	
	/** The fp. */
	private FileOutputStream fp = null;
	
	/** The text box. */
	private TextArea textBox;

	/**
	 * Instantiates a new mP object.
	 */
	public MPObject() {
		// TODO Auto-generated constructor stub
	}
    
    /* (non-Javadoc)
     * @see net.is_bg.ltf.japplet.IZEBRA#Append(java.lang.String)
     */
	public void Append(String s) throws UnsupportedEncodingException, IOException {
	  super.append(DosCyr(s));	
	}
	
	/* (non-Javadoc)
	 * @see net.is_bg.ltf.japplet.IZEBRA#Print()
	 */
	public void Print() {
	  super.print();
	}
    
    /**
     * FindPrinter намира принтер от принтер листа на windows.
     *
     * @param printer the printer
     * @return the string
     * @throws IOException Signals that an I/O exception has occurred.
     */
	public String FindPrinter(String printer) throws IOException {
	  String pn = "";	
	  super.findPrinter(printer);	  
	  try {
		 pn = super.getPrinter();
		 return pn;
	} catch (Exception e) {
		// TODO: handle exception
		System.out.println(e.getMessage());	
	}
	  return null;
	}   
	
	/**
	 * Thread start.
	 */
	public void threadStart(){
        try {
        	thisThread = new Thread(this);
	        thisThread.start();		
        } catch(Exception e){
        	e.getMessage();
        }
	}
	
	/**
	 * Checks if is thread started.
	 *
	 * @return true, if is thread started
	 */
	public boolean isThreadStarted(){
		try {
		  if (thisThread.isAlive())
		   return true;
		} catch (Exception e) {
			System.out.println(e.getMessage());			
		}
		return false;		
	}
	
	/**
	 * Check print job access.
	 *
	 * @return true, if successful
	 */
	public boolean checkPrintJobAccess(){
		SecurityManager sm = System.getSecurityManager();
	    try {
	    	sm.checkPrintJobAccess();
	    	System.out.println("checkPrintJobAccess = true");
	    	return true;
		} catch (SecurityException e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
		}
		return false;
    }
	
	/**
	 * Check java vm version.
	 *
	 * @return true, if successful
	 */
	public boolean checkJavaVMVersion(){
	   String jh = "";
	   try{	
		jh = System.getProperty("java.vm.version");
	   }catch(SecurityException e){
  		  System.out.println("getProperty java.vm.version exception: " + e.getMessage());		   
	   }	
		if (jh == null || jh.equals("")) {
		  return false;	 
		}
		System.out.println("JAVA_VM_VERSION: " + jh);		
		return true;
	}
	
	/**
	 * Check java policy exists.
	 *
	 * @return true, if successful
	 */
	public boolean checkJavaPolicyExists(){
		String uh = "";
	  try{ 
	    uh = System.getProperty("user.home");
	  }catch(SecurityException e){
		System.out.println("getProperty exception: " + e.getMessage());
	  }
	  try{		  
	   File f = new File(uh + "\\.java.policy");
	   boolean exists = f.exists();
	   if (exists) 
		 return true;
	  } catch(Exception e) {
		  System.out.println("File exception: " + e.getMessage());  
	  }
	   
	   return false;
	}

	/**
	 * Prints the code page.
	 */
	public void PrintCodePage(){
		byte b[] = new byte[32];
		int j = 0;
	    //System.out.println("============= Code Page Print ============");
		for (int i = 128; i < 256; i++) {
		  if (j == 7) {
			 super.append(b);
			 super.append(lf);
			 j = 0;
		     //System.out.println(i + " = " + (char)b[j]);
		  }
		  b[j] = (byte)i;
		  j++;
		}
		super.print();
	    //System.out.println("============= Code Page Done ============");
	}
//	======= Direct writing to LPT1 =========
	
	/* (non-Javadoc)
 * @see net.is_bg.ltf.japplet.MPLibrary#CloseTextDoc()
 */
public void CloseTextDoc() throws IOException {
		if (fp != null){
		 //fp.write(cpoff);
		 fp.flush();
		 fp.close();
	   }	 
	}
	
	/* (non-Javadoc)
	 * @see net.is_bg.ltf.japplet.MPLibrary#NewTextDocPage()
	 */
	public void NewTextDocPage() throws IOException {
		if (fp != null)
		 fp.write(ff);  		
	}
     
	/* (non-Javadoc)
	 * @see net.is_bg.ltf.japplet.MPLibrary#OpenNewTextDoc(boolean)
	 */
	public String OpenNewTextDoc(boolean IsCondensed) throws IOException {
	   try {		
	 	File f = new File("LPT1");
	 	fp = new FileOutputStream(f);
	 	//fp = new OutputStreamWriter(fs);
	   } catch (Exception e) {
		 return e.getMessage();		 
	   }	
	   
       appendText("OpenNewTextDoc: IsCondensed = " + String.valueOf(IsCondensed));
	   if (fp != null)
		if (IsCondensed) {   
		  fp.write(cp);
		} else {fp.write(cpoff);}
	   
		return "SUCCESS";
	}

	/* (non-Javadoc)
	 * @see net.is_bg.ltf.japplet.MPLibrary#SendText(java.lang.String)
	 */
	public void SendText(String value) throws IOException {
	    appendText("Send Text:");
		if (fp != null) {
		 if (value == null) return;
		 fp.write(lf.getBytes());
		 if (!value.equals(""))
		  fp.write(DosCyr(value));
		 appendText(value);
	   }	 
	}

	/**
	 * Dos cyr.
	 *
	 * @param s the s
	 * @return the byte[]
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	private byte[] DosCyr(String s) throws IOException {
		String res = s;
		int code = 0;
		
		if (s.equals(null) || s.length() < 1) return null;
		byte b[] = new byte[s.length()];		
		
		for (int i = 0; i < res.length(); i++) {		  	
		  /*if (res.codePointAt(i) == 0x428)
		   code = 0xF6; 	  
		  else*/ 
		  if (res.codePointAt(i) > 128 )
		   code = res.codePointAt(i)-912;
 	      else code = res.codePointAt(i); 
		  if (code == 185) b[i] = 'N'; //№
 	      b[i] = (byte)code;
		}
		return b;
	}
	
	/*
	function DosCyr ( InS : String ) : String;
	var
	 i,l : Integer;
	begin
	  Result := InS;  l := Length(InS);
	  If l < 1  Then  Exit;
	  For i := 1 to l Do  Begin
	      If Ord(InS[i]) = 185    Then InS[i] := 'N';  // 185(¹) --> 78(N)
	      If Ord(InS[i]) > 255-64 Then InS[i] := Chr(Ord(InS[i])-64);
	  End;
	  Result := InS;
	end;
 */

   /**
	 * Show text message.
	 *
	 * @return the string
	 */
	public String ShowTextMessage() {
	   return "This is test message !!!";
   }
   
   /* (non-Javadoc)
    * @see net.is_bg.ltf.japplet.jzebra.PrintApplet#init()
    */
   @Override
   public void init(){
	   System.out.println("MPObject.init");
       super.init();
       super.setEncoding("Cp866");
       setLayout(new FlowLayout());
       textBox = new TextArea(5,40);
       add(textBox);
   }
   
   /**
    * Append text.
    *
    * @param text the text
    */
   public void appendText(String text){
    textBox.append(text + "\r\n");
   }

}
