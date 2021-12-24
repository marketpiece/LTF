package net.is_bg.ltf.nap;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;

import net.is_bg.ltf.db.common.SelectSqlStatement;
import net.is_bg.ltf.util.FileUtil;


/**
 * The Class FileSelectStatement.
 */
public class FileSelectStatement extends SelectSqlStatement implements IFileWriteLibrary{
    
	/** The filename. */
	protected String filename;
	
	/** The result. */
	private boolean result;
	
	/** The municipality id. */
	protected long municipalityId;
	
	/** The header. */
	protected String header;
	
	/** The author idn. */
	protected final String authorIDN = "8316417910074"; 
	
	/** The nap file. */
	protected NapFileHistory napFile;
	
	/**
	 * Instantiates a new file select statement.
	 *
	 * @param filename the filename
	 * @param municipalityid the municipalityid
	 * @param header the header
	 * @param napFile the nap file
	 */
	public FileSelectStatement(String filename, long municipalityid, String header, NapFileHistory napFile){
	  this.filename = filename;	
	  this.municipalityId = municipalityid;
	  this.header = header;
	  this.napFile = napFile;
	  super.setResultSetType(ResultSet.TYPE_SCROLL_SENSITIVE);
	  super.setResultSetConcurrency(ResultSet.CONCUR_READ_ONLY);	  
	}
	
	/**
	 * Gets the sql header.
	 *
	 * @return the sql header
	 */
	protected String getSqlHeader(){
		return 	"  select case when max(nap.extractdate) is not null then to_char(max(nap.extractdate),'yyyymmdd')\n"+
				"         else '        ' end ||          \n"+
				"         case when current_date is not null then ',' end ||         \n"+
				"         to_char(current_date,'yyyymmdd') head,\n"+
				"         max(m.old_code)||to_char(current_date,'mm')||'.G'||to_char(current_date,'yy') fileName\n"+
				"   from municipality m \n"+
				"   left join napfilehistory nap on nap.municipality_id = m.municipality_id \n"+
				"                               and substr(nap.filename,1,2) = '"+ this.filename +"' \n"+
				"  where m.municipality_id = " + this.municipalityId;
	}
	
	/* (non-Javadoc)
	 * @see net.is_bg.ltf.db.common.SqlStatement#getSqlString()
	 */
	@Override
	protected String getSqlString() {
		// TODO Auto-generated method stub
		return null;
	}

	  // >>>>>>>>>>>> Create Text File 	
	/* (non-Javadoc)
  	 * @see net.is_bg.ltf.nap.IFileWriteLibrary#createOutTextFile(java.lang.String, java.lang.String)
  	 */
  	public OutputStreamWriter createOutTextFile(String filename, String charsetName) throws FileNotFoundException, UnsupportedEncodingException{
		String path = "";
		path = FileUtil.getRealPath(NapBean.getNapFilePath());
		File f = new File(path, filename);
    	FileOutputStream os = new FileOutputStream(f);
    	OutputStreamWriter osw = new OutputStreamWriter(os, charsetName);    	
    	return osw;
	}
	
	/* (non-Javadoc)
	 * @see net.is_bg.ltf.nap.IFileWriteLibrary#writeOutTextFile(java.io.OutputStreamWriter, java.lang.String)
	 */
	public void writeOutTextFile(OutputStreamWriter w, String s) {
		try {
			w.write(s); 
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/* (non-Javadoc)
	 * @see net.is_bg.ltf.nap.IFileWriteLibrary#freeOutTextFile(java.io.OutputStreamWriter)
	 */
	public void freeOutTextFile(OutputStreamWriter w) {
		try {
			w.flush();
			w.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}				
	}
  // <<<<<<<<<<<<<< Create Text File 	

	/**
   * Gets the result.
   *
   * @return the result
   */
  public boolean getResult() {
		return result;
	}

	/**
	 * Sets the result.
	 *
	 * @param result the new result
	 */
	public void setResult(boolean result) {
		this.result = result;
	}

}
