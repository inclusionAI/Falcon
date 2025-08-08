with math_student_marks as (
    select
        m.studentid,
        m.markobtained,
        s.address
    from
        ant_icube_dev.school_marks m
        join ant_icube_dev.school_subject sub on m.subjectid = sub.subjectid
        join ant_icube_dev.school_students s on m.studentid = s.studentid
    where
        sub.subjectname = 'Mathematics'
),
city_avg_marks as (
    select
        split(t1.address, ',') [0] as city,
        avg(cast(t1.markobtained as double)) as avg_score
    from
        math_student_marks t1
    group by
        split(t1.address, ',') [0]
)
select
    s.studentid as `学生id`,
    cast(m.markobtained as double) - c.avg_score as `分数差异`
from
    math_student_marks m
    join ant_icube_dev.school_students s on m.studentid = s.studentid
    join city_avg_marks c on split(m.address, ',') [0] = c.city;