SELECT f.filename, f.mimetype, f.filesize, c.fullname AS course_name
FROM edu_files f
JOIN edu_context ctx ON f.contextid = ctx.id
JOIN edu_course c ON ctx.instanceid = c.id
WHERE c.id = 525 AND f.filename <> '.';

-- Tamaño total de los archivos
SELECT ROUND(SUM(f.filesize) / 1073741824, 3) AS total_size_gb
FROM edu_files f
JOIN edu_context ctx ON f.contextid = ctx.id
JOIN edu_course c ON ctx.instanceid = c.id
WHERE c.id = 525 AND f.filename <> '.';
