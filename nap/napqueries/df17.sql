DROP SCHEMA  if exists napdata cascade;
CREATE SCHEMA napdata;

DROP FUNCTION  IF EXISTS  napdata.df17(numeric); 
CREATE OR REPLACE FUNCTION napdata.df17(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
 select sub.imor_row  from (        
  Select ts.idn, td.partidano,
        '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/
        '"'||rpadc(ts.idn,10) ||'",'|| /*БУЛСТАТ/Служебен номер на НАП*/  
        '"'||rpadc(REGEXP_REPLACE(ts.name,'[,''""]+',' ','g'),60) ||'",'|| /*Наименование*/  
        '"'||rpadc(REGEXP_REPLACE(td.partidano,'[,''""]+',' ','g'),8) ||'",'|| /*Вх.номер на декларация*/  
        rpadc(to_char(td.doc_date,'yyyymmdd'),8) ||','|| /*Дата на декларацията*/  
        '"'||rpadc(REGEXP_REPLACE(td.docno,'[,''""]+',' ','g'),15) ||'",'|| /*Пълен вх.номер на декларацията*/  
        rpadc(to_char(td.doc_date,'yyyymmdd'),8) ||','|| /*Дата на пълен вх.номер*/  
        '"'||rpadc(REGEXP_REPLACE(td.partidano,'[,''""]+',' ','g'),17) ||'",'|| /*Партиден номер*/  
        to_char(max(coalesce((select sum(coalesce(ds1.totaltax,0)) 
                    from Debtsubject ds1 
                   where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and ds1.kinddebtreg_id = ds.kinddebtreg_id
                     and ds1.kindparreg_id = ds.kindparreg_id
                     and ds1.taxperiod_id = ds.taxperiod_id                        
                    ),0)),'9999999999990.99') ||','|| /*Изчислен данък недвижими имоти*/
        to_char(max(coalesce((
                    select sum(coalesce(pdt1.payinstsum,0)+coalesce(opd.operoversum,0))
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null 
                   where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and ds1.kindparreg_id = ds.kindparreg_id
                    and ds1.kinddebtreg_id = ds.kinddebtreg_id
                    and extract(year from pd1.paydate) = extract(year from current_date)
                   ),0)),'9999999999990.99') ||','|| /*Вноска Данък недвижими имоти за текущата година*/
        to_char(max(coalesce((select sum(coalesce(pdt1.paydiscsum,0)+coalesce(opd.discsum,0)) 
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null 
                   where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                    and extract(year from pd1.paydate) = extract(year from current_date)                     
                    ),0)),'9999999999990.99') ||','|| /*Отстъпка за Данък недвижими имоти за текущата година*/      
        to_char(max(coalesce((select sum(coalesce(bdi1.interestsum,0) + 
                     coalesce(sanction_pkg.tempint(di1.debtinstalment_id,trunc(current_date)),0))
                    from Debtsubject ds1 
                    join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                    join Baldebtinst bdi1 on bdi1.debtinstalment_id = di1.debtinstalment_id
                   where ds1.document_id = td.taxdoc_id
                     and ds1.taxsubject_id = ds.taxsubject_id
                     and ds1.kinddebtreg_id = ds.kinddebtreg_id
                     and ds1.kindparreg_id in (2,3)
                    ),0)),'9999999999990.99') ||','|| /*Лихва данък върху недвижими имоти */  
        to_char(max(coalesce((select sum(coalesce(pdt1.payinterestsum,0))
                   from Debtsubject ds1 
                   join Debtinstalment di1 on di1.debtsubject_id = ds1.debtsubject_id 
                   join Paydebt pdt1 on pdt1.debtinstalment_id = di1.debtinstalment_id
                   join PayDocument pd1 on pd1.paydocument_id = pdt1.paydocument_id and pd1.null_userdate is null
                  where ds1.document_id = td.taxdoc_id
                    and ds1.taxsubject_id = ds.taxsubject_id
                    and pdt1.kinddebtreg_id = ds.kinddebtreg_id
                    and extract(year from pd1.paydate) = extract(year from current_date)      
                 ),0)),'9999999999990.99') ||','|| /*Вноска Лихва данък върху недвижими имоти */
        --'"'||rpadc(to_char(p.taxprop_calc,'999999999990.99'),16) ||','|| /*Деклариран данък недвижими имоти*/  
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
   /* address*/  
        '"'||rpadc(max(city.ekatte),5) ||'",'|| /*Адрес на имота:код нас.място*/  
        '"'||rpadc(max(adm.code),2) ||'",'|| /*Адрес на имота:код район*/  
        '"'||rpadc(max(str.ekkpa),5) ||'",'|| /*Адрес на имота:код улица*/  
        '"'||rpadc(max(REGEXP_REPLACE(str.name,'[,''""]+',' ','g')),30) ||'",'|| /*Адрес на имота:име улица*/  
        '"'||rpadc(REGEXP_REPLACE(a.nom,'[,''""]+',' ','g'),4) ||'",'|| /*Адрес на имота:номер*/  
        '"'||rpadc(REGEXP_REPLACE(a.entry,'[,''""]+',' ','g'),2) ||'",'|| /*Адрес на имота:вход*/  
        '"'||rpadc(REGEXP_REPLACE(a.apartment,'[,''""]+',' ','g'),3) ||'",'|| /*Адрес на имота:апартамент*/  
        '"'||rpadc(REGEXP_REPLACE(a.floor,'[,''""]+',' ','g'),2)  ||'",'|| /*Адрес на имота:етаж*/  
   /* property*/  
        '"'||rpadc(to_char(p.kindproperty),1) ||'",'|| /*Вид имот имот ('1'-земя, '2'-сграда(и), '3'-земя и сграда(и))*/   
        '"'||rpadc(REGEXP_REPLACE(case when str.kind_street = '7' then str.name else ' ' end,'[,''""]+',' ','g'),4) ||'",'|| /*Квартал*/  
        '"'||rpadc(REGEXP_REPLACE(p.zrpno_parcel,'[,''""]+',' ','g'),11) ||'",'|| /*УПИ (парцел)*/  
        '"'||rpadc(to_char(p.zrp_date,'yyyy'),4) ||'",'|| /*Година на одобряване на ЗРП*/  
        '"'||rpadc(REGEXP_REPLACE(p.kadastrno,'[,''""]+',' ','g'),6) ||'",'|| /*Планоснимачен номер*/  
        '"'||rpadc(REGEXP_REPLACE(p.kadastr_year,'[,''""]+',' ','g'),4) ||'",'|| /*Година на одобряване на кадастрален план*/  
        '"'||rpadc(REGEXP_REPLACE(p.earnway,'[,''""]+',' ','g'),20) ||'",'|| /*Начин на придобиване*/  
        '"'||rpadc(REGEXP_REPLACE(p.propertydoc,'[,''""]+',' ','g'),20) ||'",'|| /*Вид документ за собственост*/  
        '"'||rpadc(REGEXP_REPLACE(p.propertydocno,'[,''""]+',' ','g'),17) ||'",'|| /*Номер документ за собственост*/  
        rpadc(to_char(p.propertydoc_date,'yyyymmdd'),8) ||','|| /*Дата на документа за собственост*/  
        rpadc(to_char(p.propertydoc_date,'yyyymmdd'),8) ||','|| /*Дата на придобиване*/  
        '"'||rpadc(REGEXP_REPLACE(p.note,'[,''""]+',' ','g'),20) ||'",'|| /*Допълнителна информация*/  
        '"'||rpadc(case when p.old_taxsubject_id is not null then ts1.idn 
                         when p.owner_taxsubject_id is not null then ts2.idn
                         else ' ' end,10) ||'",'||  /*ЕГН/БУЛСТАТ/Служебен номер на предишния собственик или на настоящия собственик при учредено право на ползване */  
        '"'||rpadc(case when p.old_taxsubject_id is not null then case ts1.isperson when 1 then '1' when 0 then '2' end    
                         when p.owner_taxsubject_id is not null then case ts2.isperson when 1 then '1' when 0 then '2' end   
                         else ' ' end,1) ||'",'||  /*Индикатор за предишния собственик/наст.собственик при учредено право на ползване(’1’- ФЛ, ‘2’- ЮЛ)*/  
        '"'||rpadc(case when p.old_taxsubject_id is not null then REGEXP_REPLACE(ts1.name,'[,''""]+',' ','g') 
                         when p.owner_taxsubject_id is not null then REGEXP_REPLACE(ts2.name,'[,''""]+',' ','g')
                         else ' ' end,40) ||'",'|| /*Име на предишния собственик или на настоящия собственик при учредено право на ползване*/  
        '"'||rpadc(td.kinddecl ,1) ||'",'|| /*Идентификатор за декларатора (‘1’-собственик,‘2’–ползвател,’3’-концесионер,'4'-управляващ имот държавна или общ.собственост)*/  
        '"'||rpadc(case when p.old_taxsubject_id is not null and coalesce(p.taxdate_oldprop,'') != '' then  
                         left(p.taxdate_oldprop,-4)||left(p.taxdate_oldprop,2) else ' ' end,6) ||'",'|| /*Месец и година, докогато е платен данък недвижими имоти в годината на придобиване от предишен собственик*/  
        rpadc(to_char(td.user_date,'yyyymmdd'),8) || /*Дата на последна корекция*/  
        CHR(13) || CHR(10)  imor_row  
   from Taxdoc td 
   join Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
   join Taxobject tobj on tobj.taxobject_id = td.taxobject_id
   join Address a on a.address_id = tobj.address_id
   join Street str on str.street_id = a.street_id
   join City city on city.city_id = a.city_id
   left join Admregion adm on adm.admregion_id = a.admregion_id
   left join FirmProperty p on p.taxdoc_id = td.taxdoc_id
   left join Taxsubject ts1 on ts1.taxsubject_id = p.old_taxsubject_id 
   left join Taxsubject ts2 on ts2.taxsubject_id = p.owner_taxsubject_id 
   left join Firm_1417 f1417 on f1417.taxdoc_id_17 = td.taxdoc_id and f1417.taxdoc_id_14 is null 
   join Municipality m on m.municipality_id = td.municipality_id
   join Debtsubject ds on ds.document_id = td.taxdoc_id
                      --and ds.doccode = '17'
                      and ds.kinddebtreg_id = 2
                      and ds.kindparreg_id = 2 
   join Debtinstalment di on di.debtsubject_id = ds.debtsubject_id
   left join ( select odt.debtinstalment_id, odt.operoversum, odt.discsum, op.municipality_id
                from Operdebt odt
                join Operation op on op.operation_id = odt.operdebt_id
               where  extract(year from op.oper_date) = extract(year from current_date) and op.opercode = '22' and op.null_userdate is null 
             ) opd on opd.debtinstalment_id = di.debtinstalment_id and opd.municipality_id = td.municipality_id
  where td.documenttype_id = 22  
  --  and coalesce(p.ishome,0) = 0
    and td.docstatus in ('30','90')   
    and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                else max(n.extractdate) end
           from napfilehistory n 
          where substr(n.filename,1,2) = 'DF' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
    and coalesce(td.user_date,td.doc_date) <= current_date 
    and td.municipality_id = $1
    and coalesce(trim(td.partidano),'') != '' 
  group by 
        m.old_code,
        ts.idn,  
        ts.name,  
        td.partidano,  
        to_char(td.doc_date,'yyyymmdd'),  
        td.docno,  
        to_char(td.doc_date,'yyyymmdd'),  
        td.partidano,  
        to_char(coalesce(p.taxprop_decl,0),'9999999999990.99'),
   /* address*/  
        a.nom,
        a.entry,  
        a.apartment,  
        a.floor, 
        case when str.kind_street = '7' then str.name else ' ' end, 
   /* property*/  
        to_char(p.kindproperty),   
        p.zrpno_parcel,  
        to_char(p.zrp_date,'yyyy'),  
        p.kadastrno,  
        p.kadastr_year,  
        p.earnway,  
        p.propertydoc,  
        p.propertydocno,  
        to_char(p.propertydoc_date,'yyyymmdd'),  
        to_char(p.propertydoc_date,'yyyymmdd'),  
        p.note,  
        case when p.old_taxsubject_id is not null then ts1.idn 
                         when p.owner_taxsubject_id is not null then ts2.idn
                         else ' ' end,
        case when p.old_taxsubject_id is not null then case ts1.isperson when 1 then '1' when 0 then '2' end    
                         when p.owner_taxsubject_id is not null then case ts2.isperson when 1 then '1' when 0 then '2' end   
                         else ' ' end,  
        case when p.old_taxsubject_id is not null then REGEXP_REPLACE(ts1.name,'[,''""]+',' ','g') 
                         when p.owner_taxsubject_id is not null then REGEXP_REPLACE(ts2.name,'[,''""]+',' ','g')
                         else ' ' end,  
        rpadc(td.kinddecl ,1),
        case when p.old_taxsubject_id is not null and coalesce(p.taxdate_oldprop,'') != '' then  
                         left(p.taxdate_oldprop,-4)||left(p.taxdate_oldprop,2) else ' ' end,  
        to_char(td.user_date,'yyyymmdd')  
   order by 1,2 ) sub
$function$
;
