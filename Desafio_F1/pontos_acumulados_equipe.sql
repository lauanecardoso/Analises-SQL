SELECT
    constructor_name,
    date,
    points,
    SUM(points) OVER (PARTITION BY constructor_name ORDER BY date) AS pontos_acumulados
FROM
    dadosf1
ORDER BY
    driver_id,
    date;
	