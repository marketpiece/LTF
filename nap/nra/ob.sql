DROP FUNCTION  IF EXISTS  napdata.ob(numeric); 
CREATE OR REPLACE FUNCTION napdata.ob(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 Select 
       '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
       '"'||rpadc(td.partidano,17) ||'",'|| /*Партиден номер*/  
       '"'||rpadc(bui.seqnobuilding,3) ||'",'|| /*Пореден номер сграда*/  
       '"'||rpadc(h.seqnoobj,2) ||'",'|| /*Пореден номер обект*/  
       '"'||rpadc(kh.code,2) ||'",'|| /*Вид обект*/  
       '"'||rpadc(kh.name,15) ||'",'|| /*Предназначение на обекта*/  
       to_char(coalesce(h.objectarea,0),'99999990.99') ||','|| /*РЗП на обекта (кв.м)*/                    
       to_char(coalesce(h.cellerarea,0),'99999990.99') ||','|| /*РЗП на мазе (кв.м)*/                    
       to_char(coalesce(h.atticarea,0),'99999990.99') ||','|| /*РЗП на таван (кв.м)*/                    
       to_char(coalesce(h.totalarea,0),'99999990.99') ||','|| /*РЗП - общо (кв.м)*/                    
       to_char(coalesce(h.height,0),'9990.99') ||','|| /*Височина*/                    
       '"'||rpadc(h.builddate ,4) ||'",'|| /*Година на построяване*/                    
       '"'||rpadc(h.floor ,2) ||'",'|| /*Етаж*/                    
       '"'||rpadc(case upper(h.kindconstruction) when 'ПН' then '1'   
                                            when 'ПМ' then '2'  
                                            when 'М1' then '3'  
                                            when 'М2' then '4'  
                                            when 'М3' then '5'  
             end,1) ||'",'|| /*Вид конструкция*/   
       '"'||rpadc(case h.iselectro when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-наличие на електрификация*/  
       '"'||rpadc(case h.iswater when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-наличие на водопровод*/  
       '"'||rpadc(case h.issewer when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-наличие на канализация*/  
       '"'||rpadc(case h.istec when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-наличие на ТЕЦ*/  
       '"'||rpadc(case h.istelefon when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-наличие на телефон */  
       '"'||rpadc(case h.isbusiness when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-стопанска цел */  
       '"'||rpadc(h.repairdate ,4) ||'",'|| /*Година на извършване на основен ремонт*/                    
       '"'||rpadc(case h.isheating when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-отоплителна инсталация */  
       '"'||rpadc(case h.isaircondition when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-климатична инсталация*/  
       '"'||rpadc(case h.luxwindow when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-луксозна дограма */  
       '"'||rpadc(case h.soundinsulation when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-шумо- или топлоизолация */  
       '"'||rpadc(case h.specialroof when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-специално покривно покритие*/  
       '"'||rpadc(case h.Luxdecorate when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-лукс.декоративни елементи и облицовки*/  
       rpadc(to_char(max(coalesce(dpp.sumval,0)),'99999999990.99'), 14) ||','|| /*Данъчна оценка на обект за годишен ДНИ*/      
       rpadc(to_char(h.restoreobjdate,'yyyymmdd') ,8) ||','|| /*Дата на възстановяване на  собствеността по закон*/                    
       '"'||rpadc(' ', 10) ||'",'|| /*Документ, удостоверяващ, че обектът не може да се ползва (за обекти с възстановена по закон собственост)*/   
       '"'||rpadc(' ' ,4) ||'",'|| /*Година на документ, удостоверяващ, че обектът не може да се ползва*/ 
       '"'||rpadc(REGEXP_REPLACE(max(case when pp.typedeclar = '2' then ts1.name else ' ' end),'[,""]',' ','g') ,30) ||'",'|| /*Ползвател на обект с възстановена по закон собственост */   
       '"'||rpadc(REGEXP_REPLACE(h.restoreobjdoc,'[,""]','','g') ,30) ||'",'|| /*Документ за ползване на обект с възстановена по закон собственост*/  
       '"'||rpadc(case when h.zeesertificat is not null and h.zeesertificat != ' ' then '1' else '2' end ,1) ||'",'|| /*Индикатор за наличие на сертификат по ЗЕЕ за обекта*/  
       '"'||' ' ||'",'|| /*Индикатор за активност на записа*/  
       rpadc(to_char(td.user_date,'yyyymmdd'),8) ||','|| /*Дата на последна корекция*/
       '"'||rpadc(case when td.decl14to17 = 2 then kh.fullname else ' ' end,30) ||'",'|| /*Вид на обекта*/      
       '"'||rpadc(case when td.decl14to17 = 2 then to_char(fo14.kindowner) else ' ' end,1) ||'",'|| /*Вид собственост (‘1’-частна, ’2’-общинска, ’3’-държавна)*/
       '"'||rpadc(REGEXP_REPLACE(case when td.decl14to17 = 2 then fo14.function else ' ' end,'[,""]',' ','g'), 20) ||'",'||  /*Предназначение на обекта*/        
       '"'||rpadc(case when td.decl14to17 = 2 then fo14.taxfreereason else ' ' end,2) ||'",'|| /*Основание за освобождаване от данък*/
       lpadc(case when td.decl14to17 = 2 then to_char(coalesce(fo14.accvalue,0.00),'9999999999990.99') else '0.00' end,16) || /*Отчетна стойност*/      
       CHR(13) || CHR(10) imor_row  
  from Taxdoc td 
  join Property p on p.taxdoc_id = td.taxdoc_id
  join Building bui on p.property_id = bui.property_id
  join Homeobj h on h.building_id = bui.building_id
  join parthomeobj ph on ph.homeobj_id = h.homeobj_id		
  left join Kindhomeobjreg kh on kh.kindhomeobjreg_id = h.kindhomeobjreg_id
  join Debtsubject ds on ds.document_id = td.taxdoc_id 
                      and ds.doccode = '14'
                      and ds.kinddebtreg_id = 2                     
                      and ds.kindparreg_id = 2       
  left join debtpartproperty dpp on dpp.debtsubject_id = ds.debtsubject_id 
                                and dpp.taxperiod_id = ds.taxperiod_id
                                and dpp.homeobj_id = h.homeobj_id 
                                and dpp.kindproperty = 2
  left join partproperty pp on pp.property_id = p.property_id
                           and pp.taxsubject_id = ds.taxsubject_id
  left join taxsubject ts1 on ts1.taxsubject_id = pp.taxsubject_id
  join Municipality m on m.municipality_id = td.municipality_id
  left join Firmobj14 fo14 on fo14.homeobj_id = h.homeobj_id
 where td.documenttype_id = 21           
   and td.docstatus in ('30','90')
   and coalesce(td.decl14to17,0) != 1  
   and p.kindproperty in ('2','3')
   and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
               else max(n.extractdate) end
          from napfilehistory n 
         where substr(n.filename,1,2) = 'OB' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
   and coalesce(td.user_date,td.doc_date) <= current_date 
   and td.municipality_id = $1
   and coalesce(trim(td.partidano),'') != '' 
 group by 
       m.old_code,
       td.partidano,  
       bui.seqnobuilding,  
       h.seqnoobj,  
       kh.code,  
       kh.name,  
       to_char(coalesce(h.objectarea,0),'99999990.99'),                    
       to_char(coalesce(h.cellerarea,0),'99999990.99'),                    
       to_char(coalesce(h.atticarea,0),'99999990.99'),                    
       to_char(coalesce(h.totalarea,0),'99999990.99'),                    
       to_char(coalesce(h.height,0),'9990.99'),                    
       h.builddate,                    
       h.floor,                    
       case upper(h.kindconstruction) when 'ПН' then '1'   
                                            when 'ПМ' then '2'  
                                            when 'М1' then '3'  
                                            when 'М2' then '4'  
                                            when 'М3' then '5'  
             end,   
       case h.iselectro when 1 then '1' else '2' end,  
       case h.iswater when 1 then '1' else '2' end ,  
       case h.issewer when 1 then '1' else '2' end ,  
       case h.istec when 1 then '1' else '2' end ,  
       case h.istelefon when 1 then '1' else '2' end ,  
       case h.isbusiness when 1 then '1' else '2' end ,  
       h.repairdate ,                    
       case h.isheating when 1 then '1' else '2' end ,  
       case h.isaircondition when 1 then '1' else '2' end ,  
       case h.luxwindow when 1 then '1' else '2' end ,  
       case h.soundinsulation when 1 then '1' else '2' end ,  
       case h.specialroof when 1 then '1' else '2' end ,  
       case h.Luxdecorate when 1 then '1' else '2' end ,
       --bui.building_id,
       --h.homeobj_id,
       to_char(h.restoreobjdate,'yyyymmdd') ,                    
       h.restoreobjdoc,    
       --case when pp.typedeclar = '2' then ts1.name else ' ' end,   
       h.restoreobjdoc ,  
       case when h.zeesertificat is not null and h.zeesertificat != ' ' then '1' else '2' end ,  
       to_char(td.user_date,'yyyymmdd'),
       case when td.decl14to17 = 2 then kh.fullname else ' ' end,
       case when td.decl14to17 = 2 then to_char(fo14.kindowner) else ' ' end,
       case when td.decl14to17 = 2 then fo14.function else ' ' end,        
       case when td.decl14to17 = 2 then fo14.taxfreereason else ' ' end,
       case when td.decl14to17 = 2 then to_char(coalesce(fo14.accvalue,0.00),'9999999999990.99') else '0.00' end        
 order by td.partidano, bui.seqnobuilding, h.seqnoobj
$function$
;
