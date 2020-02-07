/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (CASE
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or
             p.NAME_LAST_KEY like 'TEST%'
             or
             p.NAME_LAST_KEY like 'SYTEM%'
        THEN 'TEST'
        ELSE '**REAL**'
        end) AS TEST_OR_REAL_PATIENT
     , 'ACTOR' AS ACTOR_OR_PROXY
     , count(cep.CE_EVENT_PRSNL_ID) AS CE_ACTIVITY_COUNT
     , max(cep.ACTION_DT_TM) AS LATEST_CE_ACTIVITY
FROM prsnl pr
JOIN ce_event_prsnl cep
  ON cep.ACTION_PRSNL_ID = pr.PERSON_ID
 AND cep.PROXY_PRSNL_ID = 0.0
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE pr.position_cd >= 0
  AND pr.contributor_system_cd = 0
  AND pr.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
  AND pr.updt_id > 0
  AND pr.create_prsnl_id > 0 
  
 
GROUP BY pr.PERSON_ID, TEST_OR_REAL_PATIENT, ACTOR_OR_PROXY

UNION

/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (CASE
        when p.NAME_LAST_KEY like 'SYSTEM%'
             or
             p.NAME_LAST_KEY like 'TEST%'
             or
             p.NAME_LAST_KEY like 'SYTEM%'
        THEN 'TEST'
        ELSE '**REAL**'
        end) AS TEST_OR_REAL_PATIENT
       , 'PROXY' AS ACTOR_OR_PROXY
       , count(cep.CE_EVENT_PRSNL_ID) AS CE_ACTIVITY_COUNT
       , max(cep.ACTION_DT_TM) AS LATEST_CE_ACTIVITY
FROM prsnl pr
JOIN ce_event_prsnl cep
  ON cep.PROXY_PRSNL_ID = pr.PERSON_ID
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE pr.position_cd >= 0
  AND pr.contributor_system_cd = 0
  AND pr.active_ind = 1
  /* AND pr.end_effective_dt_tm > now() */
  AND pr.updt_id > 0
  AND pr.create_prsnl_id > 0 
 
GROUP BY pr.PERSON_ID, TEST_OR_REAL_PATIENT, ACTOR_OR_PROXY
;


/* End here */

/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (case
	    when p.NAME_LAST_KEY like 'SYSTEM%'
		     or
			 p.NAME_LAST_KEY like 'TEST%'
			 or
			 p.NAME_LAST_KEY like 'SYTEM%'
		then 'TEST'
		else '**REAL**'
		end) as TEST_OR_REAL
	 , 'ACTOR' as ACTOR_OR_PROXY
     , count(cep.CE_EVENT_PRSNL_ID) as CE_ACTIVITY
	 , max(cep.ACTION_DT_TM) as LATEST_CE_ACTIVITY
FROM prsnl pr
JOIN ce_event_prsnl cep
  ON cep.ACTION_PRSNL_ID = pr.PERSON_ID
 AND cep.PROXY_PRSNL_ID = 0.0
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE pr.position_cd >= 0
  AND pr.contributor_system_cd = 0
  AND pr.active_ind = 1 
  /* AND pr.end_effective_dt_tm > now() */
  AND pr.updt_id > 0
  AND pr.create_prsnl_id > 0 
  
 
GROUP BY pr.PERSON_ID, TEST_OR_REAL, ACTOR_OR_PROXY

UNION

/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (case
	    when p.NAME_LAST_KEY like 'SYSTEM%'
		     or
			 p.NAME_LAST_KEY like 'TEST%'
			 or
			 p.NAME_LAST_KEY like 'SYTEM%'
		then 'TEST'
		else '**REAL**'
		end) as TEST_OR_REAL
     , 'PROXY' as ACTOR_OR_PROXY
     , count(cep.CE_EVENT_PRSNL_ID) as CE_ACTIVITY
	 , max(cep.ACTION_DT_TM) as LATEST_CE_ACTIVITY
FROM prsnl pr
JOIN ce_event_prsnl cep
  ON cep.PROXY_PRSNL_ID = pr.PERSON_ID
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE pr.position_cd >= 0
  AND pr.contributor_system_cd = 0
  AND pr.active_ind = 1
  /* AND pr.end_effective_dt_tm > now() */
  AND pr.updt_id > 0
  AND pr.create_prsnl_id > 0 
 
GROUP BY pr.PERSON_ID, TEST_OR_REAL, ACTOR_OR_PROXY
;