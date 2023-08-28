SELECT
    driver_id,
    date,
    points,
    SUM(points) OVER (PARTITION BY driver_id ORDER BY date) AS pontos_acumulados
FROM
    dadosf1
ORDER BY
    driver_id,
    date