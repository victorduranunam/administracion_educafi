SELECT 
    CONCAT(
        CONCAT(u.firstname, ' ', u.lastname), '|',
        c.fullname, '|',
        ROUND(SUM(f.filesize) / (1024 * 1024 * 1024), 2), '|',  -- Tamaño total de los backups en GB (con 2 decimales)
        u.email, '|',  -- Correo electrónico del profesor
        'https://educafi01.ingenieria.unam.edu/EducafiUNICA/course/view.php?id=' , c.id  -- URL del curso
    ) AS "resultado"
FROM 
    edu_files f
JOIN 
    edu_context ctx ON f.contextid = ctx.id
JOIN 
    edu_course c ON ctx.instanceid = c.id AND ctx.contextlevel = 50 -- Nivel 50 es para cursos
JOIN 
    edu_role_assignments ra ON ra.contextid = ctx.id
JOIN 
    edu_role r ON ra.roleid = r.id
JOIN 
    edu_user u ON ra.userid = u.id
WHERE 
    f.filename LIKE '%.mbz' -- Solo archivos de respaldo
    AND r.shortname = 'editingteacher' -- Rol del profesor con permiso de edición
GROUP BY 
    u.id, c.id  -- Agrupar por profesor y curso
ORDER BY 
    SUM(f.filesize) DESC;  -- Ordenar por tamaño total de los respaldos (del mayor al menor)