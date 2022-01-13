DROP FUNCTION  IF EXISTS  napdata.pl(numeric); 
CREATE OR REPLACE FUNCTION napdata.pl(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 select 
        '"'||rpadc(max(m.old_code),4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
        '"'||rpadc(ts.idn,10) ||'",'|| /*ЕГН/БУЛСТАТ/Служебен номер на НАП/ЛНЧ на декларатор*/   
        '"'||rpadc(case when max(td.documenttype_id) in (26,27) then upper(REGEXP_REPLACE(tbj.registerno,'[,""]',' ','g'))  
              else row_number() over (partition by ts.idn,max(td.documenttype_id))::varchar end,8) ||'",'|| /*Регистрационен номер (за ППС) пореден номер (за въздухоплавателни и плавателни ПС)*/          
        '"'||case when ts1.taxsubject_id is not null and (ts1.isperson = 1) then  '1'   
             when ts1.taxsubject_id is not null and (ts1.isperson = 0) then  '2'    
             when ts1.taxsubject_id is not null and (ts1.isperson not in (0,1)) then  '3'
             else ' ' 
        end ||'",'|| /*Индикатор за съсобственик(‘1’-за ЕГН, ‘2’-ЮЛ, ’3’-ЛНЧ)*/   
        '"'||rpadc(ts1.idn,10) ||'",'|| /*ЕГН/БУЛСТАТ/Служебен момер на НАП/ЛНЧ на съсобственик*/   
        rpadc(max(pt.divident),3) ||','|| /*Идеална част – числител*/   
        rpadc(max(pt.divisor),5) ||','|| /*Идеална част – знаменател*/   
        '"'||case when max(r.telk_decisiondate) is not null then '1' else ' ' end ||'",'|| /*Индикатор за инвалид ('1'-да, ' '-не)*/   
        '"'||rpadc(REGEXP_REPLACE(max(r.telk_decisionno),'[,""]',' ','g'),15) ||'",'|| /*Номер на документ за инвалидност*/   
        rpadc(to_char(max(r.telk_decisiondate),'yyyymmdd'),8) ||','|| /*Дата на документ за инвалидност*/   
        rpadc(to_char(max(r.telk_enddate),'yyyymmdd'),8) ||','|| /*Краен срок на документа за инвалидност*/   
        to_char(coalesce((select sum(di.instsum)
                   from Debtsubject ds join Debtinstalment di on di.debtsubject_id = ds.debtsubject_id
                  where ds.document_id = max(td.taxdoc_id)
                     --and ds.doccode = '54'
                    and ds.kinddebtreg_id = 4
                    and ds.kindparreg_id = 2                  
                ),0),'99999990.99') ||','|| /*Данък в/у ПС*/   
        '"'||rpadc(REGEXP_REPLACE(coalesce(max(t.regno_old),' '),'[,""]',' ','g'),8) ||'",'|| /*Стар регистрационен номер*/   
        rpadc(to_char(max(td.user_date),'yyyymmdd'),8) || /*Дата на последна корекция*/   
        CHR(13) || CHR(10)  imor_row   
   from Taxdoc td  
   join Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
   join Taxobject tbj on tbj.taxobject_id = td.taxobject_id
   join Municipality m on m.municipality_id = td.municipality_id
 
   join Transport t on t.taxdoc_id = td.taxdoc_id 
   join Parttransport pt on pt.transport_id = t.transport_id and pt.enddate is null 
   join Taxsubject ts1 on ts1.taxsubject_id = pt.taxsubject_id
   left join Relief r on pt.relief_id = r.relief_id
 where td.documenttype_id in (26,27,28,29)   
   and td.docstatus in ('30','90')
   and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
               else max(n.extractdate) end
          from napfilehistory n 
         where substr(n.filename,1,2) = 'PL' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
   and coalesce(td.user_date,td.doc_date) <= current_date 
   and td.docstatus = case when td.docstatus = '90' and
                                   exists(select * from taxobject tob1 join taxdoc td1 on td1.taxobject_id = tob1.taxobject_id 
                                           where tob1.registerno = tbj.registerno 
                                             and td1.taxdoc_id != td.taxdoc_id 
                                             and td1.docstatus = '30') then '30' else td.docstatus end  
   and td.municipality_id = $1
 group by 
       ts.idn,   
       tbj.registerno,
       --td.documenttype_id,  
       case when ts1.taxsubject_id is not null and (ts1.isperson = 1) then  '1'   
            when ts1.taxsubject_id is not null and (ts1.isperson = 0) then  '2'    
            when ts1.taxsubject_id is not null and (ts1.isperson not in (0,1)) then  '3' 
            else ' ' 
        end,   
        ts1.idn		
 order by rpadc(ts.idn,10)||rpadc(case when max(td.documenttype_id) in (26,27) then upper(tbj.registerno) else row_number() over (partition by ts.idn,max(td.documenttype_id))::varchar end,8)||ts1.idn
$function$
;
