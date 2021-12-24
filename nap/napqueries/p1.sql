DROP FUNCTION  IF EXISTS  napdata.p1(numeric); 
CREATE OR REPLACE FUNCTION napdata.p1(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 select    
       '"'||rpadc(max(m.old_code),4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
       '"'||rpadc(REGEXP_REPLACE(max(td.docno),'[,""]',' ','g'),16) ||'",'|| /*Входящ номер на декларация по чл.54*/   
       rpadc(to_char(max(td.doc_date),'yyyymmdd'),8) ||','|| /*Дата на декларация*/   
       '"'||rpadc(ts.idn,10) ||'",'|| /*ЕГН/БУЛСТАТ/Служебен номер на НАП/ЛНЧ*/   
       '"'||case when ts.kind_idn = '10' then '1' 
                 when ts.kind_idn = '21' then '2'  
                 when ts.kind_idn = '11' then '3' 
            else ' ' end ||'",'|| /*Индикатор(‘1’-ЕГН, ‘2’-ЮЛ, ’3’-ЛНЧ)*/    
       '"'||rpadc(REGEXP_REPLACE(ts.name,'[,""]',' ','g'),50) ||'",'|| /*Име на лицето*/   
       '"'||rpadc(max(tmr.code),2) ||'",'|| /*Вид ПС*/   
       to_char(coalesce(max(t.loading_capacity),0),'999990.999') ||','|| /*Товароносимост*/   
       to_char(coalesce(max(t.tonnage),0),'999990.999') ||','|| /*Товароподемност*/   
       '"'||rpadc(max(cm.mark_code),3) ||'",'|| /*Код марка на ПС*/   
       '"'||rpadc(max(cm.mark_name),20) ||'",'|| /*Наименование на марка на ПС*/ 
       '"'||rpadc(max(cmd.model_code),3) ||'",'|| /*Код модел на ПС10*/   
       '"'||rpadc(max(cmd.model_name),20) ||'",'|| /*Наименование на модел на ПС*/ 
       '"'||rpadc(REGEXP_REPLACE(coalesce(max(t.tmodify),' '),'[,""]',' ','g'),30) ||'",'|| /*Модификация*/  
       '"'||rpadc(case max(t.kind_fuel) when '1' then 'Б'   
                              when '2' then 'Д'   
                              when '3' then 'Г' else ' ' end ,1) ||'",'|| /*Вид гориво(„Б”-бензин, „Д”-дизел, „Г”-газ, ‘ ‘*/   
       lpadc(to_char(coalesce(max(t.motor_capacity),0),'999990'),6) ||','|| /*Обем на двигателя*/   
       lpadc(case when max(tmr.code) in ('01','11','07','09','36','10','37') then to_char(coalesce(max(t.horsepower),0),'FM9000')    
                  when max(tmr.code) in ('08','05') then to_char(coalesce(max(t.weigth_total),0),'FM99000') 
  		           when max(tmr.code) = '03' then to_char(coalesce(max(t.motor_capacity),0),'FM9000') 
			       when max(tmr.code) = '04' and (max(t.motor_capacity) <= 999) then to_char(coalesce(max(t.motor_capacity),0),'FM9000')  
			       when max(tmr.code) = '04' and (max(t.motor_capacity) > 999) then to_char(max(999),'FM9000')  
                  when max(tmr.code) = '06' then REGEXP_REPLACE(coalesce(max(t.seat_number),'0'),'[,""]',' ','g') 
             else '0' 
             end,3) ||','|| /*- Мощност к.с за лек автомобил,трактор,товарен автомобил, влекач,специализирана строителна машина,ремарке над 40т- кг за ремарке на лек автомобил, триколка- куб.см за мотопед до 50 куб.см, мотоциклет- брой места за автобус*/    
       '"'||rpadc(trim(max(t.firstreg_year)),4) ||'",'|| /*Година на първа регистрация*/ 
       '"'||rpadc(trim(max(t.produce_year)),4) ||'",'|| /*Година на производство*/
       to_char(max(t.maxpossible_mass),'999990.999') ||','|| /*Технически допустима максимална маса20*/
       --to_char(max(t.weigth_total),'999990.999') ||','|| /*Общо тегло*/
       '"'||rpadc(upper(REGEXP_REPLACE(t.regno,'[,""]',' ','g')),8) ||'",'|| /*21Регистрационен номер*/   
       '"'||rpadc(max(rdvr.code),2) ||'",'|| /*22Код РПУ*/   
       '"'||rpadc(REGEXP_REPLACE(max(t.ramano),'[,""]',' ','g'),20) ||'",'|| /*Номер шаси*/   
       '"'||rpadc(REGEXP_REPLACE(max(t.motorno),'[,""]',' ','g'),20) ||'",'|| /*Номер двигател*/
       '"'||rpadc(REGEXP_REPLACE(max(t.acquire_from),'[,""]',' ','g'),20) ||'",'|| /*25Начин на придобиване*/   
       rpadc(to_char(max(t.gain_date),'yyyymmdd'),8) ||','|| /*26Дата на придобиване*/   
       '"'||rpadc(REGEXP_REPLACE(max(t.acquiredoc),'[,""]',' ','g'),20) ||'",'|| /*27Документ за придобиване*/ 
       '"'||rpadc(REGEXP_REPLACE(max(t.custhentryno),'[,""]',' ','g'),10) ||'",'|| /*28Номер митническа декларация*/   
     --  '"'||rpadc(REGEXP_REPLACE(t.acquiredoc,'[,""]',' ','g'),10) ||'",'|| /*Номер митническа декларация*/  
       rpadc(to_char(max(t.custhentry_date),'yyyymmdd'),8) ||','|| /*29Дата на митническа декларация*/ 
       '"'||rpadc(case when coalesce(max(t.eco_motor),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*30Индикатор за наличие на екодвигател(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case when coalesce(max(t.public_transport),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*31Индикатор за извършване на обществен транспорт(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case when coalesce(max(t.amb_car),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за линейка/пожарна(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case when coalesce(max(t.budget),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за ПС на държ./общ.орган със специален режим на движение(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case when coalesce(max(t.diplomat),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за ПС на дипломатическо/консулско представителство(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case when coalesce(max(t.bck),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за ПС – собственост на БЧК(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case when coalesce(max(t.katalizator),0) = 1 then '1' else ' ' end ,1) ||'",'|| /*Индикатор за наличие на катализатор(‘1’-да,’ ‘-не)*/   
       '"'||rpadc(case    
                /*  when coalesce(t.errordata,1) = 1 then '1'   
                    when t.errordata = 0 then '2' */   
   		        when max(t.carstatus) = '1' and max(td.docstatus) = '90' then '5'    
			        when max(t.carstatus) = '2' and max(td.docstatus) = '90' then '6'   
			        when max(t.carstatus) = '3' and max(td.docstatus) = '90' then '7' 
			        else case when max(td.docstatus) = '30' then '1' else '2' end end 		
             ,1) ||'",'|| /*Индикатор за състояние 
                      ‘1’,’ ‘- валидна декларация   
                      ‘2’- невалидна декларация   
                      ‘5’-продадено ПС   
                      ‘6’- унищожено ПС   
                      ‘7’-откраднато ПС   
                      */          
       '"'||rpadc(to_char(max(case when td.docstatus = '90' then td.endtaxdate else null end),'mmyyyy'),6) ||'",'|| /*Краен месец и година за облагане*/                         
       '"'||rpadc(case fts.kind_idn when '10' then fts.idn end,10) ||'",'|| /*ЕГН на предишния собственик*/
       '"'||rpadc(case fts.kind_idn when '21' then fts.idn end,10) ||'",'|| /*40БУЛСТАТ/Служебен номер на НАП на предишния собственик*/   
       '"'||rpadc(fts.name,34) ||'",'|| /*Име на предишния собственик*/   
       '"'||rpadc(to_char(max(t.paidpodate),'mmyyyy'),6) ||'",'|| /*Месец и година, до когато е платен данък в/у ПС от предишния собственик*/                         
       lpadc(case when max(td.docstatus) = '90' then  
		           case when to_char(max(td.earn_date),'yyyy') < to_char(max(td.close_date),'yyyy') then to_char(max(coalesce(td.close_date,td.change_date)),'mm')::integer 
		                when to_char(max(td.earn_date),'yyyy') = to_char(max(td.close_date),'yyyy') then  
		                case when to_char(max(td.close_date),'mm')::integer - to_char(max(td.earn_date),'mm')::integer = 0 then 1  
		                     else to_char(max(td.close_date),'mm')::integer - to_char(max(td.earn_date),'mm')::integer end  
		                when coalesce(to_char(max(td.earn_date),'yyyy'),'0') = '0' then to_char(max(coalesce(td.close_date,td.change_date)),'mm')::integer  
		                else 0  
	               end 
		           when max(td.docstatus) = '30' and to_char(max(td.earn_date),'yyyy') < to_char(current_date,'yyyy') then 12  
		           when max(td.docstatus) = '30' and to_char(max(td.earn_date),'yyyy') = to_char(current_date,'yyyy') then 12 - to_char(max(td.earn_date),'mm')::integer + 1 
		           when max(td.docstatus) = '30' and coalesce(to_char(max(td.earn_date),'yyyy'),'0') = '0' then 12    
		      end 
       ,2) ||','|| /*Брой месеци за облагане през последната година, в която ПС се облага*/                           
       '"'||rpadc(max(case when td.docstatus = '90' then (select d.value from decode d where upper(d.columnname)='CARSTATUS' and d.code = t.carstatus) 
                            else ' ' end),15) ||'",'|| /*Основание за облагане “до”*/   
       to_char(max(t.max_mass),'999990.99') ||','|| /*45Допустима максимална маса за товарни автомобили над 12 т*/   
       rpadc(coalesce(max(t.axes_number),0),1) ||','|| /*Брой оси*/   
       '"'||rpadc(coalesce(max(t.kindhanging),' '),1) ||'",'|| /*Вид на окачването(1-пневматично, 2-друга система на окачване,’ ‘*/   
       lpadc(to_char(max(t.power_kw),'990'),3) ||','|| /*Мощност kW*/   
       to_char(max(t.max_mass_comp),'999990.999') ||','|| /*Допустима максимална маса на състав от превозни средства*/   
       '"'||rpadc(REGEXP_REPLACE(coalesce(max(t.regno_old),' '),'[,""]',' ','g'),8) ||'",'|| /*Стар регистрационен номер*/   
       rpadc(to_char(max(td.user_date),'yyyymmdd'),8) || /*Дата на последна корекция*/   
       CHR(13) || CHR(10)  imor_row   
  from Taxdoc td
  join Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
  join Transport t on t.taxdoc_id = td.taxdoc_id
  left join Rdvr on rdvr.rdvr_id = t.city_rdvr_id
  left join Transpmeansreg tmr on tmr.transpmeansreg_id = t.transpmeansreg_id
  left join Carreg cr on cr.carreg_id = t.carreg_id
  left join Carmodel cmd on cmd.carmodel_id = cr.carmodel_id
  left join Carmark cm on cm.carmark_id = cmd.carmark_id
  left join Taxsubject fts on fts.taxsubject_id = t.from_taxsubject_id
  left join Reasonreg rr on rr.reasonreg_id = td.close__reasonreg_id
  join Municipality m on m.municipality_id = td.municipality_id
 where td.documenttype_id in (26,27)
   and td.docstatus in  ('30','90')
   and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
               else max(n.extractdate) end
          from napfilehistory n 
         where substr(n.filename,1,2) = 'P1' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
   and coalesce(td.user_date,td.doc_date) <= current_date 
   and td.docstatus = case when td.docstatus = '90' and
                                   exists(select * from transport tr join taxdoc td1 on td1.taxdoc_id = tr.taxdoc_id 
                                           where tr.regno = t.regno 
                                             and td1.taxdoc_id != td.taxdoc_id 
                                             and td1.docstatus = '30') then '30' else td.docstatus end  		
   and td.municipality_id = $1
 group by 
       ts.idn,
       case when ts.kind_idn = '10' then '1' 
            when ts.kind_idn = '21' then '2'  
            when ts.kind_idn = '11' then '3' 
       else ' ' end,
       ts.name,    
       t.regno,
       case fts.kind_idn when '10' then fts.idn end,
       case fts.kind_idn when '21' then fts.idn end,   
       fts.name		
 order by rpadc(ts.idn,10), t.regno
$function$
;
