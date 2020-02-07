/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (case
            WHEN p.NAME_LAST_KEY like 'SYSTEM%'
                     OR
                         p.NAME_LAST_KEY like 'TEST%'
                         OR
                         p.NAME_LAST_KEY like 'SYTEM%'
               then 'TEST'
               else '**REAL**'
               END) as TEST_OR_REAL_PT
        , 'ACTOR' as USER_ROLE
    , count(cep.CE_EVENT_PRSNL_ID) as CE_ACTIVITY
        , max(cep.ACTION_DT_TM) as LATEST_CE_ACTIVITY
FROM ads_v500_stage.admin.prsnl pr
JOIN ads_v500_stage.admin.ce_event_prsnl cep
  ON cep.ACTION_PRSNL_ID = pr.PERSON_ID
 AND cep.PROXY_PRSNL_ID = 0.0
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = cep.PERSON_ID
 WHERE pr.position_cd > 0
  AND pr.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
  AND pr.active_ind = 1
  AND not sql_function..regexp_like(pr.username,'^CH[0-9]+')  
  AND pr.username != ''   
  AND pr.name_last_key not like 'CHB%'   
  AND pr.name_last_key not like 'BCH%'  
 GROUP BY pr.PERSON_ID, TEST_OR_REAL_PT, USER_ROLE 
 
UNION

/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , (case
            WHEN p.NAME_LAST_KEY like 'SYSTEM%'
                     OR 
                    p.NAME_LAST_KEY like 'TEST%'
                         OR
                         p.NAME_LAST_KEY like 'SYTEM%'
                then 'TEST'
                else '**REAL**'
                END) as TEST_OR_REAL_PT
     , 'PROXY' as USER_ROLE
     , count(cep.CE_EVENT_PRSNL_ID) as CE_ACTIVITY
         , max(cep.ACTION_DT_TM) as LATEST_CE_ACTIVITY
FROM ads_v500_stage.admin.prsnl pr
JOIN ads_v500_stage.admin.ce_event_prsnl cep
  ON cep.PROXY_PRSNL_ID = pr.PERSON_ID
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
JOIN ads_v500_stage.admin.person p
  ON p.PERSON_ID = cep.PERSON_ID
WHERE pr.position_cd > 0
  AND pr.contributor_system_cd = 0 /* Will exclude CERNER LDAP, contributor_system_cd = 3805574.00 */
  AND pr.active_ind = 1
  AND not sql_function..regexp_like(pr.username,'^CH[0-9]+')  
  AND pr.username != ''     
  AND pr.name_last_key not like 'CHB%'   
  AND pr.name_last_key not like 'BCH%'  
GROUP BY pr.PERSON_ID, TEST_OR_REAL_PT, USER_ROLE