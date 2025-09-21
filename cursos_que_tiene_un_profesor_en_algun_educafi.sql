SELECT
    CONCAT_WS('|',
        u.id,                                    -- ID del profesor
        CONCAT(u.firstname, ' ', u.lastname),    -- Nombre completo del profesor
        c.id,                                    -- ID del curso
        c.fullname,                              -- Nombre del curso
        c.shortname,                             -- Clave del curso
        IFNULL(g.idnumber, 'Sin grupo'),         -- Clave corta del grupo (puedes usar g.name si prefieres)
        'EDUCAFI01'                                -- Texto estático
    ) AS fila
FROM
    edu_user u
JOIN
    edu_role_assignments ra ON ra.userid = u.id
JOIN
    edu_context ctx ON ctx.id = ra.contextid AND ctx.contextlevel = 50
JOIN
    edu_course c ON c.id = ctx.instanceid
JOIN
    edu_role r ON r.id = ra.roleid
LEFT JOIN
    edu_groups g ON g.courseid = c.id            -- Grupos relacionados con el curso
WHERE
    r.shortname IN ('editingteacher', 'teacher')  -- Roles de profesor
    AND u.deleted = 0                             -- Usuario no eliminado
    AND u.suspended = 0                           -- Usuario no suspendido
ORDER BY
    CONCAT(u.firstname, ' ', u.lastname);         -- Ordenado por nombre completo
