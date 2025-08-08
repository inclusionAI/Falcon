WITH school_avg AS (
    SELECT
        AVG(CAST(markobtained AS DOUBLE)) AS avg_mark
    FROM
        ant_icube_dev.school_marks
),
teacher_age AS (
    SELECT
        teacherid
    FROM
        ant_icube_dev.school_teachers
    WHERE
        DATEDIFF(
            CAST(CURRENT_DATE() AS DATE),
            CAST(dateofbirth AS DATE),
            'dd'
        ) / 365 > 40
),
filtered_marks AS (
    SELECT
        m.subjectid,
        m.markobtained
    FROM
        ant_icube_dev.school_marks m
        INNER JOIN teacher_age t ON m.teacherid = t.teacherid
),
subject_avg AS (
    SELECT
        subjectid,
        AVG(CAST(markobtained AS DOUBLE)) AS subject_avg_mark
    FROM
        filtered_marks
    GROUP BY
        subjectid
)
SELECT
    s.subjectname AS `科目名称`,
    sa.subject_avg_mark AS `平均分`
FROM
    subject_avg sa
    INNER JOIN ant_icube_dev.school_subject s ON sa.subjectid = s.subjectid
WHERE
    sa.subject_avg_mark > (
        select
            avg_mark
        from
            school_avg
    );