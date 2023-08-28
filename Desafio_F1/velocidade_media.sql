WITH

rank_velocidade as (
	SELECT
        race_name,
        driver_id,
        fastest_lap_average_speed,
        RANK() OVER (PARTITION BY race_name ORDER BY fastest_lap_average_speed DESC) AS rank
    FROM
        dadosf1
	WHERE fastest_lap_average_speed is not null)
	
	SELECT * 
    FROM rank_velocidade
	WHERE rank <=3