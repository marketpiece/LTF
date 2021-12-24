package net.is_bg.ltf.nap;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ResourceBundle;
import java.util.Set;

import javax.faces.event.ActionEvent;

import net.is_bg.ltf.AbstractManagedBean;
import net.is_bg.ltf.util.FileUtil;



/**
 * The Class NapBean.
 */
public class NapBean extends AbstractManagedBean {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 879725546509816182L;
	
	/** The nap document types. */
	private List<NapDocumentType> napDocumentTypes;
    
    /** The Constant msg. */
    private final static ResourceBundle msg = ResourceBundle.getBundle("net.is_bg.ltf.bundles.msgNap_bg");
    
    /** The rows. */
    private Set<Integer> rows = null;
	
	/** The keys. */
	private String[][] keys = new String[15][2];//{{"",""},{"",""}}; 
	
	/** The confirm. */
	private String confirm = "";
	
	/** The row key. */
	private int rowKey = -1;
	
	/** The final caption. */
	private String finalCaption="";
	
	/** The imgidx. */
	private String imgidx = "";
	
	/** The nap file path. */
	private static String napFilePath = "/pages/nap/";
	
	/** The expnav. */
	private boolean expnav;
	
	/** The result type. */
	private NapResultType resultType;
	
	/** The Constant lastPartFileName. */
	private static final String lastPartFileName = "xxxxmm.Ggg";
	
	/** The prevexpcaption. */
	private String prevexpcaption = "";
	
	/** The prevexp. */
	private boolean prevexp;
	
	/** The lastextdate. */
	private String lastextdate = "";
	
	/** The command link color. */
	private String commandLinkColor = "navy";


	/**
	 * Gets the imgidx.
	 *
	 * @return the imgidx
	 */
	public String getImgidx() {
		return imgidx;
	}

	/**
	 * Sets the imgidx.
	 *
	 * @param imgidx the new imgidx
	 */
	public void setImgidx(String imgidx) {
		this.imgidx = imgidx;
	}

	/**
	 * Instantiates a new nap bean.
	 */
	public NapBean() {
		initKeys();
		//fillDocumentTypes();
		fillNapDocumentTypes();
		this.expnav = false;
		this.prevexp = false;
		this.resultType = new NapResultType("", "", false);
	}
	
    /**
     * Inits the keys.
     */
    private void initKeys(){
        keys[0][0] = "op";
        keys[1][0] = "zm";
        keys[2][0] = "sg";
        keys[3][0] = "ob";
        keys[4][0] = "so";
        keys[5][0] = "po";
        keys[6][0] = "rs";
        keys[7][0] = "rp";
        keys[8][0] = "df";
        keys[9][0] = "of";
        keys[10][0] = "fa";
        keys[11][0] = "p1";
        keys[12][0] = "p2";
        keys[13][0] = "ps";
        keys[14][0] = "pl";    	

        keys[0][1] = "14";
        keys[1][1] = "14";
        keys[2][1] = "14";
        keys[3][1] = "14";
        keys[4][1] = "14";
        keys[5][1] = "14";
        keys[6][1] = "14";
        keys[7][1] = "14";
        keys[8][1] = "17";
        keys[9][1] = "17";
        keys[10][1] = "17";
        keys[11][1] = "54B";
        keys[12][1] = "54V";
        keys[13][1] = "54L";
        keys[14][1] = "54L";    	
    }
	
	/**
	 * Fill nap document types.
	 */
	private void fillNapDocumentTypes(){
        List<NapDocumentType> dt = new ArrayList<NapDocumentType>();
		String label = "";
		String imgidx = "";		
		String color = "";
		Date extdate;
		Date currdate = strToDate(dateToString(getSysDate()));
		for (int j = 0; j < 15; j++) {
			label = msg.getString(keys[j][0]);
			imgidx = keys[j][1];
		    color = "navy";

		    lastextdate = dao().getLastExtractDate( keys[j][0].toUpperCase(), visit.getCurUser().getMunicipality().getId());
			extdate = lastextdate != "" ? strToDate(lastextdate) : null;
			if ((rowKey > -1) || ((extdate != null ? extdate.compareTo(currdate) : -1) == 0))  {
			  color = "InactiveCaption";
			}
		    dt.add(new NapDocumentType(j, label, imgidx, color));
		}
	    if (dt.size() > 0) {
		  setNapDocumentTypes(dt);		  
		}
	}
	
	/**
	 * Update nap document types.
	 *
	 * @param rowkey the rowkey
	 */
	private void updateNapDocumentTypes(int rowkey){
		NapDocumentType dt = getNapDocumentTypes().get(rowkey);
        if (dt != null) {
        	dt.setColor("InactiveCaption");
        }
	}

	/**
	 * Exp methods.
	 */
	public void expMethods(){
	   System.out.println("Exp** the row = " + rowKey);
	   String fn = keys[rowKey][0].toUpperCase();
	   long munId = visit.getCurUser().getMunicipality().getId();	
	   
	   if (prevexp) { /* Delete last extract of selected file for selected checkbox */
		 dao().deleteNapFile(fn, munId);
	   }
	   setCurrentSessionTimeout(60*60);
	   switch (rowKey) {
	   case 0: this.resultType = dao().opExp(fn,munId); break;
	   case 1: this.resultType = dao().zmExp(fn,munId); break;
	   case 2: this.resultType = dao().sgExp(fn,munId); break;
	   case 3: this.resultType = dao().obExp(fn,munId); break;
	   case 4: this.resultType = dao().soExp(fn,munId); break;
	   case 5: this.resultType = dao().poExp(fn,munId); break;
	   case 6: this.resultType = dao().rsExp(fn,munId); break;
	   case 7: this.resultType = dao().rpExp(fn,munId); break;
	   case 8: this.resultType = dao().dfExp(fn,munId); break;
	   case 9: this.resultType = dao().ofExp(fn,munId); break;
	   case 10: this.resultType = dao().faExp(fn,munId); break;
	   case 11: this.resultType = dao().p1Exp(fn,munId); break;
	   case 12: this.resultType = dao().p2Exp(fn,munId); break;
	   case 13: this.resultType = dao().psExp(fn,munId); break;
	   case 14: this.resultType = dao().plExp(fn,munId); break;
	   default:
	 	break;
	   }
	   
	   this.expnav = true;
	   if (resultType.isResult()){
	   setFinalCaption(msg.getString("finalcaption"));
	   setCommandLinkColor("InactiveCaption");
	   updateNapDocumentTypes(getRowKey());
	   }
	   else setFinalCaption(msg.getString("norows") + keys[rowKey][0].toUpperCase()+lastPartFileName);
	}	
	
	/**
	 * Dao.
	 *
	 * @return the nap dao
	 */
	public NapDao dao(){
		return getServiceLocator().getNapDao();
	}

    /**
     * Proccess selection.
     *
     * @param e the e
     */
    public void proccessSelection(ActionEvent e) {
    	String row = getFacesContext().getExternalContext().getRequestParameterMap().get("rowindex"); 
    	if (!row.equals("")) {    	   	
		 rowKey = Integer.parseInt(row); // intlist.get((int) Integer.parseInt(row));
         confirm = msg.getString("question") + msg.getString(keys[rowKey][0]);
         System.out.println("Row** the row = " + rowKey);
         this.lastextdate = dao().getLastExtractDate(keys[rowKey][0].toUpperCase(), visit.getCurUser().getMunicipality().getId());
 	     prevexpcaption = msg.getString("prevexpcaption") + (getLastextdate().equals(null)? "" : getLastextdate() + "?");
         this.expnav = false;
         this.prevexp = false;
         this.resultType = new NapResultType("", "", false);
    	}  
    }

    /**
     * Download file.
     *
     * @param e the e
     */
    public void downloadFile(ActionEvent e){    	
    	 String filename = resultType.getFilename(); //keys[rowKey][0]+".txt";
    	 System.out.println(filename);
	     FileUtil.saveFileAsText(FileUtil.getRealPath(getNapFilePath()), filename);
    }
    
	/**
	 * Erase text file.
	 *
	 * @param e the e
	 */
	public void eraseTextFile(ActionEvent e) {
		String path = "";		
    	String filename = resultType.getFilename();//keys[rowKey][0]+".txt";
		path = FileUtil.getRealPath(getNapFilePath());
		File f = new File(path, filename);
 	    try {
		   f.delete();			
		} catch (SecurityException ee) {
			ee.printStackTrace();
		}
	}
    
	/**
	 * Gets the rows.
	 *
	 * @return the rows
	 */
	public Set<Integer> getRows() {
		return rows;
	}

	/**
	 * Sets the rows.
	 *
	 * @param rows the new rows
	 */
	public void setRows(Set<Integer> rows) {
		this.rows = rows;
	}

	/**
	 * Gets the nap document types.
	 *
	 * @return the nap document types
	 */
	public List<NapDocumentType> getNapDocumentTypes() {
		return napDocumentTypes;
	}

	/**
	 * Sets the nap document types.
	 *
	 * @param napDocumentTypes the new nap document types
	 */
	public void setNapDocumentTypes(List<NapDocumentType> napDocumentTypes) {
		this.napDocumentTypes = napDocumentTypes;
	}

	/**
	 * Gets the confirm.
	 *
	 * @return the confirm
	 */
	public String getConfirm() {
		return confirm;
	}

	/**
	 * Sets the confirm.
	 *
	 * @param confirm the new confirm
	 */
	public void setConfirm(String confirm) {
		this.confirm = confirm;
	}
	
	/**
	 * Gets the row key.
	 *
	 * @return the row key
	 */
	public int getRowKey() {
		return rowKey;
	}

	/**
	 * Sets the row key.
	 *
	 * @param rowKey the new row key
	 */
	public void setRowKey(int rowKey) {
		this.rowKey = rowKey;
	}
	
	/**
	 * Gets the final caption.
	 *
	 * @return the final caption
	 */
	public String getFinalCaption() {
		return finalCaption;
	}

	/**
	 * Sets the final caption.
	 *
	 * @param finalcaption the new final caption
	 */
	public void setFinalCaption(String finalcaption) {
		this.finalCaption = finalcaption;
	}
	
	/**
	 * Gets the nap file path.
	 *
	 * @return the nap file path
	 */
	public static String getNapFilePath() {
		return napFilePath;
	}

	/**
	 * Sets the nap file path.
	 *
	 * @param napFilePath the new nap file path
	 */
	public static void setNapFilePath(String napFilePath) {
		NapBean.napFilePath = napFilePath;
	}

	/**
	 * Checks if is expnav.
	 *
	 * @return true, if is expnav
	 */
	public boolean isExpnav() {
		return expnav;
	}

	/**
	 * Sets the expnav.
	 *
	 * @param expnav the new expnav
	 */
	public void setExpnav(boolean expnav) {
		this.expnav = expnav;
	}

	/**
	 * Gets the result type.
	 *
	 * @return the result type
	 */
	public NapResultType getResultType() {
		return resultType;
	}

	/**
	 * Checks if is prevexp.
	 *
	 * @return true, if is prevexp
	 */
	public boolean isPrevexp() {
		return prevexp;
	}

	/**
	 * Sets the prevexp.
	 *
	 * @param prevexp the new prevexp
	 */
	public void setPrevexp(boolean prevexp) {
		this.prevexp = prevexp;
	}

	/**
	 * Gets the lastextdate.
	 *
	 * @return the lastextdate
	 */
	public String getLastextdate() {
		return lastextdate;
	}

	/**
	 * Sets the lastextdate.
	 *
	 * @param lastextdate the new lastextdate
	 */
	public void setLastextdate(String lastextdate) {
		this.lastextdate = lastextdate;
	}

	/**
	 * Gets the prevexpcaption.
	 *
	 * @return the prevexpcaption
	 */
	public String getPrevexpcaption() {
		return prevexpcaption;
	}

	/**
	 * Sets the prevexpcaption.
	 *
	 * @param prevexpcaption the new prevexpcaption
	 */
	public void setPrevexpcaption(String prevexpcaption) {
		this.prevexpcaption = prevexpcaption;
	}

	/**
	 * Gets the command link color.
	 *
	 * @return the command link color
	 */
	public String getCommandLinkColor() {
		return commandLinkColor;
	}

	/**
	 * Sets the command link color.
	 *
	 * @param commandLinkColor the new command link color
	 */
	public void setCommandLinkColor(String commandLinkColor) {
		this.commandLinkColor = commandLinkColor;
	}

	
}
