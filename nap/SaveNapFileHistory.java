package net.is_bg.ltf.nap;

import net.is_bg.ltf.db.common.UpdateSqlStatement;


/**
 * The Class SaveNapFileHistory.
 */
public class SaveNapFileHistory extends UpdateSqlStatement {

 	/** The filename. */
	 private String filename;
 	
	 /** The mindate. */
	 private String mindate;
 	
	 /** The maxdate. */
	 private String maxdate;
 	
	 /** The recordcount. */
	 private int recordcount;
 	
	 /** The mun id. */
	 private long munId;
	
 	/**
	  * Instantiates a new save nap file history.
	  *
	  * @param filename the filename
	  * @param mindate the mindate
	  * @param maxdate the maxdate
	  * @param recordcount the recordcount
	  * @param munid the munid
	  */
	 public SaveNapFileHistory(String filename, String mindate, String maxdate, int recordcount, long munid) {
 		super();
		this.filename = filename;
		this.mindate = mindate;
		this.maxdate = maxdate;
		this.recordcount = recordcount;
		this.munId = munid;		
	}
	
 	/* (non-Javadoc)
	  * @see net.is_bg.ltf.db.common.SqlStatement#getSqlString()
	  */
	 @Override
	protected String getSqlString() {
		// TODO Auto-generated method stub
		return 
		 "insert into NAPFILEHISTORY (napfilehistory_id, filename, mindate, maxdate, recordcount, municipality_id, extractdate) " +
         " values (" +
		           " nextval('s_napfilehistory')," +
                   "'"+ filename + "'," +
		           (mindate.trim().equals("") ? "null," : ("to_date('"+ mindate + "','yyyymmdd'),")) +
                   "to_date('"+ maxdate +"','yyyymmdd')," +
		           recordcount + "," +
                   munId + "," + 
                   "current_date" + 
                   ")";
          				
	}

	
}
