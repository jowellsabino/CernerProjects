/* task activity */
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
     , 'SENDER' as ACTION_ROLE
     , count(*) as TASK_ACTIVITY_COUNT
     , max(ta.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from ads_v500_stage.admin.task_activity ta
join ads_v500_stage.admin.person p
  on p.PERSON_ID = ta.PERSON_ID
join ads_v500_stage.admin.prsnl pruser
  on pruser.PERSON_ID = ta.MSG_SENDER_ID
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
 AND pruser.active_ind = 1
 AND not sql_function..regexp_like(pruser.username,'^CH[0-9]+')  
 AND pruser.username != ''    
 AND pruser.name_last_key not like 'CHB%'   
 AND pruser.name_last_key not like 'BCH%'   
WHERE ta.PERFORMED_PRSNL_ID > 0
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
     , TEST_OR_REAL_PT 
     , ACTION_ROLE

UNION

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
     , 'ACTOR' as ACTION_ROLE
     , count(*) as TASK_ACTIVITY_COUNT
     , max(taa.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from ads_v500_stage.admin.task_activity_assignment taa
join ads_v500_stage.admin.task_activity ta
  on ta.TASK_ID = taa.TASK_ID
join ads_v500_stage.admin.person p
  on p.PERSON_ID = ta.PERSON_ID
join ads_v500_stage.admin.prsnl pruser
  on pruser.PERSON_ID = taa.ASSIGN_PRSNL_ID
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
 AND pruser.active_ind = 1
 AND not sql_function..regexp_like(pruser.username,'^CH[0-9]+')  
 AND pruser.username != ''   
 AND pruser.name_last_key not like 'CHB%'   
 AND pruser.name_last_key not like 'BCH%'   
WHERE taa.proxy_prsnl_id = 0.0
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
     , TEST_OR_REAL_PT 
     , ACTION_ROLE

UNION

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
     , 'PROXY' as ACTION_ROLE
     , count(*) as TASK_ACTIVITY_COUNT
     , max(taa.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from ads_v500_stage.admin.task_activity_assignment taa
join ads_v500_stage.admin.task_activity ta
  on ta.TASK_ID = taa.TASK_ID
join ads_v500_stage.admin.person p
  on p.PERSON_ID = ta.PERSON_ID
join ads_v500_stage.admin.prsnl pruser
  on pruser.PERSON_ID = taa.proxy_prsnl_id
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
 AND pruser.active_ind = 1
 AND not sql_function..regexp_like(pruser.username,'^CH[0-9]+')  
 AND pruser.username != ''    
 AND pruser.name_last_key not like 'CHB%'   
 AND pruser.name_last_key not like 'BCH%'   
 group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
     , TEST_OR_REAL_PT 
     , ACTION_ROLE