/* Audit query of task_activity to see if there are task_types that are in finalized status (see below),
; for discharged encounters but still in the task_activity table.  Exclude task types with its own 
; end-stage process (order, RTE) 
;
; Phone message purge : https://connect.cerner.com/message/1705460#1705460
;
; Phone messages are handled quite differently because the lifecycle ends with the message deletion, not a
; task/order completion or a powerform completion (unlike other tasks).  For this reason, phone messages are purged
; quite differently.
; 
; Phone messages have a parent task on the task activity table.  They have children tasks on the task_activity_assignment table.  
; A phone message will have a child task for each occurance in a clinician’s inbox.  Once the clinician trashes the message, 
; the task on the task_activity_assignment table is DELETED, but the active_ind = 1 and the message is still visible in the Trash
; folder.  In task_activity, the task_status_cd and active_ind remain the same (pPending, and 1 respectively).  Even for multiple 
; receipients for the same message, deleting all receipient messages will nto change the task_staus_cd and active_ind in the 
; task_activity table. Note, however, that updt_cnt, updt_id and updt_dt_tm are changed in task_activity to correspond to the 
; chnages intask_activity_asignment.
;
;  When a receipient empties his/her Trash, the active_ind = 0 in task_activity_assignment.  Of course, the other receipients are NOT affected.
;  The task_activity table is also NOT affected.  Since active_ind = 0, the message no longer appears in the rceipients's Trasjh folder if 
; the Trash folder was emptied.  
;
; When all receipients emoty their Trash, then and only then is task_activity updated such that task_status is deleted and active_ind = 0.  
; This qualifies thetask_activity roe to qualify for purges that look for inactive rows.
; 
; An ops job runs pco_upd_phone_msg.prg is equivalent to emptying Trash, so we do not have to wait for everyone to empty their Trash folder.
; At the moment, we have set the ops job to run with a lookback of 30 days since last update (deletion) of the message when we clean up Trash.
;
;  Purging task-activity also purges all tables (e.g. task_activity_assignment) that has the same task_id.
; If we do NOT have a purge rule for phone msg that purges inactive messages, the phone messgaes will live forever in task_activity. 
*/

/* Get all rows */
SELECT count(*)
FROM TASK_ACTIVITY

/* Get rows for phone message tasks */
SELECT cvtt.display AS TASK_TYPE
--     , cvts.display AS TASK_STATUS
--     , CASE cve.field_value
--            WHEN  '1' THEN 'Finalized'
--            WHEN  '2' THEN 'Dropped'
--            WHEN  '4' THEN 'Active'
--            ELSE  'Unknown'
--       END AS PurgeTaskStatus
     , ta.ACTIVE_IND
--     , tpc.retention_days
--     , tpc.purge_active_flag
--     , CASE WHEN tpc.purge_active_flag = 0 THEN 'Inactive'
--            WHEN tpc.purge_active_flag = 1 THEN 'Active'
--            ELSE  'DEFECT'
--       END AS "Purge Active Task" /* Anything greater than 1 is unsupported, and the purge may not work */
--     , CASE WHEN tpc.patient_status_flag = 0 THEN 'Unchecked option'
--            WHEN tpc.patient_status_flag = 1 THEN 'Discharged'
--            WHEN tpc.patient_status_flag = 2 THEN 'Active'
--            ELSE  'Unknown'
--       END AS "Task Encounter Status"
     , count(ta.task_id)
     , max(ta.updt_dt_tm)
 FROM task_activity ta
--     INNER JOIN tl_purge_criteria tpc
--             ON tpc.task_type_cd = ta.task_type_cd
     INNER JOIN encounter e
             ON e.encntr_id = ta.encntr_id
            AND e.encntr_status_cd+0 IN (SELECT code_value
                                           FROM code_value
                                          WHERE code_set = 261
                                            AND cdf_meaning = 'DISCHARGED')
      INNER JOIN code_value cvtt 
              ON cvtt.CODE_VALUE  = ta.TASK_TYPE_CD 
             AND cvtt.code_set = 6026
--      INNER JOIN code_value cvts 
--              ON cvts.CODE_VALUE  = ta.TASK_status_CD  
--             AND cvts.code_set = 79
--      INNER JOIN code_value_extension cve 
--              ON cve.code_value = cvts.code_value
WHERE ta.task_status_cd+0 IN (SELECT code_value 
                                FROM code_value
                               WHERE code_set = 79
                                 AND active_ind = 1
                                 AND code_value IN (SELECT code_value              
                                                      FROM code_value_extension
                                                     WHERE field_value = '1')) /* 1- Cancelled, Complete, Deleted, Discontinued (task statuses)*/
                                                     /* 2 - Dropped; 4 - Delivered, In Error, On Hold, Opened
                                                                       , Overdue, Pending, Read, Rework, Suspended
                                                                       , Refused, Pending Validation, Recalled */
                                                    /* Dropped is set by the retention time configured in the order-task tool */ 
  AND ta.task_type_cd+0 IN (SELECT code_value
                              FROM code_value
                             WHERE  code_set = 6026
                               AND cdf_meaning NOT IN ('ORDER', 'ENDORSE', 'PHONE MSG', 'NEW RESULT'))
  AND ta.updt_dt_tm < sysdate - 90 /* Should set to 90 since 90 days is max in purge rules.  If count(*) > 0, these are unpurged */
GROUP BY cvtt.display
--     , cvts.display
--     , cve.field_value
     , ta.ACTIVE_IND  
--     , tpc.task_status_flag
--     , tpc.retention_days
--     , tpc.purge_active_flag
--     , tpc.purge_active_flag
--     , tpc.patient_status_flag 
ORDER BY TASK_TYPE
--       , PURGETASKSTATUS
--       , TASK_STATUS 
