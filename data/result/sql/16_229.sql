with cte_teacher_marks as (
    select
        m.teacherid,
        m.subjectid,
        cast(m.markobtained as double) as mark_value
    from
        ant_icube_dev.school_marks m
        join ant_icube_dev.school_subject s on m.subjectid = s.subjectid
        join ant_icube_dev.school_teachers t on m.teacherid = t.teacherid
)
select
    concat(t.lastname, ' ', t.firstname) as `教师姓名`,
    s.subjectname as `科目名称`,
    avg(ct.mark_value) as `平均分`
from
    cte_teacher_marks ct
    join ant_icube_dev.school_teachers t on ct.teacherid = t.teacherid
    join ant_icube_dev.school_subject s on ct.subjectid = s.subjectid
group by
    `教师姓名`,
    `科目名称`;