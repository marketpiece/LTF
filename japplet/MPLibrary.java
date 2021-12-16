package net.is_bg.ltf.japplet;

import java.io.IOException;


/**
 * The Interface MPLibrary.
 */
public interface MPLibrary {

	 // !!!!!!!! commands !!!!!!!!  
                         // Dec.:
	/** The ff. */
 	char ff = 0x0C;      //     : 12 Form Feed
	
	/** The cp. */
	char cp = 0x0F;      //     : 15 Condensed ON
	
	/** The cpoff. */
	char cpoff = 0x12;   //     : 18 Condensed OFF
	
	/** The lf. */
	String lf = "\r\n";  //     :    Carriage Return, New Line 
	//short lf = 0x0D0A;     //      : 13 10
	
	
	/**
	 * Open new text doc.
	 *
	 * @param IsCondensed the is condensed
	 * @return the string
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public String OpenNewTextDoc(boolean IsCondensed) throws IOException;
	/*
		function TFPForm.OpenTextDoc(const title: WideString;
		  IsCondensed: WordBool): WordBool;
		var s      : String;
		begin
		  Result := true;
		  Case IsCondensed Of
		    true: s := #15;
		   false: s := #18;
		  else s := #18;
		  End;
		  If not Assigned(pvPrtSpl) Then
		  Try
		   pvPrtSpl := TPrintToSpool.Create(Printer,title);
		   pvPrtSpl.WriteLn(s);
		  Except
		   Result := false;
		  End;
		end; 
	*/
	/**
	 * Send text.
	 *
	 * @param value the value
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void SendText(String value) throws IOException;
	/*
		procedure TFPForm.SendText(const Value: WideString);
		var s      : String;
		begin
		  If Assigned(pvPrtSpl) Then Begin
		    s := DosCyr(Value);
		    pvPrtSpl.WriteLn(s);
		  End;  
		end; 
	 */
    /**
	 * New text doc page.
	 *
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public void NewTextDocPage() throws IOException;
    /*
		procedure TFPForm.NewTextDocPage;
		begin
		  if Assigned(pvPrtSpl) then
		   pvPrtSpl.WriteLn(#12);
		end;
     */
	/**
     * Close text doc.
     *
     * @throws IOException Signals that an I/O exception has occurred.
     */
    public void CloseTextDoc() throws IOException; 
	/*
		procedure TFPForm.CloseTextDoc;
		begin
		  if Assigned(pvPrtSpl) then begin
		   pvPrtSpl.WriteLn(#18);
		   pvPrtSpl.Free;
		  end;
		end;
	 */
	
}
