WITH StudentMarks AS (
    SELECT
        s.address,
        s.firstname,
        s.lastname,
        s.studentid,
        m.markobtained
    FROM
        ant_icube_dev.school_students s
        JOIN ant_icube_dev.school_marks m ON s.studentid = m.studentid
),
RegionAverage AS (
    SELECT
        address,
        AVG(CAST(markobtained AS BIGINT)) AS avg_mark
    FROM
        StudentMarks
    GROUP BY
        address
),
RankedStudents AS (
    SELECT
        sm.address,
        sm.firstname,
        sm.lastname,
        sm.studentid,
        sm.markobtained,
        ROW_NUMBER() OVER (
            PARTITION BY sm.address
            ORDER BY
                CAST(sm.markobtained AS BIGINT) DESC
        ) AS rn
    FROM
        StudentMarks sm
        JOIN RegionAverage ra ON sm.address = ra.address
    WHERE
        CAST(sm.markobtained AS BIGINT) > ra.avg_mark
)
SELECT
    rs.address AS `地区`,
    rs.firstname AS `名字`,
    rs.lastname AS `姓氏`,
    rs.studentid AS `学生ID`,
    rs.markobtained AS `成绩`
FROM
    RankedStudents rs
WHERE
    rs.rn <= 2;