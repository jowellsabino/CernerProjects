/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , pr.name_full_formatted
     , pr.username 
     , cvpos.display AS position_user 
--     , eau.directory_ind AS LDAP
     , pr.active_ind
     , pr.end_effective_dt_tm
     , cvcontr.display AS Contributor_System
     , prup.name_full_formatted AS Updated_By
     , pr.updt_dt_tm
     , prcr.name_full_formatted AS Created_By
     , pr.create_dt_tm
 --    , eau.password_hash
 --    , eau.password_change_dt_tm
 --    , eau.password_lifetime
FROM ads_v500_stage.admin.prsnl pr
LEFT   
JOIN ads_v500_stage.admin.code_value cvpos
  ON cvpos.code_value = pr.position_cd  
 AND cvpos.code_set = 88  
LEFT   
JOIN ads_v500_stage.admin.code_value cvcontr
  ON cvcontr.code_value = pr.contributor_system_cd 
 AND cvcontr.code_set = 89  
LEFT   
JOIN ads_v500_stage.admin.prsnl prup
  ON prup.person_id = pr.updt_id
 
LEFT  
JOIN ads_v500_stage.admin.prsnl prcr
  ON prcr.person_id = pr.create_prsnl_id
 
--JOIN ea_user eau
--  ON eau.username = pr.username
 /* and eau.directory_ind != -1) ;; since authview default is direcoty = Y, directory_ind = 0 is also LDAP */
 
WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0