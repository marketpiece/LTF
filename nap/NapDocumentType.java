package net.is_bg.ltf.nap;

import net.is_bg.ltf.AbstractModel;


/**
 * The Class NapDocumentType.
 */
public class NapDocumentType extends AbstractModel {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -4746071390871382848L;
	
	/** The value. */
	private Object value;
	
	/** The label. */
	private String label;
	
	/** The imgindex. */
	private String imgindex;
	
	/** The color. */
	private String color;
	
	/**
	 * Instantiates a new nap document type.
	 *
	 * @param value the value
	 * @param label the label
	 * @param imgindex the imgindex
	 * @param color the color
	 */
	public NapDocumentType(Object value, String label, String imgindex, String color) {
		super();
		this.value = value;
		this.label = label;
		this.imgindex = imgindex;
		this.color = color;
	}
	
	/**
	 * Gets the value.
	 *
	 * @return the value
	 */
	public Object getValue() {
		return value;
	}
	
	/**
	 * Sets the value.
	 *
	 * @param value the new value
	 */
	public void setValue(Object value) {
		this.value = value;
	}
	
	/**
	 * Gets the label.
	 *
	 * @return the label
	 */
	public String getLabel() {
		return label;
	}
	
	/**
	 * Sets the label.
	 *
	 * @param label the new label
	 */
	public void setLabel(String label) {
		this.label = label;
	}
	
	/**
	 * Gets the imgindex.
	 *
	 * @return the imgindex
	 */
	public String getImgindex() {
		return imgindex;
	}
	
	/**
	 * Sets the imgindex.
	 *
	 * @param imgindex the new imgindex
	 */
	public void setImgindex(String imgindex) {
		this.imgindex = imgindex;
	}
	
	/**
	 * Gets the color.
	 *
	 * @return the color
	 */
	public String getColor() {
		return color;
	}
	
	/**
	 * Sets the color.
	 *
	 * @param color the new color
	 */
	public void setColor(String color) {
		this.color = color;
	}
    
}
