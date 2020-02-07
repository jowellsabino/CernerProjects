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
        end) as TEST_OR_REAL_PATIENT 
     , count(*) as ORDER_ACTIVITY_COUNT
	 , max(oa.UPDT_DT_TM) as LATEST_ORDER_ACTIVITY
from order_action oa
join orders o
  on o.ORDER_ID = oa.ORDER_ID
join person p
  on p.PERSON_ID = o.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = oa.ACTION_PERSONNEL_ID 
 AND pruser.position_cd > 0
 AND pruser.contributor_system_cd = 0
 AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
 AND pruser.updt_id > 0
 AND pruser.create_prsnl_id > 0 
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
order by TEST_OR_REAL_PATIENT,pruser.NAME_FULL_FORMATTED
;

/*powerplan activity */
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
     , count(*) as POWERPLAN_ACTIVITY_COUNT
	 , max(pa.UPDT_DT_TM) as LATEST_POWERPLAN_ACTIVITY
from pathway_action pa
join pathway pp
  on pp.pathway_ID = pa.pathway_ID
join person p
  on p.PERSON_ID = pp.PERSON_ID
join prsnl pruser
  on pruser.PERSON_ID = pa.ACTION_PRSNL_ID 
  AND pruser.position_cd > 0
  AND pruser.contributor_system_cd = 0
  AND pruser.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
  AND pruser.updt_id > 0
  AND pruser.create_prsnl_id > 0 
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
order by TEST_OR_REAL_PATIENT,pruser.NAME_FULL_FORMATTED
;

