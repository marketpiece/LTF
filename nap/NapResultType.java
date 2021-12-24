package net.is_bg.ltf.nap;



/**
 * The Class NapResultType.
 */
public class NapResultType {
	
	/** The header. */
	private String header;
	
	/** The filename. */
	private String filename;
	
	/** The result. */
	private boolean result = false;
	
	/**
	 * Instantiates a new nap result type.
	 *
	 * @param header the header
	 * @param filename the filename
	 * @param result the result
	 */
	public NapResultType(String header, String filename, boolean result) {
		this.header = header;
		this.result = result;
		this.filename = filename;
 	}	
	
	/**
	 * Checks if is result.
	 *
	 * @return true, if is result
	 */
	public boolean isResult() {
		return this.result;
	}
	
	/**
	 * Sets the result.
	 *
	 * @param result the new result
	 */
	public void setResult(boolean result) {
		this.result = result;
	}
	
	/**
	 * Gets the filename.
	 *
	 * @return the filename
	 */
	public String getFilename() {
		return this.filename;		
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
	 * Gets the header.
	 *
	 * @return the header
	 */
	public String getHeader() {
		return this.header;
	}
	
	/**
	 * Sets the header.
	 *
	 * @param header the new header
	 */
	public void setHeader(String header) {
		this.header = header;
	}
}
