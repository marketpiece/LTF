package net.is_bg.ltf.nap;

import javax.faces.model.SelectItem;

import net.is_bg.ltf.db.common.interfaces.IConnectionFactory;
import net.is_bg.ltf.db.dao.AbstractDao;


/**
 * The Class NapDao.
 */
public class NapDao extends AbstractDao {
	
	/**
	 * Instantiates a new nap dao.
	 *
	 * @param connectionFactory the connection factory
	 */
	public NapDao(IConnectionFactory connectionFactory) {
		super(connectionFactory);
		// TODO Auto-generated constructor stub
	}
	
    /**
     * Checks for nap file.
     *
     * @param filename the filename
     * @param mindate the mindate
     * @param maxdate the maxdate
     * @param recordcount the recordcount
     * @param munid the munid
     * @return true, if successful
     */
    public boolean hasNapFile(String filename, String mindate, String maxdate, int recordcount, long munid) {
		SelectItem[] si = new SelectItem[1];
		String sql = 
				"select nap.napfilehistory_id, nap.napfilehistory_id \n" + 
				"  from napfilehistory nap \n" +
				" where substr(nap.filename,1,2) = '" + filename + "' \n" +
				"  -- and nap.mindate = " + "to_date('" + mindate + "','yyyymmdd') \n" +
				"   and nap.maxdate = " + "to_date('" + maxdate + "','yyyymmdd') \n" +
				"  -- and nap.recordcount = " + recordcount + "\n" +
				"   and nap.municipality_id = " + munid;
		si = executeSelectItems(sql);
		return si.length > 0 ;
    }
    
//    public SelectItem[] getFilesHeader(long munid) {
//		SelectItem[] si = new SelectItem[1];
//		String sql = 
//				" select case when max(nap.maxdate) is not null then to_char(max(nap.maxdate),'yyyymmdd')\n"+
//				"        else to_char(min(td.change_date),'yyyymmdd') end ||\n"+
//				"        case when min(td.change_date) is not null and min(td.change_date) is not null then ',' end ||\n"+
//				"        to_char(max(td.change_date),'yyyymmdd') head,\n"+
//				"        max(m.old_code)||to_char(max(td.change_date),'mm')||'.G'||to_char(max(td.change_date),'yy') fileName\n"+
//				"  from Taxdoc td \n"+
//				"  join municipality m on m.municipality_id = td.municipality_id\n"+
//				"  left join napfilehistory nap on nap.municipality_id = td.municipality_id \n"+
//				"                              and substr(nap.filename,1,2) = 'OB' \n"+
//				" where td.documenttype_id in (21,22,26,27,28,29)\n"+
//				"   and td.docstatus != '10'\n"+
//				"   and (select case when max(n.maxdate) is null then to_date('01.01.1981','dd.mm.yyyy')\n"+
//				"               else max(n.maxdate) end\n"+
//				"          from napfilehistory n \n"+
//				"         where substr(n.filename,1,2) = 'OB' and n.municipality_id = td.municipality_id) <=\n"+
//				"         coalesce(td.change_date,trunc(td.user_date))\n"+
//				"   and td.municipality_id = "+ munid;
//		si = executeSelectItems(sql);
//		return si;
//    }    

	/**
 * Op exp.
 *
 * @param filename the filename
 * @param munId the mun id
 * @return the nap result type
 */
public NapResultType opExp(String filename, long munId){
	// Header 
		ImopSelectStatement statement = new ImopSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImopSelectStatement statement1 = new ImopSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Zm exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType zmExp(String filename, long munId){
	// Header 
		ImzemSelectStatement statement = new ImzemSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImzemSelectStatement statement1 = new ImzemSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);		
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}
	
	/**
	 * Sg exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType sgExp(String filename, long munId){
	// Header 
		ImsgrSelectStatement statement = new ImsgrSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImsgrSelectStatement statement1 = new ImsgrSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Ob exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType obExp(String filename, long munId){
	// Header 
		ImobektSelectStatement statement = new ImobektSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImobektSelectStatement statement1 = new ImobektSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
		// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * So exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType soExp(String filename, long munId){
	// Header 
		ImsobSelectStatement statement = new ImsobSelectStatement(filename, munId, "", null);
		execute(statement);		
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImsobSelectStatement statement1 = new ImsobSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Po exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType poExp(String filename, long munId){
	// Header 
		ImpolzSelectStatement statement = new ImpolzSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImpolzSelectStatement statement1 = new ImpolzSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Rs exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType rsExp(String filename, long munId){
	// Header 
		ImrazsSelectStatement statement = new ImrazsSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImrazsSelectStatement statement1 = new ImrazsSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Rp exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType rpExp(String filename, long munId){
	// Header 
		ImrazpSelectStatement statement = new ImrazpSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImrazpSelectStatement statement1 = new ImrazpSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Df exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType dfExp(String filename, long munId){
	// Header 
		ImdeklfSelectStatement statement = new ImdeklfSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImdeklfSelectStatement statement1 = new ImdeklfSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(),
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Of exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType ofExp(String filename, long munId){
	// Header 
		ImobekfSelectStatement statement = new ImobekfSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		ImobekfSelectStatement statement1 = new ImobekfSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Fa exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType faExp(String filename, long munId){
	// Header 
		Imobef_ASelectStatement statement = new Imobef_ASelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		Imobef_ASelectStatement statement1 = new Imobef_ASelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * P1 exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType p1Exp(String filename, long munId){
	// Header 
		Prm541SelectStatement statement = new Prm541SelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		Prm541SelectStatement statement1 = new Prm541SelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * P2 exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType p2Exp(String filename, long munId){
	// Header 
		Prm542SelectStatement statement = new Prm542SelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		Prm542SelectStatement statement1 = new Prm542SelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Ps exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType psExp(String filename, long munId){
	// Header 
		Prm_SobSelectStatement statement = new Prm_SobSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		Prm_SobSelectStatement statement1 = new Prm_SobSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}

	/**
	 * Pl exp.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 * @return the nap result type
	 */
	public NapResultType plExp(String filename, long munId){
	// Header 
		Prm_LicaSelectStatement statement = new Prm_LicaSelectStatement(filename, munId, "", null);
		execute(statement);
		NapResultType resultType = new NapResultType(statement.header, statement.filename, false);
	// Content	
		Prm_LicaSelectStatement statement1 = new Prm_LicaSelectStatement(resultType.getFilename(), munId, resultType.getHeader(), statement.napFile);
		execute(statement1);
		resultType.setResult(statement1.getResult());
	// Save NAP files history
		if (statement1.getResult()) {
			SaveNapFileHistory fileHistory = new SaveNapFileHistory(statement1.napFile.getFilename(), 
					                                                statement1.napFile.getMindate(),
					                                                statement1.napFile.getMaxdate(),
					                                                statement1.napFile.getRecordcount(),
					                                                statement1.napFile.getMunId());
			execute(fileHistory);
		}
		return resultType;
	}
	
	/**
	 * Delete nap file.
	 *
	 * @param filename the filename
	 * @param munId the mun id
	 */
	public void deleteNapFile(String filename, long munId){
		DeleteNapFileHistory statement = new DeleteNapFileHistory(filename, munId);
		execute(statement);
	}
	
    /**
     * Gets the last extract date.
     *
     * @param filename the filename
     * @param munId the mun id
     * @return the last extract date
     */
    public String getLastExtractDate(String filename, long munId ) {
		SelectItem[] si = new SelectItem[1];
		String sql = "select to_char(max(n.extractdate),'dd.mm.yyyy'), max(n.extractdate) from napfilehistory n where substr(n.filename,1,2) = '" + filename + "'" + 
			         "   and n.municipality_id = " + munId;
		si = executeSelectItems(sql);
		// if (!si[0].getValue().equals("")){
		return si.length > 0 && si[0].getValue() != null ? si[0].getValue().toString() : "";
    }
	
}
