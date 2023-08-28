SELECT
	status,
	count(*)
FROM dadosf1
WHERE status <> 'Finished'
GROUP BY 1
ORDER BY 2 desc
	
	