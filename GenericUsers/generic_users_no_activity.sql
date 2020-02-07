/* Raw data, w/o regard for active_ind, end_effecive_dt_tm or position_cd*/
SELECT pr.person_id
     , pr.name_full_formatted
     , pr.username 
     , cvpos.display AS position_user 
     , pr.active_ind
     , pr.end_effective_dt_tm
     , cvcontr.display AS Contributor_System
     , prup.name_full_formatted AS Updated_By
     , pr.updt_dt_tm
     , prcr.name_full_formatted AS Created_By
     , pr.create_dt_tm
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

WHERE (pr.name_last_key like 'CHB%' 
       OR  
       pr.name_last_key like  'BCH%')
  and pr.name_first_key is not null
  and pr.person_id > 0 
  and not exists (select 1 
                    from ads_v500_stage.admin.ce_event_prsnl cep
                      where cep.ACTION_PRSNL_ID = pr.PERSON_ID
                      AND cep.PROXY_PRSNL_ID = 0.0)
   and not exists (select 1
                        from ads_v500_stage.admin.ce_event_prsnl cepprox
                     where cepprox.PROXY_PRSNL_ID = pr.PERSON_ID)

   and not exists (select 1
                        from ads_v500_stage.admin.order_action oa
                     where oa.ACTION_PERSONNEL_ID = pr.PERSON_ID)

   and not exists (select 1
                        from ads_v500_stage.admin.pathway_action pa
                     where pa.ACTION_PRSNL_ID  = pr.PERSON_ID)

   and not exists (select 1
                        from ads_v500_stage.admin.task_activity ta
                     where ta.MSG_SENDER_ID  = pr.PERSON_ID)
   and not exists (select 1
                        from ads_v500_stage.admin.task_activity_assignment taa
                     where taa.ASSIGN_PRSNL_ID  = pr.PERSON_ID)
   and not exists (select 1
                        from ads_v500_stage.admin.task_activity_assignment taa
                     where taa.proxy_prsnl_id  = pr.PERSON_ID)