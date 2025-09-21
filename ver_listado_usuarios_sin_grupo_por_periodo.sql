-- Definir las variables con las fechas
SET @start_time = '2022-01-01 00:00:00';
SET @end_time = '2022-12-01 23:59:59';

-- Ejecutar la consulta con la salida separada por pipe
SELECT CONCAT(u.username, ',', 1) AS output
FROM edu_user u
LEFT JOIN edu_user_enrolments ue ON u.id = ue.userid
WHERE ue.userid IS NULL
AND u.lastaccess BETWEEN UNIX_TIMESTAMP(@start_time) 
                     AND UNIX_TIMESTAMP(@end_time)
AND u.deleted = 0;
