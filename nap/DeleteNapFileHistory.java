package net.is_bg.ltf.nap;

import net.is_bg.ltf.db.common.UpdateSqlStatement;


/**
 * The Class DeleteNapFileHistory.
 */
public class DeleteNapFileHistory extends UpdateSqlStatement {
 	
	 /** The filename. */
	 private String filename;
 	
	 /** The mun id. */
	 private long munId;
	
	
 	/**
	  * Instantiates a new delete nap file history.
	  *
	  * @param filename the filename
	  * @param munid the munid
	  */
	 public DeleteNapFileHistory(String filename, long munid) {
 		super();
		this.filename = filename;
		this.munId = munid;		
	}

 	/* (non-Javadoc)
	  * @see net.is_bg.ltf.db.common.SqlStatement#getSqlString()
	  */
	 @Override
	protected String getSqlString() {
		// TODO Auto-generated method stub
			
       return "delete from NAPFILEHISTORY where substr(filename,1,2) = '" + this.filename + "'" +
    		  "   and municipality_id = " + this.munId +
    		  "   and extractdate = (select max(n.extractdate) from napfilehistory n where substr(filename,1,2) = '" + this.filename + "')";
	}

}
