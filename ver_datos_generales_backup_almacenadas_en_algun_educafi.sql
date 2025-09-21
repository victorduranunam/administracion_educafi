SELECT 
    CONCAT_WS('|',
        f.filename,
        f.contenthash,
        CONCAT(
            '/edatos/EducafiUNICA/filedir/', 
            SUBSTRING(f.contenthash, 1, 2), '/', 
            SUBSTRING(f.contenthash, 3, 2), '/', 
            f.contenthash
        ),
        f.filesize,
        c.fullname
    ) AS result
FROM 
    edu_files f
JOIN 
    edu_context ctx ON f.contextid = ctx.id
JOIN 
    edu_course c ON ctx.instanceid = c.id
WHERE 
    f.filename LIKE '%.mbz';
