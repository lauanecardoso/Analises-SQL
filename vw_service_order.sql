CREATE VIEW vw_service_order AS 

WITH 

service_order_logs AS
 (SELECT service_order_id,
         MIN(CASE
                 WHEN title IN ('Orçamento aprovado', 'Orçamento aprovado pelo pagador') THEN created_at
             END) AS datetime_first_budget_approved,
         MAX(CASE
                 WHEN title IN ('Orçamento aprovado', 'Orçamento aprovado pelo pagador') THEN created_at
             END) AS datetime_last_budget_approved,
         MAX(CASE
                 WHEN title = 'Aprovação cancelada' THEN created_at
             END) AS datetime_execution_budget_cancelled
  FROM log_event
  WHERE title IN ('Orçamento aprovado','Orçamento aprovado pelo pagador','Aprovação cancelada')
  GROUP BY service_order_id),
  
service_order_last_approval AS
 (SELECT so.id,
         so.created_at,
         COALESCE (so.datetime_execution_budget_approved,sl.datetime_last_budget_approved) AS datetime_budget_approved
  FROM service_order so
  INNER JOIN service_order_logs sl ON (so.id = sl.service_order_id)),
  
service_order_approval_status AS
 (SELECT la.id,
         la.created_at,
         CASE
             WHEN datetime_execution_budget_cancelled > datetime_budget_approved THEN NULL
             ELSE datetime_budget_approved
         END AS datetime_execution_budget_approved,
         CASE
             WHEN datetime_execution_budget_cancelled < datetime_budget_approved THEN NULL
             ELSE datetime_execution_budget_cancelled
         END AS datetime_execution_budget_cancelled,
         datetime_first_budget_approved
  FROM service_order_logs sl
  INNER JOIN service_order_last_approval la ON (la.id = sl.service_order_id)
  ORDER BY 1,3)
  
SELECT EXTRACT(MONTH FROM created_at) AS MONTH,
       COUNT(CASE
                 WHEN datetime_execution_budget_approved BETWEEN '2022-01-01' AND '2022-12-31' THEN 1
             END) AS budgets_approved,
       COUNT(CASE
                 WHEN datetime_execution_budget_cancelled BETWEEN '2022-01-01' AND '2022-12-31' THEN 1
             END) AS budgets_cancelled
FROM service_order_approval_status
GROUP BY EXTRACT(MONTH FROM created_at)
ORDER BY 1