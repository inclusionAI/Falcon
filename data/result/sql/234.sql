WITH science_subject AS (
    SELECT 
        subjectid
    FROM 
        ant_icube_dev.school_subject
), 

filtered_marks AS (
    SELECT 
        m.studentid,
        CAST(m.markobtained AS BIGINT) as mark_value
    FROM 
        ant_icube_dev.school_marks m
    INNER JOIN science_subject s
        ON m.subjectid = s.subjectid
),

student_stats AS (
    SELECT 
        studentid,
        SUM(mark_value) as total_marks,
        COUNT(*) as exam_count
    FROM 
        filtered_marks
    GROUP BY 
        studentid
    HAVING 
        SUM(mark_value) > 850
        AND COUNT(*) >= 10
)

SELECT 
    st.studentid as `学生id`,
    concat(st.lastname,' ',st.firstname) as `姓名`
FROM 
    ant_icube_dev.school_students st
INNER JOIN student_stats ss
    ON st.studentid = ss.studentid;