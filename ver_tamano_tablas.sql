SELECT 
    CONCAT(
        table_name, '|', 
        ROUND(((data_length + index_length) / 1024 / 1024), 2)
    ) AS "Table and Size"
FROM 
    information_schema.tables
WHERE 
    table_schema = 'educafiunica'
ORDER BY 
    (data_length + index_length) DESC;
