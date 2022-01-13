DROP FUNCTION  IF EXISTS  napdata.p2(numeric); 
CREATE OR REPLACE FUNCTION napdata.p2(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 select
       '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
       '"'||rpadc(REGEXP_REPLACE(td.partidano,'[,""]',' ','g'),16) ||'",'|| /*Входящ номер на декларация по чл.54*/  
       rpadc(to_char(td.doc_date,'yyyymmdd'),8) ||','|| /*Дата на декларация*/  
       '"'||rpadc(ts.idn,10) ||'",'|| /*ЕГН/БУЛСТАТ/Служебен номер на НАП/ЛНЧ*/  
       '"'||rpadc(ts.kind_idn,1) ||'",'|| /*Индикатор(‘1’-ЕГН, ‘2’-ЮЛ, ’3’-ЛНЧ)*/  
       '"'||rpadc(row_number() over (partition by ts.idn),3) ||'",'|| /*Пореден номер*/         
       '"'||rpadc(ts.name,50) ||'",'|| /*Име на лицето*/  
       '"'||rpadc(tmr.code,2) ||'",'|| /*Вид ПС*/  
       '"'||rpadc(REGEXP_REPLACE(tmr.name,'[,""]',' ','g'),20) ||'",'|| /*Наименование*/  
       '"'||rpadc((select city.ekatte from city where city.city_id=a.city_id),5) ||'",'|| /*Код населено място на регистрация на ПС*/  
       '"'||rpadc(case when td.documenttype_id = 28 then tmr.name  
                  when (td.documenttype_id = 29) and (tmr.code = '30') then cm.mark_name else ' ' end   
             ,20) ||'",'|| /*Име по регистъра (за плавателни средства) / марка (за самолет)*/  
       '"'||rpadc(case when (td.documenttype_id = 29) and (tmr.code = '30') then cmd.model_name end,30) ||'",'|| /*Модел (за самолет)*/  
       to_char(case when tmr.code in ('16','20') then coalesce(t.horsepower,0)  
                    when tmr.code in ('17','18') then coalesce(t.brutto_ton,0) else 0 end,
               '999990.999') ||','|| /*Мощност (за ветроходни и моторни яхти и кораби),бруто тонаж (за скутери, влекачи и тласкачи)*/  
       to_char(case when tmr.code in ('16','20') then coalesce(t.brutto_ton,0)  
                    when tmr.code in ('17','18') then coalesce(t.horsepower,0)   
                    when tmr.code in ('17','18') then coalesce(t.horsepower,0)   
               else 0 end, 
               '9999990.99') ||','|| /*Бруто тонаж (за ветроходни и моторни яхти и кораби),  
                       мощност (за скутери, влекачи и тласкачи),  
                       макс.товароподемност (за речен несамоходен плавателен съд),  
                       макс.излетно тегло (за самолети)*/  
       '"'||rpadc(upper(REGEXP_REPLACE(t.regno,'[,""]',' ','g')),8) ||'",'|| /*Регистрационен номер*/  
       '"'||rpadc(REGEXP_REPLACE(t.acquire_from,'[,""]',' ','g'),20) ||'",'|| /*Начин на придобиване*/                  
       rpadc(to_char(t.gain_date,'yyyymmdd'),8) ||','|| /*Дата на придобиване*/  
       '"'||rpadc(REGEXP_REPLACE(t.acquiredoc,'[,""]',' ','g'),20) ||'",'|| /*Документ за придобиване*/                  
       '"'||rpadc(case coalesce(t.bck,0) when 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за ПС – собственост на БЧК(‘1’-да,’ ‘-не)*/  
       '"'||rpadc(to_char(t.paidpodate,'mmyyyy'),6) ||'",'|| /*Месец и година, до когато е платен данък в/у ПС от предишния собственик*/                        
       '"'||rpadc(case   
                /*  when nvl(t.errordata,1) = 1 then '1'  
                  when t.errordata = 0 then '2'*/  
   		        when t.carstatus = '1' and td.docstatus = '90' then '5'    
			        when t.carstatus = '2' and td.docstatus = '90' then '6'   
			        when t.carstatus = '3' and td.docstatus = '90' then '7' 
			        else case when td.docstatus = '30' then '1' else '2' end end 		
             ,1) ||'",'|| /*Индикатор за състояние  
                      ‘1’,’ ‘- валидна декларация  
                      ‘2’- невалидна декларация  
                      ‘5’-продадено ПС  
                      ‘6’- унищожено ПС  
                      ‘7’-откраднато ПС  
                      */         
       '"'||rpadc(to_char(case when td.docstatus = '90' then td.endtaxdate else null end,'mmyyyy'),6) ||'",'|| /*Краен месец и година за облагане*/                        
       lpadc(case when td.docstatus = '90' then  
		           case when to_char(td.earn_date,'yyyy') < to_char(td.close_date,'yyyy') then to_char(coalesce(td.close_date,td.change_date),'mm')::integer 
		                when to_char(td.earn_date,'yyyy') = to_char(td.close_date,'yyyy') then  
		                case when to_char(td.close_date,'mm')::integer - to_char(td.earn_date,'mm')::integer = 0 then 1  
		                     else to_char(td.close_date,'mm')::integer - to_char(td.earn_date,'mm')::integer end  
		                when coalesce(to_char(td.earn_date,'yyyy'),'0') = '0' then to_char(coalesce(td.close_date,td.change_date),'mm')::integer  
		                else 0  
	               end 
		           when td.docstatus = '30' and to_char(td.earn_date,'yyyy') < to_char(current_date,'yyyy') then 12  
		           when td.docstatus = '30' and to_char(td.earn_date,'yyyy') = to_char(current_date,'yyyy') then 12 - to_char(td.earn_date,'mm')::integer + 1 
		           when td.docstatus = '30' and coalesce(to_char(td.earn_date,'yyyy'),'0') = '0' then 12    
		      end 
       ,2) ||','|| /*Брой месеци за облагане през последната година, в която ПС се облага*/                           
       '"'||rpadc(REGEXP_REPLACE(rr.reason_text,'[,""]',' ','g'),15) ||'",'|| /*Основание за облагане “до”*/  
       lpadc(t.power_kw,4) ||','|| /*Мощност в kW*/  
       rpadc(to_char(td.user_date,'yyyymmdd'),8) || /*Дата на последна корекция*/  
       CHR(13) || CHR(10)  imor_row  
  from Taxdoc td 
  join Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
  join Taxobject tbj on tbj.taxobject_id = td.taxobject_id
  left join Address a on a.address_id = tbj.address_id
 
  join Transport t on t.taxdoc_id = td.taxdoc_id
  left join Transpmeansreg tmr on tmr.transpmeansreg_id = t.transpmeansreg_id
  left join Carreg cr on cr.carreg_id = t.carreg_id
  left join Carmodel cmd on cmd.carmodel_id = cr.carmodel_id
  left join Carmark cm on cm.carmark_id = cmd.carmark_id
  left join Taxsubject fts on fts.taxsubject_id = t.from_taxsubject_id
  left join Reasonreg rr on rr.reasonreg_id = td.close__reasonreg_id
 
  join Municipality m on m.municipality_id = td.municipality_id 
 where td.documenttype_id in (28,29) 
   and td.docstatus in ('30','90')
   and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
               else max(n.extractdate) end
          from napfilehistory n 
         where substr(n.filename,1,2) = 'P2' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
   and coalesce(td.user_date,td.doc_date) <= current_date 
   and td.municipality_id = $1
   and coalesce(trim(td.partidano),'') != '' 
 order by rpadc(ts.idn,10),row_number() over (partition by ts.idn),t.regno
$function$
;
