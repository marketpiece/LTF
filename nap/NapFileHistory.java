package net.is_bg.ltf.nap;


/**
 * The Class NapFileHistory.
 */
public class NapFileHistory {
 	
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
	  * Instantiates a new nap file history.
	  *
	  * @param filename the filename
	  * @param mindate the mindate
	  * @param maxdate the maxdate
	  * @param recordcount the recordcount
	  * @param munid the munid
	  */
	 public NapFileHistory(String filename, String mindate, String maxdate, int recordcount, long munid) {
		this.filename = filename;
		this.mindate = mindate;
		this.maxdate = maxdate;
		this.recordcount = recordcount;
		this.munId = munid;
	}

	/**
	 * Gets the filename.
	 *
	 * @return the filename
	 */
	public String getFilename() {
		return filename;
	}

	/**
	 * Sets the filename.
	 *
	 * @param filename the new filename
	 */
	public void setFilename(String filename) {
		this.filename = filename;
	}

	/**
	 * Gets the mindate.
	 *
	 * @return the mindate
	 */
	public String getMindate() {
		return mindate;
	}

	/**
	 * Sets the mindate.
	 *
	 * @param mindate the new mindate
	 */
	public void setMindate(String mindate) {
		this.mindate = mindate;
	}

	/**
	 * Gets the maxdate.
	 *
	 * @return the maxdate
	 */
	public String getMaxdate() {
		return maxdate;
	}

	/**
	 * Sets the maxdate.
	 *
	 * @param maxdate the new maxdate
	 */
	public void setMaxdate(String maxdate) {
		this.maxdate = maxdate;
	}

	/**
	 * Gets the recordcount.
	 *
	 * @return the recordcount
	 */
	public int getRecordcount() {
		return recordcount;
	}

	/**
	 * Sets the recordcount.
	 *
	 * @param recordcount the new recordcount
	 */
	public void setRecordcount(int recordcount) {
		this.recordcount = recordcount;
	}

	/**
	 * Gets the mun id.
	 *
	 * @return the mun id
	 */
	public long getMunId() {
		return munId;
	}

	/**
	 * Sets the mun id.
	 *
	 * @param munId the new mun id
	 */
	public void setMunId(long munId) {
		this.munId = munId;
	}
 	
}
