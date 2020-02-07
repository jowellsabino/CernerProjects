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
 and (pruser.name_last_key like 'CHB%'
	   or
	   pruser.name_last_key like 'BCH%')
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
 and (pruser.name_last_key like 'CHB%'
	   or
	   pruser.name_last_key like 'BCH%')
--where pa.ACTION_DT_TM > now() - 365
group by pruser.PERSON_ID
     , pruser.NAME_FULL_FORMATTED
	 , TEST_OR_REAL_PATIENT 
order by TEST_OR_REAL_PATIENT,pruser.NAME_FULL_FORMATTED
;

