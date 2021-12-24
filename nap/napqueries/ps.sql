DROP FUNCTION  IF EXISTS  napdata.ps(numeric); 
CREATE OR REPLACE FUNCTION napdata.ps(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
   select    
          '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено*/   
          '"'||rpadc(ts.idn,10) ||'",'|| /*ЕГН/БУЛСТАТ/Служебен номер на НАП/ЛНЧ*/   
          '"'||case when ts.kind_idn = '10' then '1' 
                     when ts.kind_idn = '21' then '2'  
                     when ts.kind_idn = '11' then '3'  
                else ' ' end ||'",'|| /*Индикатор(‘1’-ЕГН, ‘2’-ЮЛ, ’3’-ЛНЧ)*/   
          '"'||rpadc(case when td.documenttype_id in (26,27) then upper(tbj.registerno)   
                else row_number() over (partition by ts.idn,td.documenttype_id order by max(td.taxdoc_id))::varchar end,8) ||'",'|| /*Регистрационен номер (за ППС) пореден номер (за въздухоплавателни и плавателни ПС)*/          
          '"'||rpadc(tmr.code,2) ||'",'|| /*Вид ПС*/   
          '"'||rpadc(case when td.documenttype_id in (28,29) then upper(tbj.registerno) else ' ' end,8) ||'",'|| /*Регистрационен номер на въздухоплавателно или плавателно средство*/          
          to_char(max(coalesce((select sum(coalesce(ds1.totaltax,0)) 
                     from Debtsubject ds1 
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and ds1.kinddebtreg_id = ds.kinddebtreg_id
                      and ds1.kindparreg_id = 2
                     ),0)),'99999990.99') ||','|| /*Задължение за Данък в/у ПС за текуща година*/
          to_char(max(coalesce((select sum(coalesce(pdt1.paydiscsum,0)) 
                    from Debtsubject ds1 
                    join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                    join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                    join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null 
                    where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                     and extract(year from pd1.paydate) = extract(year from current_date)),0)) + sum(coalesce(opd.discsum,0))
                 ,'9999990.99') ||','|| /*Отстъпка за данък в/у ПС*/   
          to_char(max(coalesce((select sum(coalesce(pdt1.payinstsum,0))
                    from Debtsubject ds1 
                    join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                    join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                    join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null 
                    where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                     and ds1.kindparreg_id = 2
                     and pd1.null_userdate is null
                     and extract(year from pd1.paydate) = extract(year from current_date)),0)) + sum(coalesce(opd.operoversum,0))
                 ,'99999990.99') ||','|| /*Вноска за Данък в/у ПС за текуща година */   
          to_char(max(coalesce((select sum(coalesce(bdi1.interestsum,0) + 
                      coalesce(sanction_pkg.tempint(di1.debtinstalment_id,trunc(current_date)),0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and ds1.kinddebtreg_id = ds.kinddebtreg_id
                      and ds1.kindparreg_id in (2,3)
                     ),0)),'99999990.99') ||','|| /*Задължение Лихва за данък в/у ПС */
          to_char(max(coalesce((select sum(coalesce(pdt1.payinterestsum,0))
                    from Debtsubject ds1 
                    join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                    join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                    join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null
                   where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                     and extract(year from pd1.paydate) = extract(year from current_date)      
                   ),0)),'99999990.99') ||','|| /*Вноска Лихва за данък в/у ПС */   
          to_char(max(coalesce((select sum(coalesce(case when extract(year from pd1.paydate) = extract(year from current_date) then di1.instsum else 0 end,0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     --join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id
                     join Paydebt pdt on pdt.debtinstalment_id = di1.debtinstalment_id
                     join PayDocument pd1 on pd1.paydocument_id = pdt.paydocument_id and pd1.null_userdate is null
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and ds1.kinddebtreg_id = ds.kinddebtreg_id
                      and ds1.kindparreg_id = 3  
               ),0)),'99999990.99') ||','|| /*Недобор за данък в/у ПС минали години*/   
          to_char(max(coalesce((select sum(coalesce(pdt1.payinstsum,0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                     join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                      and pdt1.kindparreg_id = 3
                      and extract(year from pd1.paydate) = extract(year from current_date)  
               ),0)),'99999990.99') ||','|| /*Вноска Недобор за данък в/у ПС минали години*/   
          to_char(max(coalesce((select sum(coalesce(case when extract(year from pd1.paydate) = extract(year from current_date) then di1.instsum else 0 end,0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     --join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id
                     join Paydebt pdt on pdt.debtinstalment_id = di1.debtinstalment_id
                     join PayDocument pd1 on pd1.paydocument_id = pdt.paydocument_id and pd1.null_userdate is null
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and ds1.kinddebtreg_id = 7
                      and ds1.kindparreg_id = 3                                
               ),0)),'99999990.99') ||','|| /*Недобор за пътен данък  минали години*/   
          to_char(max(coalesce((select sum(coalesce(pdt1.payinstsum,0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and pdt1.kinddebtreg_id = 7
                      and pdt1.kindparreg_id = 3
               ),0)),'99999990.99') ||','|| /*Вноска Недобор за пътен данък  минали години*/   
          to_char(max(coalesce((select sum(coalesce(bdi1.interestsum,0) + 
                      coalesce(sanction_pkg.tempint(di1.debtinstalment_id,trunc(current_date)),0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id
                    where ds1.document_id = td.taxdoc_id
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and ds1.kinddebtreg_id = 7
                      and ds1.kindparreg_id = 3                                
               ),0)),'99999990.99') ||','|| /*Задължение Лихва за недобор пътен данък*/   
          to_char(max(coalesce((select sum(coalesce(pdt1.payinterestsum,0))
                     from Debtsubject ds1 
                     join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                     join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                    where ds1.document_id = td.taxdoc_id
                      and ds1.kinddebtreg_id = 7   
                      and ds1.taxsubject_id = ds.taxsubject_id
                      and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                      and pdt1.kindparreg_id = 3
               ),0)),'99999990.99') ||','|| /*Вноска Лихва за недобор пътен данък */   
          rpadc(max(to_char(td.user_date,'yyyymmdd')),8) || /*Дата на последна корекция*/   
          CHR(13) || CHR(10)  imor_row   
     from Taxdoc td  
      join Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
      join Taxobject tbj on tbj.taxobject_id = td.taxobject_id
      left join Address a on a.address_id = tbj.address_id
      join Municipality m on m.municipality_id = td.municipality_id  
      join Debtsubject ds on ds.document_id = td.taxdoc_id 
                         --and ds.doccode = '54'
                         and ds.kinddebtreg_id = 4
                         --and ds.kindparreg_id = 2
      join Debtinstalment di on di.debtsubject_id = ds.debtsubject_id
      left join ( select odt.debtinstalment_id, odt.operoversum, odt.discsum, op.municipality_id
                    from Operdebt odt
                    join Operation op on op.operation_id = odt.operdebt_id
                   where extract(year from op.oper_date) = extract(year from current_date) and op.opercode = '22' and op.null_userdate is null                    
                 ) opd on opd.debtinstalment_id = di.debtinstalment_id and opd.municipality_id = td.municipality_id                     
      /*left join Operdebt opd on opd.debtinstalment_id = di.debtinstalment_id and opd.kinddebtreg_id = ds.kinddebtreg_id
      left join Operation op on op.operation_id = opd.operdebt_id 
                             and extract(year from op.oper_date) = extract(year from current_date)
                             and op.opercode = '22' and op.null_userdate is null 
                             and op.municipality_id = td.municipality_id*/
      join Transport t on t.taxdoc_id = td.taxdoc_id
      join Transpmeansreg tmr on tmr.transpmeansreg_id = t.transpmeansreg_id
     where td.documenttype_id in (26,27,28,29)
      and td.docstatus in ('30','90')
      and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                 else max(n.extractdate) end
            from napfilehistory n 
           where substr(n.filename,1,2) = 'PS' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
      and coalesce(td.user_date,td.doc_date) <= current_date 
      and td.docstatus = case when td.docstatus = '90' and
                                     exists(select * from taxobject tob1 join taxdoc td1 on td1.taxobject_id = tob1.taxobject_id 
                                             where tob1.registerno = tbj.registerno 
                                               and td1.taxdoc_id != td.taxdoc_id 
                                               and td1.docstatus = '30') then '30' else td.docstatus end  		
      and td.municipality_id = $1
    --  and ts.idn = '040221120'
    group by 
          m.old_code,   
          ts.idn,   
          ts.kind_idn,
          tbj.registerno,   
          td.documenttype_id,   
          tmr.code,   
          case when td.documenttype_id in (28,29) then tbj.registerno end   
    order by rpadc(ts.idn,10)||rpadc(case when td.documenttype_id in (26,27) then upper(tbj.registerno) else row_number() over (partition by ts.idn,td.documenttype_id order by max(td.taxdoc_id))::varchar end,8)
$function$
;
