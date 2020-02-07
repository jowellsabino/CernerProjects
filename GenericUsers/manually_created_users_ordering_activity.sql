/* order activity */
select pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
     ,  (case
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or 
             p.NAME_LAST_KEY like 'TEST%'
             or 
             p.NAME_LAST_KEY like 'SYTEM%'
        then 'TEST'
        else '**REAL**'                                 
        end) as TEST_OR_REAL_PT 
     , 'ORDER' as ORDERING_ACTIVITY
     , count(*) as ORDERING_ACTIVITY_COUNT
     , max(oa.UPDT_DT_TM) as LATEST_ORDERING_ACTIVITY
from ads_v500_stage.admin.order_action oa
join ads_v500_stage.admin.orders o
  on o.ORDER_ID = oa.ORDER_ID
join ads_v500_stage.admin.person p
  on p.PERSON_ID = o.PERSON_ID
join ads_v500_stage.admin.prsnl pruser
  on pruser.PERSON_ID = oa.ACTION_PERSONNEL_ID 
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
 AND pruser.active_ind = 1
 AND not sql_function..regexp_like(pruser.username,'^CH[0-9]+')  
 AND pruser.username != ''  
 AND pruser.name_last_key not like 'CHB%'   
 AND pruser.name_last_key not like 'BCH%'  
 group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED 
     , ORDERING_ACTIVITY  
     , TEST_OR_REAL_PT 
UNION

/*powerplan activity */
select pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
     ,(case
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or 
             p.NAME_LAST_KEY like 'TEST%'
             or 
             p.NAME_LAST_KEY like 'SYTEM%'
        then 'TEST'
        else '**REAL**'
         end) as TEST_OR_REAL_PT      
      , 'PLAN' as ORDERING_ACTIVITY 
      , count(*) as ORDERING_ACTIVITY_COUNT
      , max(pa.UPDT_DT_TM) as LATEST_ORDERING_ACTIVITY
from ads_v500_stage.admin.pathway_action pa
join ads_v500_stage.admin.pathway pp
  on pp.pathway_ID = pa.pathway_ID
join ads_v500_stage.admin.person p
  on p.PERSON_ID = pp.PERSON_ID
join ads_v500_stage.admin.prsnl pruser
  on pruser.PERSON_ID = pa.ACTION_PRSNL_ID 
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
 AND pruser.active_ind = 1
 AND not sql_function..regexp_like(pruser.username,'^CH[0-9]+')  
 AND pruser.username != ''   
 AND pruser.name_last_key not like 'CHB%'   
 AND pruser.name_last_key not like 'BCH%'   
 group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
     , ORDERING_ACTIVITY 
     , TEST_OR_REAL_PT