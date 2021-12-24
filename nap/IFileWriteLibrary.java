package net.is_bg.ltf.nap;

import java.io.FileNotFoundException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;


/**
 * The Interface IFileWriteLibrary.
 */
public interface IFileWriteLibrary {

	/**
	 * Creates the out text file.
	 *
	 * @param filename the filename
	 * @param charsetName the charset name
	 * @return the output stream writer
	 * @throws FileNotFoundException the file not found exception
	 * @throws UnsupportedEncodingException the unsupported encoding exception
	 */
	abstract OutputStreamWriter createOutTextFile(String filename, String charsetName) throws FileNotFoundException, UnsupportedEncodingException;
	
	/**
	 * Write out text file.
	 *
	 * @param w the w
	 * @param s the s
	 */
	abstract void writeOutTextFile(OutputStreamWriter w, String s);
	
	/**
	 * Free out text file.
	 *
	 * @param w the w
	 */
	abstract void freeOutTextFile(OutputStreamWriter w);
	
}
