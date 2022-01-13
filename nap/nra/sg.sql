DROP FUNCTION  IF EXISTS  napdata.sg(numeric); 
CREATE OR REPLACE FUNCTION napdata.sg(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 Select  
       '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
       '"'||rpadc(td.partidano,17) ||'",'|| /*Партиден номер*/
       '"'||rpadc(bui.seqnobuilding,3) ||'",'|| /*Пореден номер сграда*/
       '"'||rpadc(bui.Kindfunction,1) ||'",'|| /*Предназначение на сграда */
       '"'||rpadc(bui.floornumber,2) ||'",'|| /*Бр.етажи*/
       '"'||rpadc(bui.floornumover,2) ||'",'|| /*Бр.етажи-надземни*/
       '"'||rpadc(case coalesce(bui.elevator,0) when 1 then '1' else '2' end ,1) ||'",'|| /*Наличие на асансьор*/ 
       '"'||rpadc(case bui.monument when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-паметник на културата */  
       '"'||rpadc(REGEXP_REPLACE(bui.monumentdoc,'[,""]',' ','g'),3) ||'",'|| /*Бр.ДВ, в който сградата е обявена като паметник на културата*/  
       '"'||rpadc(coalesce(bui.monumentdate,'9999'),4) ||'",'|| /*Година на ДВ, в който сградата е обявена като паметник на културата*/  
       --'"'||rpadc(case bui.farm when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор-стопанска сграда на земеделски производител*/  
       '"'||rpadc(case bui.istemporary when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор за временна сграда, обслужваща строежа на друга сграда*/  
       --'"'||rpadc(bui.damagedoc,10) ||'",'|| /*Документ,удостоверяващ самосрутване или вредност – номер */  
       --'"'||rpadc(to_char(bui.damagedocdate,'9999'),4) ||'",'|| /*Документ,удостоверяващ самосрутване или вредност – година*/  
       --'"'||rpadc(bui.damagedocpubl,15) ||'",'|| /*Документ,удостоверяващ самосрутване или вредност – издател*/  
       '"'||rpadc(case when upper(bui.zeecategory) in ('А','Б') then upper(bui.zeecategory) else ' ' end ,1) ||'",'|| /*Категория на сертификата по ЗЕЕ  (”А”,”Б”-големи букви на кирилица)*/
       '"'||rpadc(REGEXP_REPLACE(bui.zeesertno,'[,""]',' ','g'),10) ||'",'|| /*Номер на сертификата по ЗЕЕ*/  
       rpadc(to_char(bui.zeesertdate,'yyyymmdd'),8) ||','|| /*Дата на сертификата по ЗЕЕ*/  
       '"'||rpadc(REGEXP_REPLACE(bui.zeesertpubl,'[,""]',' ','g'),15) ||'",'|| /*Издател на сертификата по ЗЕЕ*/  
       '"'||rpadc(case bui.bck when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор за сграда на БЧК ('1'-да, '2'-не)*/          
       '"'||rpadc(case bui.outland when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор за сграда, собственост на чужда държава*/
       '"'||rpadc(case bui.dutyfree when 1 then '1' else '2' end ,1) ||'",'|| /*Индикатор за наличие на друго основание за освобождаване от ДНИ*/ 
       '"'||rpadc(REGEXP_REPLACE(bui.dutyfreeorder,'[,""]',' ','g'),30) ||'",'|| /*Конкретна разпоредба за освобождаване от ДНИ*/  
       '"'||rpadc(coalesce(bui.buildyear,'9999'),4) ||'",'|| /*Година на построяване на сградата*/  
       '"'||rpadc(case coalesce(bui.zeeactivity,0) when 1 then '1' else '2' end,1) ||'",'|| /*Индикатор за наличие на възобновяем енергиен източник*/  
       '"'||' ' ||'",'|| /*Индикатор за активност на записа*/  
       rpadc(to_char(td.user_date,'yyyymmdd'),8) || /*Дата на последна корекция*/  
       CHR(13) || CHR(10)  imor_row
  from Taxdoc td 
  inner join Property p on p.taxdoc_id = td.taxdoc_id
  inner join Building bui on bui.property_id = p.property_id
  inner join municipality m on m.municipality_id = td.municipality_id
 where td.documenttype_id = 21  
   and td.docstatus in ('30','90')
   and coalesce(td.decl14to17,0) != 1  
   and p.kindproperty in ('2','3')  
    and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                    else max(n.extractdate) end
               from napfilehistory n 
              where substr(n.filename,1,2) = 'SG' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
   and coalesce(td.user_date,td.doc_date) <= current_date 
   and td.municipality_id = $1
   and coalesce(trim(td.partidano),'') != ''  
 order by td.partidano, bui.seqnobuilding
$function$
;
