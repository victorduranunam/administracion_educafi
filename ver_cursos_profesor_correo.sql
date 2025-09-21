SELECT 
    CONCAT(c.id, '|', 
           c.fullname, '|', 
           u.firstname, ' ', u.lastname, '|', 
           u.email, '|', 
           r.shortname) AS course_info
FROM 
    edu_course AS c
JOIN 
    edu_context AS ctx ON ctx.instanceid = c.id AND ctx.contextlevel = 50
JOIN 
    edu_role_assignments AS ra ON ra.contextid = ctx.id
JOIN 
    edu_user AS u ON u.id = ra.userid
JOIN 
    edu_role AS r ON r.id = ra.roleid
WHERE 
    r.shortname LIKE '%teacher%'
ORDER BY 
    c.fullname;
