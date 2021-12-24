DROP FUNCTION  IF EXISTS  napdata.so(numeric); 
CREATE OR REPLACE FUNCTION napdata.so(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
Select 
        '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
        '"'||rpadc(td.partidano,17) ||'",'|| /*Партиден номер*/
        '"'||rpadc(pp.seqnots,3) ||'",'|| /*Последователен номер на собственик*/ 
        '"'||rpadc(REGEXP_REPLACE(pp.name,'[,""]',' ','g'),50) ||'",'|| /*Име на собственик*/  
        '"'||rpadc(case ts.isperson when 1 then '1'  
                                     when 0 then '2'  
                                     else ' ' end ,1) ||'",'|| /*Индикатор за ДЗЛ (1-ЕГН, 2-ЮЛ, ' ' - чужденец)*/  
        '"'||rpadc(ts.idn,10) ||'",'|| /*ЕГН, БУЛСТАТ (Служебен номер на НАП) в зависимост от индикатора*/  
        '"'||rpadc(case ts.kind_idn when '11' then ts.idn else ' ' end ,15) ||'",'|| /*Осигурителен номер (за чужденец)*/  
        '"'||rpadc(max(case ts.kind_idn when '11' then (select c.code from Country c where c.country_id=a.country_id) else ' ' end) ,2) ||'",'|| /*Код държава (за осиг.номер на чужденец)*/  
        '"'||rpadc(max(city.ekatte) ,5) ||'",'|| /*Адрес : Код населено място*/  
        '"'||rpadc(max(REGEXP_REPLACE(city.name,'[,""]',' ','g')) ,25) ||'",'|| /*Адрес : Име населено място*/  
        '"'||rpadc(max(adm.code),2) ||'",'|| /*Адрес : код район за София,Пловдив и Варна*/ 
        '"'||rpadc(max(case when str.kind_street = '8' then REGEXP_REPLACE(str.name,'[,""]',' ','g') else ' ' end),15) ||'",'|| /*Адрес : махала*/  
        '"'||rpadc(max(str.ekkpa),5) ||'",'|| /*Адрес : код улица*/  
        '"'||rpadc(max(REGEXP_REPLACE(str.name,'[,""]',' ','g')),30) ||'",'|| /*Адрес : име улица*/  
        '"'||rpadc(max(REGEXP_REPLACE(con.shortname,'[,""]',' ','g')),2) ||'",'|| /*Адрес : Държава*/  
        '"'||rpadc(REGEXP_REPLACE(a.nom,'[,""]',' ','g'),4) ||'",'|| /*Адрес : номер */  
        '"'||rpadc(REGEXP_REPLACE(a.entry,'[,""]',' ','g'),2) ||'",'|| /*Адрес : вход*/  
        '"'||rpadc(REGEXP_REPLACE(a.floor,'[,""]',' ','g'),2) ||'",'|| /*Адрес : етаж*/  
        '"'||rpadc(REGEXP_REPLACE(a.apartment,'[,""]',' ','g'),3) ||'",'|| /*Адрес : апартамент*/ 
        '"'||rpadc(REGEXP_REPLACE(ts.telefon,'[,""]',' ','g'),15) ||'",'|| /*Телефон*/
        to_char(max(coalesce(
                  (select sum(dpp1.sumval)
                       from Debtsubject ds1
                       join Debtpartproperty dpp1 on dpp1.debtsubject_id = ds1.debtsubject_id
                      where ds1.document_id = td.taxdoc_id
                        and ds1.doccode = ds.doccode
                        and ds1.kinddebtreg_id = ds.kinddebtreg_id
                        and ds1.kindparreg_id = ds.kindparreg_id 
                        and ds1.taxperiod_id = ds.taxperiod_id                       
                        and ds1.taxsubject_id = pp.taxsubject_id 
                        and ds1.debtsubject_id = (select max(dss.debtsubject_id) from debtsubject dss 
                                                   where dss.document_id = ds1.document_id 
                                                     and coalesce (dss.typecorr,'0') != '2' 
                                                     and dss.kinddebtreg_id = ds1.kinddebtreg_id 
                                                     and dss.taxsubject_id = ds1.taxsubject_id  
                                                     and dss.kindparreg_id = ds1.kindparreg_id)                                                 
               ),0)),'99999999990.99') ||','|| /*Данъчна оценка за текущата година за определяне на данък недвижими имоти*/
        to_char(max(coalesce((select sum(coalesce(ds1.totaltax,0)) 
                    from Debtsubject ds1 
                   where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and ds1.kinddebtreg_id = ds.kinddebtreg_id
                     and ds1.kindparreg_id = 2
                    ),0)),'99999990.99') ||','|| /*Данък недвижими имоти за текущата година*/
        to_char(max(coalesce((
                    select sum(coalesce(pdt1.payinstsum,0))
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null 
                   where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and ds1.kindparreg_id = 2
                    and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                    and extract(year from pd1.paydate) = extract(year from current_date)),0)) + sum(coalesce(opd.operoversum,0)) 
                ,'99999990.99') ||','|| /*Вноска Данък недвижими имоти за текущата година*/  
        to_char(max(coalesce((select sum(coalesce(pdt1.paydiscsum,0)) 
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null 
                   where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                    and extract(year from pd1.paydate) = extract(year from current_date)),0)) + sum(coalesce(opd.discsum,0)) 
                ,'99999990.99') ||','|| /*Отстъпка за Данък недвижими имоти за текущата година*/  
        to_char(max(coalesce((select sum(dpp1.sumval)
                   from Debtsubject ds1
                   join Debtpartproperty dpp1 on dpp1.debtsubject_id = ds1.debtsubject_id
                                             and dpp1.typedeclar = '1'
                  where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and ds1.kinddebtreg_id = ds.kinddebtreg_id
                    and ds1.taxperiod_id = (select max(tp.taxperiod_id) from taxperiod tp where extract(year from tp.begin_date) = extract(year from current_date))
                   and coalesce(ds1.corrno, 0) =
                                                  (select max(coalesce(ds_.corrno, 0))
                                                    from   debtsubject ds_
                                                    where  ds_.document_id = td.taxdoc_id
                                                    and    ds_.taxsubject_id = ds.taxsubject_id
                                                    and    coalesce(ds_.typecorr, '0') != '2')                                           
                    ),0)),'999999990.99') ||','|| /*Данъчна оценка на собствеността за текущата година*/  
        to_char(max(coalesce((select sum(coalesce(bdi1.interestsum,0) + 
                     coalesce(sanction_pkg.tempint(di1.debtinstalment_id,trunc(current_date)),0))
                    from Debtsubject ds1 
                    join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                    join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id
                   where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and ds1.kinddebtreg_id = ds.kinddebtreg_id
                     and ds1.kindparreg_id in (2,3)
                    ),0)),'99999990.99') ||','|| /*Лихва данък върху недвижими имоти */  
        to_char(max(coalesce((select sum(coalesce(pdt1.payinterestsum,0))
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null
                  where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                    and extract(year from pd1.paydate) = extract(year from current_date)      
                 ),0)),'99999990.99') ||','|| /*Вноска Лихва данък върху недвижими имоти */  
        to_char(max(coalesce((select sum(coalesce(case when extract(year from pd1.paydate) = extract(year from current_date) then di1.instsum else 0 end,0))
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   --join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id za ostatyka
                   join Paydebt pdt on pdt.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt.paydocument_id and pd1.null_userdate is null
                  where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and ds1.kinddebtreg_id = ds.kinddebtreg_id
                    and ds1.kindparreg_id = 3                                
             ),0)),'99999990.99') ||','|| /*Недобор данък недвижими имоти за минали години*/ 
        to_char(max(coalesce((select sum(coalesce(pdt1.payinstsum,0))
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                  where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                    and pdt1.kindparreg_id = 3
             ),0)),'99999990.99') ||','|| /*Вноска Недобор данък недвижими имоти за минали години*/  
        '"'||rpadc(case when (td.decl14to17 = '1') and (td17.taxdoc_id is not null) then REGEXP_REPLACE(td17.docno,'[,""]',' ','g') end,8) ||'",'|| /*Входящ номер на съответната декларация по чл.17 от ЗМДТ*/
        rpadc(case when (td.decl14to17 = '1') and (td17.taxdoc_id is not null) then to_char(td17.doc_date,'yyyymmdd') end,8) ||','|| /*Дата на входящ номер на съответната декларация по чл.17 от ЗМДТ*/
        '"'||' '||'",'|| /*Индикатор за активност на записа*/  
        rpadc(to_char(td.user_date,'yyyymmdd'),8) || /*Дата на последна корекция*/  
        CHR(13) || CHR(10)  imor_row  
   from Taxdoc td 
   join Debtsubject ds on ds.document_id = td.taxdoc_id 
                      and ds.kinddebtreg_id = 2
                      and ds.kindparreg_id = 2
   join Property p on p.taxdoc_id = td.taxdoc_id
   join Partproperty pp on pp.property_id = p.property_id
                       and pp.taxsubject_id = ds.taxsubject_id
   join Taxsubject ts on  ts.taxsubject_id = pp.taxsubject_id
   join Address a on coalesce(ts.permanent_clientaddr_id, ts.present_clientaddr_id) = a.address_id
   left join Street str on str.street_id = a.street_id
   join City city on city.city_id = a.city_id
   left join Admregion adm on adm.admregion_id = a.admregion_id
   join Country con on con.country_id = a.country_id
  
   join Municipality m on m.municipality_id = td.municipality_id
   left join Debtinstalment di on di.debtsubject_id = ds.debtsubject_id
   left join ( select odt.debtinstalment_id, odt.operoversum, odt.discsum, op.municipality_id
                from Operdebt odt
                join Operation op on op.operation_id = odt.operdebt_id
               where extract(year from op.oper_date) = extract(year from current_date) and op.opercode = '22' and op.null_userdate is null 
             ) opd on opd.debtinstalment_id = di.debtinstalment_id and opd.municipality_id = td.municipality_id
  -- connect 14 to 17
   left join Firm_1417 frm1417 on frm1417.taxdoc_id_14 = td.taxdoc_id
   left join Taxdoc td17 on td17.taxdoc_id = frm1417.taxdoc_id_17
  where td.documenttype_id = 21   
    and td.docstatus in ('30','90')
    and pp.typedeclar = '1'
    and coalesce(td.decl14to17,0) != 1  
    and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                else max(n.extractdate) end
           from napfilehistory n 
          where substr(n.filename,1,2) = 'SO' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
    and coalesce(td.user_date,td.doc_date) <= current_date 
    and td.municipality_id = $1 
    and coalesce(trim(td.partidano),'') != '' 
    --and ts.idn = '5102207026'
  Group by
      m.old_code,
      td.partidano,  
      pp.seqnots,  
      pp.name,
      case ts.isperson when 1 then '1'  
                     when 0 then '2'  
                     else ' ' end ,
      ts.idn,
      case ts.kind_idn when '11' then ts.idn else ' ' end, 
      a.nom,  
      a.entry,  
      a.floor,  
      a.apartment, 
      ts.telefon,
      case when (td.decl14to17 = '1') and (td17.taxdoc_id is not null) then REGEXP_REPLACE(td17.docno,'[,""]',' ','g') end,
      case when (td.decl14to17 = '1') and (td17.taxdoc_id is not null) then to_char(td17.doc_date,'yyyymmdd') end,
      to_char(td.user_date,'yyyymmdd')
  Order by td.partidano, to_number(REGEXP_REPLACE(trim(pp.seqnots),'\D+',''))
$function$
;
