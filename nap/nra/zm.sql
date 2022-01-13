DROP FUNCTION  IF EXISTS  napdata.zm(numeric); 
CREATE OR REPLACE FUNCTION napdata.zm(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 SELECT  
        '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
        '"'||rpadc(td.partidano,17) ||'",'|| /*Партиден номер на имота*/  
        '"'||rpadc(case td.kinddecl when '1' then '1' else '2' end ,1) ||'",'|| /*Индикатор-собственик на земя */  
        '"'||rpadc(case td.kinddecl when '2' then '1' else '2' end ,1) ||'",'|| /*Индикатор-ползвател на земя */  
        '"'||rpadc(case l.buildingowner when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-собственик на сграда или част от нея, построена върху държавен или общински имот */  
        lpadc(to_char(l.landarea,'9999999990.99') ,13) ||','|| /*Площ на земята (кв.м)*/  
        lpadc(to_char(l.builtuparea,'99999990.99') ,11) ||','|| /*Застроена площ (кв.м)*/  
        lpadc(to_char(l.fenceheight,'9990.99') ,7) ||','|| /*Височина на масивна ограда (м)*/  
        lpadc(to_char(l.fencelength,'999990.99') ,9) ||','|| /*Дължина на масивна ограда (м)*/  
        lpadc(to_char(l.coveringarea,'9999999990.99') ,13) ||','|| /*Площ на трайна луксозна настилка (кв.м)*/  
        lpadc(to_char(l.sportarea,'999990.99') ,9) ||','|| /*Площ на спортни площадки с трайна настилка (кв.м)*/  
        lpadc(to_char(l.poolcapacity,'99999990.99') ,11) ||','|| /*Обем на басейни (куб.м)*/  
        lpadc(to_char(l.greenparking,'9999999990.99') ,13) ||','|| /*Площ на паркинги за общ.ползване - зелени и с нетрайна настилка (кв.м)*/  
        lpadc(to_char(l.parkingarea,'9999999990.99') ,13) ||','|| /*Площ на паркинги за общ.ползване – всички останали (кв.м)*/  
        '"'||rpadc(case l.ispark when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-имотът е парк, спортно игрище или площадка */  
        '"'||rpadc(REGEXP_REPLACE(coalesce(l.kindpublicproperty,' '),'[,""]+',' ','g') ,15) ||'",'|| /*Вид на друг подобен имот за обществени нужди*/  
        rpadc(to_char(l.restorelanddate,'yyyymmdd'),8) ||','|| /*Дата на възстановяване на собствеността по закон (за имот, който не е в състояние да бъде използван)*/  
        '"'||rpadc(REGEXP_REPLACE(coalesce(l.dutyfreeorder,' '),'[,""]+',' ','g'),30) ||'",'|| /*Конкретна разпоредба за друго основание за освобождаване от ДНИ*/  
        '"'||rpadc(case l.isbusiness when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-имотът се ползва със стопанска цел */  
        to_char(max(coalesce((select sum(dpp.sumval) 
                 from debtsubject d join debtpartproperty dpp on dpp.debtsubject_id = d.debtsubject_id
                where d.document_id = td.taxdoc_id 
                 -- and d.taxsubject_id = td.taxsubject_id 
                  and d.kinddebtreg_id = 2 
                  and dpp.kindproperty = 1 
                  and d.kindparreg_id = 2 
				--and dpp.homeobj_id = l.land_id 
		        and d.debtsubject_id = (select max(dss.debtsubject_id) from debtsubject dss  
		                                  where dss.document_id = d.document_id 
		                                    and coalesce (dss.typecorr,'0') != '2'  
		                                    and dss.kinddebtreg_id = d.kinddebtreg_id 
		                                    and dss.taxsubject_id = d.taxsubject_id  
		                                    and dss.kindparreg_id = d.kindparreg_id) 		
                ),0)),'99999999990.99') ||','|| /*Данъчна оценка на земята за ДНИ*/ 
        '"'||rpadc(case l.typedeclar when 2 then ts.name end ,30) ||'",'|| /*Ползвател на земя с възстановена по закон собственост */  
        '"'||rpadc(case l.typedeclar when 2 then l.restorelanddoc end ,30) ||'",'|| /*Документ за ползване на земя с възстановена по закон собственост*/  
        '"'||' ' ||'",'|| /*Индикатор за активност на записа */  
        rpadc(to_char(max(td.user_date),'yyyymmdd'),8) ||','|| /*Дата на последна корекция*/  
        '"'||rpadc(case when td.decl14to17 = 2 then 'ЗЕМЯ' else ' ' end,30) ||'",'|| /*Вид на обекта*/
        '"'||rpadc(case when td.decl14to17 = 2 then to_char(fpo.kindowner) else ' ' end,1) ||'",'|| /*Вид собственост (‘1’-частна, ’2’-общинска, ’3’-държавна)*/
        '"'||rpadc(case when td.decl14to17 = 2 then fpo.function else ' ' end,20) ||'",'|| /*Предназначение на обекта*/        
        '"'||rpadc(case when td.decl14to17 = 2 then fpo.taxfreereason else ' ' end,2) ||'",'|| /*Основание за освобождаване от данък*/
        to_char(max(coalesce(case when td.decl14to17 = 2 then fpo.accvalue else 0 end,0)),'9999999999990.99') || /*Отчетна стойност*/
        CHR(13) || CHR(10) :: text 
   from Taxdoc td 
 --   join Debtsubject ds on ds.document_id = td.taxdoc_id
   join Taxsubject ts on td.taxsubject_id = ts.taxsubject_id 
   join Taxobject tobj on td.taxobject_id = tobj.taxobject_id 
   join Property p on td.taxdoc_id = p.taxdoc_id 
   join Land l on l.property_id = p.property_id
   left join Address a on a.address_id = tobj.address_id
   left join Municipality m on m.municipality_id = td.municipality_id
   left join firmobj14 fpo on (fpo.land_id = l.land_id) /*or (fpo.homeobj_id = h.homeobj_id)*/
  where td.documenttype_id = 21    
    and td.docstatus in ('30','90')
    and coalesce(td.decl14to17,0) != 1
    and tobj.kindproperty in ('1','3')
    and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                    else max(n.extractdate) end
               from napfilehistory n 
              where substr(n.filename,1,2) = 'ZM' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
    and coalesce(td.user_date,td.doc_date) <= current_date 
    and td.municipality_id = $1
    and coalesce(trim(td.partidano),'') != '' 
 group by 
        m.old_code, 
        td.partidano,
        case td.kinddecl when '1' then '1' else '2' end,  
        case td.kinddecl when '2' then '1' else '2' end,  
        case l.buildingowner when 1 then '1' else '2' end,  
        to_char(l.landarea,'9999999990.99') ,  
        to_char(l.builtuparea,'99999990.99') ,  
        to_char(l.fenceheight,'9990.99') ,  
        to_char(l.fencelength,'999990.99') ,  
        to_char(l.coveringarea,'9999999990.99') ,  
        to_char(l.sportarea,'999990.99') ,  
        to_char(l.poolcapacity,'99999990.99') ,  
        to_char(l.greenparking,'9999999990.99') ,  
        to_char(l.parkingarea,'9999999990.99') ,  
        case l.ispark when 1 then '1' else '2' end ,
        coalesce(l.kindpublicproperty,' ') ,
        to_char(l.restorelanddate,'yyyymmdd'),  
        coalesce(l.dutyfreeorder,' ') ,
        case l.isbusiness when 1 then '1' else '2' end ,  
        case l.typedeclar when 2 then ts.name end , 
        case l.typedeclar when 2 then l.restorelanddoc end ,
        case when td.decl14to17 = 2 then 'ЗЕМЯ' else ' ' end,
        case when td.decl14to17 = 2 then to_char(fpo.kindowner) else ' ' end,
        case when td.decl14to17 = 2 then fpo.function else ' ' end,  
        case when td.decl14to17 = 2 then fpo.taxfreereason else ' ' end
 order by td.partidano
$function$
;
