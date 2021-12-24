DROP FUNCTION  IF EXISTS  napdata.of17(numeric); 
CREATE OR REPLACE FUNCTION napdata.of17(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
  Select 
         '"'||rpadc(max(m.old_code),4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
         '"'||rpadc(ts.idn,10) ||'",'|| /*БУЛСТАТ(Служебен номер на НАП)*/  
         '"'||rpadc(REGEXP_REPLACE(td.partidano,'[,''""]+',' ','g'),8) ||'",'|| /*Входящ номер на декларация*/           
         '"'||rpadc(fp.seqno,3) ||'",'|| /*Пореден номер обект*/  
         '"'||rpadc(REGEXP_REPLACE(max(fp.typeprop),'[,''""]+',' ','g'),30) ||'",'|| /*Вид обект*/  
         '"'||rpadc(REGEXP_REPLACE(max(fp.function),'[,''""]+',' ','g'),20) ||'",'|| /*Предназначение на обекта*/  
         '"'||case when coalesce(max(fp.ispublic),0) = 1 then '1' else '2' end ||'",'|| /*Индикатор публична собственост (‘1’-да, ’2’-не)*/  
         '"'||rpadc(to_char(max(fp.kindowner)),1) ||'",'|| /*Вид собственост (‘1’-частна, ’2’-общинска, ’3’-държавна)*/  
         '"'||case when coalesce(max(fp.ismunicip),0) = 1 then '1' else '2' end ||'",'|| /*Индикатор за общинска  собственост с наематели/ползватели(‘1’-да, ’2’ или ’ ‘-не)*/  
         '"'||case when coalesce(max(fp.istaxfree),0) = 1 then '1' else '2' end ||'",'|| /*Индикатор за държавна публична собственост, предоставена за ползване на друго лице и то не е освободено от данък (‘1’-има данък, ‘2’ или ’ ‘ - няма данък)*/  
         '"'||case when coalesce(max(fp.isbusiness),0) = 1 then '1' else '2' end ||'",'|| /*Индикатор-стопанска цел */  
         to_char(coalesce(max(fp.accvalue),0),'9999999999990.99') ||','|| /*Отчетна стойност*/  
         to_char(coalesce(max(fp.earntaxvalue_calc),0),'9999999999990.99') ||','|| /*Изчислен ДНИ за годината на придобиване*/  
         to_char(max(coalesce((select sum(coalesce(ds1.totaltax,0)) 
                    from Debtsubject ds1 
                   where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and ds1.kinddebtreg_id = ds.kinddebtreg_id
                     and ds1.kindparreg_id = ds.kindparreg_id
                     and ds1.taxperiod_id = ds.taxperiod_id                        
                    ),0)),'9999999999990.99') ||','|| /*Изчислен ДНИ в годишен размер*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 13 then '1' else '2' end ,1) ||'",'|| /*Индикатор за сграда на БЧК (‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 14 then '1' else '2' end ,1) ||'",'|| /*Индикатор за читалище(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 3 then '1' else '2' end ,1) ||'",'|| /*Индикатор за собственост на дипломатическо представителство(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 9 then '1' else '2' end ,1) ||'",'|| /*Индикатор за използване от ВУ или академии за учебна цел(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 4 then '1' else '2' end ,1) ||'",'|| /*Индикатор за използване за непосредствени нужди на обществения транспорт(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 5 then '1' else '2' end ,1) ||'",'|| /*Индикатор за временна сграда, обслужваща строеж(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 7 then '1' else '2' end ,1) ||'",'|| /*Индикатор за парк, спортна площадка и др.(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         --'"'||rpadc(case instr(fp.taxfreereason,'1',1,1) when 8 then '1' else '2' end ,1) ||'",'|| /*Индикатор за сграда на земеделски производител(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 10 then '1' else '2' end ,1) ||'",'|| /*Индикатор за паметник на културата (‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(REGEXP_REPLACE(max(fp.monumentdoc),'[,''""]+',' ','g'),3) ||'",'|| /*Брой ДВ, в който обектът е обявен за паметник на културата */  
         '"'||rpadc(to_char(max(fp.monumentdate),'yyyy'),4) ||'",'|| /*Година на ДВ, в който обектът е обявен за паметник на културата*/           
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 11 then '1' else '2' end ,1) ||'",'|| /*Индикатор за молитвен дом(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(case instr(max(fp.taxfreereason),'1',1,1) when 12 then '1' else '2' end ,1) ||'",'|| /*Индикатор за музей, галерия, библиотека(‘1’-да, ‘ ‘ или ‘2’ –не)*/  
         '"'||rpadc(to_char(max(fp.taxbegindate),'mmyyyy'),6) ||'",'|| /*Начало-месец и година за облагане по отчетната стойност*/           
         '"'||rpadc(to_char(max(fp.taxenddate),'mmyyyy'),6) ||'",'|| /*Край-месец и година за облагане по отчетната стойност */           
         rpadc(to_char(max(fp.earn_date),'yyyymmdd'),8) ||','|| /*Дата на придобиване*/           
         rpadc(to_char(max(fp.circumchange_date),'yyyymmdd'),8) ||','|| /*Дата на промяна на обстоятелство*/           
         '"'||case when upper(max(fp.zeecategory)) in ('А','Б') then upper(max(fp.zeecategory)) else ' ' end ||'",'|| /*Категория на сертификата по ЗЕЕ  (”А”,”Б”-големи букви на кирилица)*/  
         '"'||rpadc(max(fp.zeesertno),10) ||'",'|| /*Номер на сертификата по ЗЕЕ*/  
         rpadc(to_char(max(fp.zeesertdate),'yyyymmdd'),8) ||','|| /*Дата на сертификата по ЗЕЕ*/  
         '"'||rpadc(REGEXP_REPLACE(max(fp.zeesertpubl),'[,''""]+',' ','g'),15) ||'",'|| /*Издател на сертификата по ЗЕЕ*/  
         '"'||rpadc(to_number(coalesce(max(fp.builddate),'9999'),'9999'),4) ||'",'|| /*Година на построяване на сградата*/           
         '"'||case max(fp.iszee) when 10 then '1' else '2' end ||'",'|| /*Индикатор за наличие на възобновяем енергиен източник('1'-да, '2'-не)*/  
         rpadc(to_char(max(td.user_date),'yyyymmdd'),8) ||','|| /*Дата на последна корекция*/  
         '"'||rpadc(REGEXP_REPLACE(max(td14.partidano),'[,''""]+',' ','g'),17) ||'",'|| /*Партиден номер от декл. По чл. 14 за имота*/  
         '"'||rpadc(case when max(l.land_id) is not null then '999' else to_char(max(bui.seqnobuilding)) end,3) ||'",'|| /*Пореден номер сграда от декл. По чл. 14 за имота*/  
         '"'||rpadc(case when max(l.land_id) is not null then '99' else to_char(max(h.seqnoobj)) end,2) ||'"'|| /*Пореден номер обект от декл. По чл. 14 за имота*/        
         CHR(13) || CHR(10)  imor_row  
    from Taxdoc td 
    join Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
    join Taxobject tobj on tobj.taxobject_id = td.taxobject_id
    left join Address a on a.address_id = tobj.address_id
    
    join FirmProperty p on p.taxdoc_id = td.taxdoc_id
    join Firmpropobj fp on fp.firmproperty_id = p.firmprop_id 
   
    left join Firm_1417 f1417 on f1417.taxdoc_id_17 = td.taxdoc_id
    left join Taxdoc td14 on td14.taxdoc_id = f1417.taxdoc_id_14
    left join Property pp on pp.taxdoc_id = td14.taxdoc_id
    left join Building bui on bui.property_id = p.property_id
    left join Homeobj h on h.building_id = bui.building_id
    left join Land l on l.property_id = pp.property_id
    
    join Municipality m on m.municipality_id = td.municipality_id
    join Debtsubject ds on ds.document_id = td.taxdoc_id
                       and ds.doccode = '17'
                       and ds.kinddebtreg_id = 2
                       and ds.kindparreg_id = 2
   where td.documenttype_id = 22  
     and td.docstatus in ('30','90')
   --  and f1417.taxdoc_id_14 is not null
     and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                 else max(n.extractdate) end
            from napfilehistory n 
           where substr(n.filename,1,2) = 'OF' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
     and coalesce(td.user_date,td.doc_date) <= current_date 
     and td.municipality_id = $1
     and coalesce(trim(td.partidano),'') != ''
   group by 
            ts.idn,
            td.partidano,
            fp.seqno
   order by ts.idn, rpadc(REGEXP_REPLACE(td.partidano,'[,''""]+',' ','g'),8), to_number(fp.seqno)
$function$
;
