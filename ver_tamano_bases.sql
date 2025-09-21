SELECT 
table_schema AS "educafiunica",
    	ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
    	FROM 
information_schema.tables
WHERE 
table_schema = 'educafiunica'
GROUP BY 
    	table_schema;
