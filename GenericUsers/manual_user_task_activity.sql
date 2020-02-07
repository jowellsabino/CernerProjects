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
        end) as TEST_OR_REAL_PATIENT 
     , 'SENDER' as ACTION_ROLE
     , count(*) as TASK_ACTIVITY_COUNT
	 , max(ta.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from task_activity ta
join person p
  on p.PERSON_ID = ta.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = ta.MSG_SENDER_ID
  AND pruser.contributor_system_cd = 0
 AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
 AND pruser.updt_id > 0
 AND pruser.create_prsnl_id > 0 
WHERE ta.PERFORMED_PRSNL_ID > 0
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
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
        end) as TEST_OR_REAL_PATIENT 
     , 'ACTOR' as ACTION_ROLE
     , count(*) as TASK_ACTIVITY_COUNT
	 , max(taa.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from task_activity_assignment taa
join task_activity ta
  on ta.TASK_ID = taa.TASK_ID
join person p
  on p.PERSON_ID = ta.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = taa.ASSIGN_PRSNL_ID
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0
 AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
 AND pruser.updt_id > 0
 AND pruser.create_prsnl_id > 0 
WHERE taa.proxy_prsnl_id = 0.0
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
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
        end) as TEST_OR_REAL_PATIENT 
	 , 'PROXY' as ACTION_ROLE
     , count(*) as TASK_ACTIVITY_COUNT
	 , max(taa.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from task_activity_assignment taa
join task_activity ta
  on ta.TASK_ID = taa.TASK_ID
join person p
  on p.PERSON_ID = ta.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = taa.proxy_prsnl_id
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0
 AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
 AND pruser.updt_id > 0
 AND pruser.create_prsnl_id > 0 
  group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
	 , ACTION_ROLE
;

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
        end) as TEST_OR_REAL_PATIENT 
     , 'ACTOR' as ACTOR_OR_PROXY
     , count(*) as TASK_ACTIVITY_COUNT
	 , max(taa.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from task_activity_assignment taa
join task_activity ta
  on ta.TASK_ID = taa.TASK_ID
join person p
  on p.PERSON_ID = ta.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = taa.ASSIGN_PRSNL_ID
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0
 AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
 AND pruser.updt_id > 0
 AND pruser.create_prsnl_id > 0 
WHERE taa.proxy_prsnl_id = 0.0
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
	 , ACTOR_OR_PROXY

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
        end) as TEST_OR_REAL_PATIENT 
	 , 'PROXY' as ACTOR_OR_PROXY
     , count(*) as TASK_ACTIVITY_COUNT
	 , max(taa.UPDT_DT_TM) as LATEST_TASK_ACTIVITY
from task_activity_assignment taa
join task_activity ta
  on ta.TASK_ID = taa.TASK_ID
join person p
  on p.PERSON_ID = ta.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = taa.proxy_prsnl_id
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0
 AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
 AND pruser.updt_id > 0
 AND pruser.create_prsnl_id > 0 
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
	 , ACTOR_OR_PROXY
;