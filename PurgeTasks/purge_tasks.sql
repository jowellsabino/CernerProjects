SELECT tpc.tl_purge_description
     , CASE tpc.task_status_flag 
            WHEN  0 THEN 'Finalized'
            WHEN  1 THEN 'Dropped'
            WHEN  2 THEN 'Active'
            ELSE  'Unknown'
       END AS TaskStatus
     , CASE tpc.purge_active_flag
            WHEN 0 THEN 'Inactive'
            WHEN 1 THEN 'Active'
            ELSE  'DEFECT'
       END AS ActiveTask /* Anything greater than 1 is unsupported, and the purge may not work */
     , CASE tpc.patient_status_flag 
            WHEN 0 THEN 'Discharged'
            WHEN 1 THEN 'Not Discharged'
            ELSE  'Unchecked'
       END AS PatientStatus
     , tpc.retention_days
     , tpc.patient_status_flag 
     , tpc.task_status_flag
     , tpc.purge_active_flag
FROM tl_purge_criteria tpc
WHERE tpc.purge_active_flag > 1
ORDER BY tpc.tl_purge_description


SELECT cv.code_value, cv.display, cv.cdf_meaning, cve.field_value
FROM code_value cv 
JOIN code_value_extension cve 
  ON cve.code_value = cv.code_value
WHERE cv.code_set = 79
AND cv.active_ind = 1
;
