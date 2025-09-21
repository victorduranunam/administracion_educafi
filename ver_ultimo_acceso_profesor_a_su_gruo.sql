SET @ruta = 'https://educafi01.ingenieria.unam.edu';

SELECT 
    CONCAT(
        c.id, 
        '|', 
        c.fullname, 
        '|', 

        -- Nombre del profesor
        (SELECT CONCAT(u.firstname, ' ', u.lastname)
         FROM edu_user u
         JOIN edu_role_assignments ra ON ra.userid = u.id
         JOIN edu_context ctx ON ra.contextid = ctx.id
         WHERE ctx.instanceid = c.id
         AND ra.roleid = (SELECT id FROM edu_role WHERE shortname = 'editingteacher')
         LIMIT 1
        ),
        '|',

        -- Última vez que el profesor accedió, con formato de fecha
        DATE(FROM_UNIXTIME(
            (SELECT MAX(l.timecreated) 
             FROM edu_logstore_standard_log l
             JOIN edu_user_enrolments ue ON ue.userid = l.userid
             JOIN edu_enrol e ON e.id = ue.enrolid
             WHERE l.courseid = c.id
             AND e.courseid = c.id
             AND ue.userid = l.userid  -- Solo el profesor
             AND l.action = 'viewed'
             AND l.timecreated IS NOT NULL
             LIMIT 1
            )
        )), 
        '|', 

        -- Días transcurridos desde el último acceso del profesor
        DATEDIFF(CURDATE(), FROM_UNIXTIME(
            (SELECT MAX(l.timecreated) 
             FROM edu_logstore_standard_log l
             JOIN edu_user_enrolments ue ON ue.userid = l.userid
             JOIN edu_enrol e ON e.id = ue.enrolid
             WHERE l.courseid = c.id
             AND e.courseid = c.id
             AND ue.userid = l.userid  -- Solo el profesor
             AND l.action = 'viewed'
             AND l.timecreated IS NOT NULL
             LIMIT 1
            )
        )),
        '|',

        -- URL personalizada con prefijo y clave de grupo
        CONCAT(@ruta, '/EducafiUNICA/course/management.php?courseid=', c.id),
        '|',

        -- URL de respaldo
        CONCAT(@ruta, '/EducafiUNICA/backup/restorefile.php?contextid=', c.id)
    ) AS course_data
FROM 
    edu_course c
WHERE 
    c.id IS NOT NULL AND c.fullname IS NOT NULL
ORDER BY 
    DATEDIFF(CURDATE(), FROM_UNIXTIME(
        (SELECT MAX(l.timecreated) 
         FROM edu_logstore_standard_log l
         JOIN edu_user_enrolments ue ON ue.userid = l.userid
         JOIN edu_enrol e ON e.id = ue.enrolid
         WHERE l.courseid = c.id
         AND e.courseid = c.id
         AND ue.userid = l.userid  -- Solo el profesor
         AND l.action = 'viewed'
         AND l.timecreated IS NOT NULL
         LIMIT 1
        )
    )) ASC;
