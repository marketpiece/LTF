package net.is_bg.ltf.nap;

import java.io.FileNotFoundException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;

import net.is_bg.ltf.util.StringUtils;



/**
 * The Class ImpolzSelectStatement.
 */
public class ImpolzSelectStatement extends FileSelectStatement implements IFileWriteLibrary {

	/**
	 * Instantiates a new impolz select statement.
	 *
	 * @param filename the filename
	 * @param municipalityid the municipalityid
	 * @param header the header
	 * @param napFile the nap file
	 */
	public ImpolzSelectStatement(String filename, long municipalityid, String header, NapFileHistory napFile) {
		super(filename, municipalityid, header, napFile);
	}

	/* (non-Javadoc)
	 * @see net.is_bg.ltf.nap.FileSelectStatement#getSqlHeader()
	 */
	protected String getSqlHeader(){
    	return super.getSqlHeader();
    }

	/* (non-Javadoc)
	 * @see net.is_bg.ltf.nap.FileSelectStatement#getSqlString()
	 */
	@Override
	protected String getSqlString() {
		if (super.header.equals("")) return getSqlHeader();
		return "select * from napdata.po("+ super.municipalityId +")";
	}
	

	/* (non-Javadoc)
	 * @see net.is_bg.ltf.db.common.SelectSqlStatement#retrieveResult(java.sql.ResultSet)
	 */
	@Override
	protected void retrieveResult(ResultSet rs) throws SQLException {       

		OutputStreamWriter w = null;
       /*EXTRACT HEADER AND FILE NAME===================*/
       if (super.header.equals("")) {
          super.napFile = new NapFileHistory("", "", "", 0, super.municipalityId); 
    	  if (rs.next()) { 
      		if (rs.getString(1) != null) {
 	    	   super.header = rs.getString(1);    	   
 	    	   super.filename = filename + rs.getString(2);
 	    	   super.napFile.setFilename(super.filename);
 	    	   super.napFile.setMindate(super.header.substring(0,8));
 	    	   super.napFile.setMaxdate(super.header.substring(9));
     		}
   	        return;
    	  } /*==========================================*/
       } else
    	   
 	   try{	
	    	try {
			  w = createOutTextFile(super.filename, "Cp1251");
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}	
	    	   /*FILE HEADER CONCATENATION AND SERIALIZATION=============================*/
		       if (rs.last()) {
		    	super.header = super.header + "," +
			                   StringUtils.rpad(String.valueOf(rs.getRow()),8," ") + "," +
		                       StringUtils.rpad(super.authorIDN,13," ") +
			                   "\r\n";
		    	super.napFile.setRecordcount(rs.getRow());
		    	writeOutTextFile(w, super.header);
		 		if (!super.getResult()) super.setResult(true);
		    	rs.beforeFirst();
		       } else {
			    	super.header = super.header + "," +
			                   StringUtils.rpad("0",8," ") + "," +
		                       StringUtils.rpad(super.authorIDN,13," ") +
			                   "\r\n";
			    	super.napFile.setRecordcount(0);
			 		if (!super.getResult()) super.setResult(true);
			    	writeOutTextFile(w, super.header);    	   
		       }
		       /*==========================================================================*/
		       
		       /*FILLING THE FILE=============================================*/
		 	   while(rs.next()){
	  		  	writeOutTextFile(w, rs.getString(1));
			  }
	  } finally {	
		freeOutTextFile(w);
	  }	
	}
	
}
