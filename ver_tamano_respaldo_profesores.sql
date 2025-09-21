SELECT 
    CONCAT(
        f.id, '|',
        f.filename, '|',
        ROUND(f.filesize / (1024 * 1024 * 1024), 2), '|',
        c.fullname, '|',
        CONCAT(u.firstname, ' ', u.lastname), '|',
        u.email, '|',
        CONCAT(
            'https://educafi01.ingenieria.unam.edu/EducafiUNICA/backup/restorefile.php?contextid=',
            f.contextid
        )
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
ORDER BY 
    c.fullname, CONCAT(u.firstname, ' ', u.lastname);  -- Ordenar por las columnas reales
