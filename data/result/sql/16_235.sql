WITH SubjectStats AS (
    SELECT 
        subjectid,
        AVG(CAST(markobtained AS DOUBLE)) AS avg_mark,
        COUNT(DISTINCT studentid) AS student_count
    FROM 
        ant_icube_dev.school_marks
    GROUP BY 
        subjectid
)
SELECT 
    s.subjectname AS `科目名称`
FROM 
    SubjectStats ss
JOIN 
    ant_icube_dev.school_subject s 
ON 
    ss.subjectid = s.subjectid
WHERE 
    ss.avg_mark < 75 
    AND ss.student_count < 3;