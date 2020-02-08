SELECT *
FROM orders O 
WHERE o.order_id = 3086696261
;

SELECT oc.description, oc.primary_mnemonic, oc.dept_display_name, oef.oe_format_name, oeff.label_text, count(distinct o.ORDER_ID)
FROM orders o
INNER JOIN order_catalog oc
        ON oc.catalog_cd = o.catalog_cd
       --AND oc.description = 'ALVEOLAR CLEFT REPAIR, PLASTICS'
/* OEF template */
INNER JOIN order_entry_format oef
        ON oef.oe_format_id = oc.oe_format_id
       AND oef.action_type_cd = 2534 /* New order */
/* Order customization */
INNER JOIN oe_format_fields oeff
        ON oeff.oe_format_id = oef.oe_format_id
       AND oeff.action_type_cd = oef.action_type_cd
       AND oeff.accept_flag IN (0,1) /* If documented on, must be required or optional.  2 - Do no display, 3 - Display Only */
       AND oeff.label_text = 'Additional Procedure Detail' /* This is what you see in the front-end */
/* Order fields template */
INNER JOIN order_entry_fields oefi
        ON oefi.oe_field_id = oeff.oe_field_id
       and oefi.description = 'Surgical Procedure Text' /* This is the "generic" meaning of the order field, like 'Quantity (ml/kg)'*/
                                                        /* You do not have to use this, so comment out if you want */
/* Order detail value */
inner JOIN order_detail od 
        ON od.oe_field_id = oefi.oe_field_id
       AND od.order_id = o.order_id 
WHERE  o.orig_order_dt_tm > sysdate - 365 /* o.order_id = 3086696261 */
GROUP BY oc.description, oc.primary_mnemonic, oc.dept_display_name,  oef.oe_format_name, oeff.label_text 
ORDER BY oc.description, oc.primary_mnemonic, oc.dept_display_name,  oef.oe_format_name, oeff.label_text 
;

SELECT *
FROM ENCNTR_ALIAS WHERE encntr_id = 85066924 --86083541
;
