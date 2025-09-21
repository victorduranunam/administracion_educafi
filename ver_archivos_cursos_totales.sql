
-- Consulta para obtener archivos subidos y recursos con URLs en un curso
SELECT 
    f.filename, 
    f.mimetype, 
    f.filesize, 
    c.fullname AS course_name,
    r.name AS resource_name, 
    r.intro AS resource_url
FROM 
    edu_files f
JOIN 
    edu_context ctx ON f.contextid = ctx.id
JOIN 
    edu_course c ON ctx.instanceid = c.id
LEFT JOIN 
    edu_resource r ON r.course = c.id
WHERE 
    c.id = 525 
    AND f.filename <> '.'  -- Excluye entradas vacías
ORDER BY 
    f.filename;

-- Consulta para obtener el total de espacio ocupado por los archivos
SELECT 
    SUM(f.filesize) / 1024 / 1024 / 1024 AS total_size_gb
FROM 
    edu_files f
JOIN 
    edu_context ctx ON f.contextid = ctx.id
JOIN 
    edu_course c ON ctx.instanceid = c.id
WHERE 
    c.id = 525 
    AND f.filename <> '.';  -- Excluye entradas vacías




