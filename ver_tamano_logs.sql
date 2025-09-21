SELECT 
    table_name AS "Table", 
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM 
    information_schema.tables
WHERE 
    table_schema = 'educafiunica'
    AND table_name = 'edu_logstore_standard_log';
