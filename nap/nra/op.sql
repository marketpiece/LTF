DROP FUNCTION  IF EXISTS  napdata.op(numeric); 
CREATE OR REPLACE FUNCTION napdata.op(numeric)
 RETURNS SETOF text
 LANGUAGE sql
AS $function$
Select 
         '"'||rpadc(m.old_code,4) ||'",'|| /*Код структурно звено по местонахождение на имота*/  
         '"'||rpadc(td.partidano,17,' ') ||'",'|| /*Партиден номер*/        
         '"'||rpadc(REGEXP_REPLACE(td.docno,'[,""]+',' ','g'),16) ||'",'|| /*Вх.номер на декларацията по местонахождение на имота*/  
         rpadc(to_char(td.doc_date,'yyyymmdd'),8) ||','|| /*Дата на подаване на декларацията по местонахождение на имота*/  
         '"'||rpadc(ts.idn,10) ||'",'|| /*ЕГН/ЛНЧ/БУЛСТАТ/сл.номер на декларатора*/  
         '"'||rpadc(case ts.kind_idn when '11' then ts.idn end,15) ||'",'||  /*Осигурителен номер на декларатора (за чужденци)*/  
         '"'||rpadc((select c.shortname from address a1, country c where a1.country_id = c.country_id and a1.address_id = ts.permanent_clientaddr_id),2) ||'",'|| /*Код държава (за осиг.номер на чужденец)*/  
         '"'||rpadc(REGEXP_REPLACE(ts.name,'[,""]+',' ','g'),50) ||'",'|| /* Име на декларатора*/  
    /* kind property  */  
         '"'||rpadc(tobj.kindproperty,1) ||'",'|| /*Вид имот ('1'-земя, '2'-сграда(и), '3'-земя и сграда(и))*/  
    /* address*/  
         '"'||rpadc(city.ekatte,5) ||'",'|| /*Адрес на имота : Код населено място*/  
         '"'||rpadc(adm.code,2) ||'",'|| /*Адрес на имота :Код район*/  
         '"'||rpadc(str.ekkpa,5) ||'",'|| /*Адрес на имота :Код улица*/  
         '"'||rpadc(REGEXP_REPLACE(str.name,'[,""]+',' ','g'),30) ||'",'|| /*Адрес на имота :Име улица*/  
         '"'||rpadc(REGEXP_REPLACE(case when str.kind_street = '8' then str.name else ' ' end,'[,""]+',' ','g'),15) ||'",'|| /*Адрес на имота :махала*/  
         '"'||rpadc(REGEXP_REPLACE(a.nom,'[,""]+',' ','g'),4) ||'",'|| /*Адрес на имота :номер */  
         '"'||rpadc(REGEXP_REPLACE(a.entry,'[,""]+',' ','g'),2) ||'",'|| /*Адрес на имота :вход*/  
         '"'||rpadc(REGEXP_REPLACE(a.floor,'[,""]+',' ','g'),2)  ||'",'|| /*Адрес на имота :етаж */  
         '"'||rpadc(REGEXP_REPLACE(a.apartment,'[,""]+',' ','g'),3) ||'",'|| /*Адрес на имота:апартамент */  
    /* property*/  
         '"'||rpadc(p.iselectro,1)  ||'",'|| /*Индикатор за електрификация ('1'-има в имота, '2'-няма в имота,но има около имота, '3'-няма в и около имота)*/  
         '"'||rpadc(p.iswater,1)  ||'",'|| /*Индикатор за водопровод ('1'-има в имота, '2'-няма в имота,но има около имота, '3'-няма в и около имота) */  
         '"'||rpadc(p.issewer,1)  ||'",'|| /*Индикатор за канализация ('1'-има в имота, '2'-няма в имота,но има около имота, '3'-няма в и около имота) */  
         '"'||rpadc(p.istec,1)  ||'",'|| /*Индикатор за наличие на ТЕЦ('1'-има в имота, '2'-няма в имота,но има около имота,'3'-няма в и около имота)*/  
         '"'||rpadc(p.isroad,1)  ||'",'|| /*Индикатор имотът граничи с пътна мрежа ('1'-да, '2'-не)*/  
         '"'||rpadc(REGEXP_REPLACE(p.kadastrno,'[,""]+',' ','g'),6) ||'",'|| /*Планоснимачен номер*/  
         '"'||rpadc(REGEXP_REPLACE(p.kadastr_year,'[,""]+',' ','g'),4) ||'",'|| /*Година на одобряване на кадастрален план*/  
         '"'||rpadc(REGEXP_REPLACE(p.zrpno_parcel,'[,""]+',' ','g'),11) ||'",'|| /*УПИ парцел*/  
         '"'||rpadc(REGEXP_REPLACE(case when str.kind_street = '7' then str.name else ' ' end,'[,""]+',' ','g'),4) ||'",'|| /*квартал*/  
         '"'||rpadc(to_char(p.zrp_date,'yyyy'),4) ||'",'|| /*Година на одобряване на ЗРП*/  
         '"'||rpadc(p.category_city,1) ||'",'|| /*Категория на населеното място*/  
         '"'||rpadc(p.isnationalresort,1) ||'",'|| /*Индикатор за национален курорт  ('1'-да, '2'-не)*/  
         '"'||rpadc(p.islocalresort,1) ||'",'|| /*Индикатор за местен курорт ('1'-да, '2'-не)*/  
         '"'||rpadc(p.isseezone,1) ||'",'|| /*Индикатор за вилна зона до 10 км от морската брегова ивица ('1'-да, '2'-не)*/  
         '"'||rpadc(p.isnationalroadnet,1) ||'",'|| /*Индикатор - имотът е до 1км от републ.пътна мрежа, ....('1'-да, '2'-не)*/  
         '"'||rpadc(p.isisolatedzone,1) ||'",'|| /*Индикатор - имотът попада в обособена производствена /пром.или селскост. зона/('1'-да, '2'-не)*/  
         '"'||rpadc(p.city_category1,1) ||'",'|| /*Индикатор за населено място от IV,V,VI,VII,VIII категория и на 20 км от нас.място от 0 или I категория ('1'-да, '2'-не)*/  
         '"'||rpadc(p.city_category2,1) ||'",'|| /*Индикатор за населено място от IV,V,VI,VII,VIII категория и на 20 км от нас.място от 0 или II категория ('1'-да, '2'-не)*/  
         '"'||rpadc(p.builder_zone,1) ||'",'|| /*Код строителна зона /вилна зона */  
         '"'||rpadc(p.constructionbound,1) ||'",'|| /*Индикатор за разположение на имота ('1'-в строителни граници,  '2'-извън строителни граници*/  
         '"'||rpadc(p.kindland,1) ||'",'|| /*Код вид земя*/  
         '"'||rpadc(p.structurezone,1) ||'",'|| /*Код устройствена зона */  
         '"'||rpadc(REGEXP_REPLACE(p.earnway,'[,""]+',' ','g'),20) ||'",'|| /*Начин на придобиване*/  
         '"'||rpadc(REGEXP_REPLACE(p.propertydoc,'[,""]+',' ','g'),20) ||'",'|| /**Вид документ за собственост*/  
         '"'||rpadc(REGEXP_REPLACE(p.propertynodoc,'[,""]+',' ','g'),17) ||'",'|| /*Номер документ за собственост*/  
         rpadc(to_char(p.propdocdate,'yyyymmdd'),8) ||','|| /*Дата на издаване на документа за собственост*/  
         '"'||rpadc(REGEXP_REPLACE(p.propemission,'[,""]+',' ','g'),15) ||'",'|| /*Издател на документа за собственост*/  
         '"'||rpadc(case when td.emp_taxsubject_id is not null then '3' else td.kinddecl end,1) ||'",'|| /*Идентификатор за декларатора (‘1’-собственик, ‘2’ –законен представител,’3’- упълномощено лице)*/  
         '"'||rpadc(case when td.endtaxdate is null then '1' else ' ' end,1) ||'",'|| /*Индикатор за активност на записа ('1'-неактивен, ' '-активен)*/  
         '"'||rpadc(' ',1) ||'",'|| /*Маркер за дублиран имот ('1'-има дублиране)*/  
         rpadc(to_char(td.user_date,'yyyymmdd'),8) ||','|| /*Дата на последна корекция*/  
         '"'||rpadc(case when td.decl14to17 = 2 then '1' else ' ' end,1)||'"'|| /*Индикатор за подаване на декл. По чл.14 за нежилищен имот на предприятие*/ 
         CHR(13) || CHR(10) imor_row 
    from Taxdoc td   
    join  Taxsubject ts on ts.taxsubject_id = td.taxsubject_id
    join  Taxobject tobj on tobj.taxobject_id = td.taxobject_id
    join  Property p on p.taxdoc_id = td.taxdoc_id
    join  Address a on a.address_id = tobj.address_id
    left join Street str on str.street_id = a.street_id
    join City city on city.city_id = a.city_id
    left join Admregion adm on adm.admregion_id = a.admregion_id
    
    join municipality m on m.municipality_id = td.municipality_id
     
   where td.documenttype_id = 21 
     and td.docstatus in ('30','90')
     and coalesce(td.decl14to17,0) != 1   
     and (select case when max(n.extractdate) is null then to_date('01.01.1998','dd.mm.yyyy')
                 else max(n.extractdate) end
            from napfilehistory n 
           where substr(n.filename,1,2) = 'OP' and n.municipality_id = td.municipality_id) <= coalesce(td.user_date,td.doc_date)
     and coalesce(td.user_date,td.doc_date) <= current_date
     and td.municipality_id = $1
     and coalesce(trim(td.partidano),'') != ''
    order by td.partidano
$function$
;
