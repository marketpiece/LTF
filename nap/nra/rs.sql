DROP FUNCTION  IF EXISTS  napdata.rs(numeric); 
CREATE OR REPLACE FUNCTION napdata.rs(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 select sub.imor_row  from (	
   select    td.partidano,bui.seqnobuilding,h.seqnoobj, to_number(REGEXP_REPLACE(trim(pp.seqnots),'\D+','')),      
         '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/  
         '"'||rpadc(td.partidano,17) ||'",'|| /*Партиден номер*/   
         '"'||rpadc(bui.seqnobuilding,3) ||'",'|| /*Номер сграда */   
         '"'||rpadc(h.seqnoobj,2) ||'",'|| /*Номер обект */   
         '"'||rpadc(pp.seqnots,3) ||'",'|| /*Номер собственик*/   
         lpadc(dpp.divident,3) ||','|| /*Числител на ид.ч.*/   
         lpadc(dpp.divisor,5) ||','|| /*Знаменател на ид.ч.*/ 
         to_char(max(coalesce(dpp.part,0) /*(case when coalesce(dpp.divident,0) = 0 then dpp.part else dpp.divident / case when coalesce(dpp.divisor,0) = 0 then 1 else dpp.divisor end end)*/),'999990.99999') ||','|| /*Идеална част като дес.дроб*/   
         '"'||rpadc(case dpp.isbasehome when 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор основно жилище за текущата година ('1'-да,' '-не)*/   
         '"'||rpadc(case dpp.isrelief when 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за инвалид ('1'-да, ' '-не)*/   
         '"'||rpadc(REGEXP_REPLACE(r.telk_decisionno,'[,''""]+',' ','g'),15) ||'",'|| /*Документ за инвалидност*/   
         '"'||rpadc(case when dpp.isrelief = 1 and r.telk_enddate is null then 'ПОЖИЗ' else ' ' end,5) ||'",'|| /*Срок на документ за инвалидност*/   
         to_char(max(coalesce(
                   (select sum(dpp1.sumval)
                       from Debtsubject ds1
                       join Debtpartproperty dpp1 on dpp1.debtsubject_id = ds1.debtsubject_id
                      where ds1.debtsubject_id = ds.debtsubject_id
                        and dpp1.kindproperty = 2
                        and dpp1.homeobj_id = h.homeobj_id                      
               ),0)),'99999999990.99') ||','|| /*Данъчна оценка за годишен данък недвижими имоти*/      
         to_char(sum(coalesce(dpp.totaltax,0)),'99999990.99') ||','|| /*Данък недвижими имоти за обект*/   
         '"'||rpadc(to_char(dpp.taxbegindate,'mmyyyy'),6) ||'",'|| /*Облагане от месец и година*/   
         '"'||rpadc(to_char(dpp.taxenddate,'mmyyyy'),6) ||'",'|| /*Облагане до месец и година*/   
         '"'||' ' ||'",'|| /*Индикатор за активност на записа*/   
         rpadc(to_char(max(td.user_date),'yyyymmdd'),8) ||','|| /*Дата на последна корекция*/   
         rpadc(case when r.telk_enddate is not null then left(to_char(r.telk_enddate,'yyyy'),4)||to_char(r.telk_enddate,'mmdd')  else ' ' end,8) || /*Краен срок на документ за инвалидност*/   
         CHR(13) || CHR(10)  imor_row   
    from Taxdoc td  
    join Property p on p.taxdoc_id = td.taxdoc_id
  --  left join Land l on l.property_id = p.property_id
    join Partproperty pp on pp.property_id = p.property_id  
    left join Building bui on bui.property_id = p.property_id
    join Homeobj h on h.building_id = bui.building_id
    left join Kindhomeobjreg kh on kh.kindhomeobjreg_id = h.kindhomeobjreg_id 
    join Municipality m on m.municipality_id = td.municipality_id
    join Debtsubject ds on ds.document_id = td.taxdoc_id
                       and ds.doccode = '14'
                       and ds.kinddebtreg_id = 2
                       and ds.kindparreg_id = 2
                       and ds.taxsubject_id = pp.taxsubject_id
 	                   and ds.debtsubject_id = (select max(dss.debtsubject_id) from debtsubject dss 
                                                 where dss.document_id = td.taxdoc_id
                                                   and coalesce (dss.typecorr,'0') != '2' 
                                                   and dss.kinddebtreg_id = ds.kinddebtreg_id 
                                                   and dss.taxsubject_id = pp.taxsubject_id 
                                                   and dss.kindparreg_id = ds.kindparreg_id) 
    join Debtpartproperty dpp on dpp.debtsubject_id = ds.debtsubject_id
                             and dpp.homeobj_id =  h.homeobj_id  and (dpp.divident != 0 or dpp.part != 0)
                             and dpp.typedeclar = to_char(coalesce(pp.typedeclar,0))    
    left join Relief r on r.relief_id = dpp.relief_id
    join TaxSubject ts on ts.taxsubject_id = ds.taxsubject_id
   where td.documenttype_id = 21  
     and td.docstatus in ('30','90')
     and pp.typedeclar = '1'  
     and coalesce(td.decl14to17,0) != 1  
     and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                 else max(n.extractdate) end
            from napfilehistory n 
           where substr(n.filename,1,2) = 'RS' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
     and coalesce(td.user_date,td.doc_date) <= current_date 
     and td.municipality_id = $1
     and coalesce(trim(td.partidano),'') != '' 
   group by 
         m.old_code,  
         td.partidano,   
         bui.seqnobuilding,   
         h.seqnoobj,   
         pp.seqnots,   
         dpp.divident,   
         dpp.divisor,   
         to_char(coalesce(dpp.part,0),'999990.99999'),   
         case dpp.isbasehome when 1 then '1' else ' ' end ,   
         case dpp.isrelief when 1 then '1' else ' ' end,   
         r.telk_decisionno,   
         case when dpp.isrelief = 1 and r.telk_enddate is null then 'ПОЖИЗ' else ' ' end,
         to_char(dpp.taxbegindate,'mmyyyy'),   
         to_char(dpp.taxenddate,'mmyyyy'),   
         case when r.telk_enddate is not null then left(to_char(r.telk_enddate,'yyyy'),4)||to_char(r.telk_enddate,'mmdd')  else ' ' end
  union all
 
   select    td.partidano,999,99,to_number(REGEXP_REPLACE(trim(pp.seqnots),'\D+','')),        
         '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/  
         '"'||rpadc(coalesce(td.partidano,'9999999999999'),17) ||'",'|| /*Партиден номер*/   
         '"'||rpadc(999,3) ||'",'|| /*Номер сграда */   
         '"'||rpadc(99,2) ||'",'|| /*Номер обект */   
         '"'||rpadc(pp.seqnots,3) ||'",'|| /*Номер собственик*/   
         lpadc(dpp.divident,3) ||','|| /*Числител на ид.ч.*/   
         lpadc(dpp.divisor,5) ||','|| /*Знаменател на ид.ч.*/ 
        -- '"'||rpadc(max(pp.name),50)||','||  
         to_char(max(dpp.part/*(case when coalesce(dpp.divident,0) = 0 then dpp.part else dpp.divident / case when coalesce(dpp.divisor,0) = 0 then 1 else dpp.divisor end end)*/),'999990.99999') ||','|| /*Идеална част като дес.дроб*/   
         '"'||rpadc(case dpp.isbasehome when 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор основно жилище за текущата година ('1'-да,' '-не)*/   
         '"'||rpadc(case dpp.isrelief when 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за инвалид ('1'-да, ' '-не)*/   
         '"'||rpadc(REGEXP_REPLACE(r.telk_decisionno,'[,''""]+',' ','g'),15) ||'",'|| /*Документ за инвалидност*/   
         '"'||rpadc(case when dpp.isrelief = 1 and r.telk_enddate is null then 'ПОЖИЗ' else ' ' end,5) ||'",'|| /*Срок на документ за инвалидност*/   
         to_char(max(coalesce(/*dpp.sumval*/
                   (select sum(dpp1.sumval)
                        from Debtsubject ds1
                        join Debtpartproperty dpp1 on dpp1.debtsubject_id = ds1.debtsubject_id
                       where ds1.debtsubject_id = ds.debtsubject_id 
                         and dpp1.kindproperty = 1
                         and dpp1.homeobj_id = l.land_id                                         
                ),0)),'99999999990.99') ||','|| /*Данъчна оценка за годишен данък недвижими имоти*/      
         to_char(sum(coalesce(dpp.totaltax,0)),'99999990.99') ||','|| /*Данък недвижими имоти за обект*/   
         '"'||rpadc(to_char(dpp.taxbegindate,'mmyyyy'),6) ||'",'|| /*Облагане от месец и година*/   
         '"'||rpadc(to_char(dpp.taxenddate,'mmyyyy'),6) ||'",'|| /*Облагане до месец и година*/   
         '"'||' ' ||'",'|| /*Индикатор за активност на записа*/   
         rpadc(to_char(max(td.user_date),'yyyymmdd'),8) ||','|| /*Дата на последна корекция*/   
         rpadc(case when r.telk_enddate is not null then left(to_char(r.telk_enddate,'yyyy'),4)||to_char(r.telk_enddate,'mmdd')  else ' ' end,8) || /*Краен срок на документ за инвалидност*/   
         CHR(13) || CHR(10)  imor_row   
    from Taxdoc td  
    join Property p on p.taxdoc_id = td.taxdoc_id
    left join Land l on l.property_id = p.property_id
    join Partproperty pp on pp.property_id = p.property_id  
    join Municipality m on m.municipality_id = td.municipality_id
    join Debtsubject ds on ds.document_id = td.taxdoc_id
                       and ds.doccode = '14'
                       and ds.kinddebtreg_id = 2
                       and ds.kindparreg_id = 2
                       and ds.taxsubject_id = pp.taxsubject_id
 	                  and ds.debtsubject_id = (select max(dss.debtsubject_id) 
                                                  from debtsubject dss 
                                                 where dss.document_id = td.taxdoc_id
                                                   and coalesce (dss.typecorr,'0') != '2' 
                                                   and dss.kinddebtreg_id = ds.kinddebtreg_id 
                                                   and dss.taxsubject_id = ds.taxsubject_id 
                                                   and dss.kindparreg_id = ds.kindparreg_id) 
    join Debtpartproperty dpp on dpp.debtsubject_id = ds.debtsubject_id
                             and dpp.homeobj_id =  l.land_id and (dpp.divident != 0 or dpp.part != 0) 
                             and dpp.typedeclar = to_char(coalesce(pp.typedeclar,0))    
    left join Relief r on r.relief_id = dpp.relief_id
    join TaxSubject ts on ts.taxsubject_id = ds.taxsubject_id
   where td.documenttype_id = 21  
     and td.docstatus in ('30','90')
     and pp.typedeclar = '1'  
     and coalesce(td.decl14to17,0) != 1  
     and (select case when max(n.maxdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                 else max(n.maxdate) end
            from napfilehistory n 
           where substr(n.filename,1,2) = 'RS' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
     and coalesce(td.user_date,td.doc_date) <= current_date 
     and td.municipality_id = $1 
   group by 
         m.old_code,  
         td.partidano,   
         pp.seqnots,   
         dpp.divident,   
         dpp.divisor,   
         to_char(coalesce(dpp.part,0),'999990.99999'),   
         case dpp.isbasehome when 1 then '1' else ' ' end ,   
         case dpp.isrelief when 1 then '1' else ' ' end,   
         r.telk_decisionno,   
         case when dpp.isrelief = 1 and r.telk_enddate is null then 'ПОЖИЗ' else ' ' end,
         to_char(dpp.taxbegindate,'mmyyyy'),   
         to_char(dpp.taxenddate,'mmyyyy'),   
         case when r.telk_enddate is not null then left(to_char(r.telk_enddate,'yyyy'),4)||to_char(r.telk_enddate,'mmdd')  else ' ' end
   order by 1,2,3,4 ) sub
$function$
;
