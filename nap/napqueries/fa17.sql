DROP FUNCTION  IF EXISTS  napdata.fa17(numeric); 
CREATE OR REPLACE FUNCTION napdata.fa17(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
  select  
        '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/       
        '"'||rpadc(ts.idn,10) ||'",'|| /*БУЛСТАТ/Служебен номер на НАП*/   
        '"'||rpadc(REGEXP_REPLACE(td.partidano,'[,''""]+',' ','g'),8) ||'",'|| /*Входящ номер на декларация*/            
        '"'||rpadc(REGEXP_REPLACE(td.docno,'[,''""]+',' ','g'),15) ||'",'|| /*Пълен вх.номер на декларацията (при промяна на обстоятелствата)*/            
        rpadc(to_char(td.doc_date,'yyyymmdd'),8) ||','|| /*Дата на декларация*/            
        '"'||lpadc(fp.seqno,3,'0') ||'",'|| /*Пореден номер обект*/   
        '"'||rpadc(' ',1) ||'",'|| /*Индикатор за невалиден обект (‘1’-да,’ ‘-не)*/ 
        rpadc(to_char(td.change_date,'yyyymmdd'),8) ||','|| /*Дата на промяна на обстоятелство*/            
        '"'||rpadc(to_char(td.user_date,'yyyy'),4) ||'",'|| /*Година на датата на промяна*/            
        '"'||rpadc(to_char(fp.taxbegindate,'mm'),2) ||'",'|| /*Начало-Месец за облагане по отчетната стойност*/            
        '"'||rpadc(to_char(fp.taxenddate,'mm'),2) ||'",'|| /*Край-Месец за облагане по отчетната стойност*/            
        '"'||rpadc(case  to_char(coalesce(fp.ispublic,0)) when '1' then '1' else '2' end ,1) ||'",'|| /*Индикатор публична собственост (‘1’-да, ’2’-не)*/   
        '"'||rpadc(fp.kindowner,1) ||'",'|| /*Вид собственост (‘1’-частна, ’2’-общинска, ’3’-държавна)*/   
        '"'||rpadc(fp.istaxfree,1) ||'",'|| /*Индикатор за държавна публична собственост, предоставена за ползване на друго лице и то не е освободено от данък (‘1’-има данък, ‘2’ или ’ ‘ - няма данък)*/   
        '"'||rpadc(case to_char(fp.isbusiness) when '1' then '1' else '2' end ,1) ||'",'|| /*Индикатор-стопанска цел */ 
        to_char(fp.accvalue,'9999999999990.99') ||','|| /*Отчетна стойност*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 13 then '1' else '2' end ,1) ||'",'|| /*Индикатор за сграда на БЧК (‘1’-да, ‘ ‘ или ‘2’ –не)*/ 
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 14 then '1' else '2' end ,1) ||'",'|| /*Индикатор за читалище(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 3 then '1' else '2' end ,1) ||'",'|| /*Индикатор за собственост на дипломатическо представителство(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 9 then '1' else '2' end ,1) ||'",'|| /*Индикатор за използване от ВУ или академии за учебна цел(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 4 then '1' else '2' end ,1) ||'",'|| /*Индикатор за използване за непосредствени нужди на обществения транспорт(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 5 then '1' else '2' end ,1) ||'",'|| /*Индикатор за временна сграда, обслужваща строеж(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 7 then '1' else '2' end ,1) ||'",'|| /*Индикатор за парк, спортна площадка и др.(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 10 then '1' else '2' end ,1) ||'",'|| /*Индикатор за паметник на културата (‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(fp.monumentdoc,3) ||'",'|| /*Брой ДВ, в който обектът е обявен за паметник на културата */   
        '"'||rpadc(to_char(fp.monumentdate,'yyyy'),4) ||'",'|| /*Година на ДВ, в който обектът е обявен за паметник на културата*/            
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 11 then '1' else '2' end ,1) ||'",'|| /*Индикатор за молитвен дом(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 12 then '1' else '2' end ,1) ||'",'|| /*Индикатор за музей, галерия, библиотека(‘1’-да, ‘ ‘ или ‘2’ –не)*/   
        '"'||rpadc(case when (upper(fp.zeecategory) in ('А','Б')) then upper(fp.zeecategory) else ' ' end ,1) ||'",'|| /*Категория на сертификата по ЗЕЕ  (”А”,”Б”-големи букви на кирилица)*/   
        rpadc(to_char(fp.zeesertdate,'yyyymmdd'),8) ||','|| /*Дата на сертификата по ЗЕЕ*/   
        rpadc(to_char(td.user_date,'yyyymmdd'),8) || /*Дата на последна корекция*/
        CHR(13) || CHR(10)  imor_row   
   from Taxdoc td  
  -- join Taxdocarx tda on tda.taxdoc_id = td.taxdoc_id 
   join FirmProperty p on p.taxdoc_id = td.taxdoc_id 
   join Firmpropobj fp on fp.firmproperty_id = p.firmprop_id
   join TaxSubject ts on ts.taxsubject_id = td.taxsubject_id
   join Municipality m on m.municipality_id = td.municipality_id 
   where  td.documenttype_id = 22  
    and td.docstatus in ('30','90')
  --  and f1417.taxdoc_id_14 is null
    and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                else max(n.extractdate) end
           from napfilehistory n 
          where substr(n.filename,1,2) = 'FA' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
    and coalesce(td.user_date,td.doc_date) <= current_date 
    and td.municipality_id = $1 
    and coalesce(trim(td.partidano),'') != '' 
    order by rpadc(ts.idn,10), rpadc(REGEXP_REPLACE(td.partidano,'[,''""]+',' ','g'),8), lpadc(fp.seqno,3,'0'), fp.taxbegindate, fp.taxenddate
$function$
;
