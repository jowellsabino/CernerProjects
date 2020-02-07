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
WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0 
 
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
WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0 
 
GROUP BY pr.PERSON_ID, TEST_OR_REAL, ACTOR_OR_PROXY
