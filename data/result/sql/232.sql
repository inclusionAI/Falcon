with max_marks as (
    select
        subjectid,
        max(cast(markobtained as bigint)) as max_mark
    from
        ant_icube_dev.school_marks
    group by
        subjectid
),
ranked_marks as (
    select
        m.subjectid,
        m.markobtained,
        m.teacherid,
        row_number() over (
            partition by m.subjectid
            order by cast(m.markobtained as bigint) desc
        ) as rn
    from
        ant_icube_dev.school_marks m
    inner join
        max_marks mm
        on m.subjectid = mm.subjectid
        and cast(m.markobtained as bigint) = mm.max_mark
)
select
    s.subjectname as `科目名称`,
    rm.markobtained as `最高分数`,
    concat(t.lastname,' ',t.firstname) as `教师姓名`
from
    ranked_marks rm
inner join
    ant_icube_dev.school_subject s
    on rm.subjectid = s.subjectid
inner join
    ant_icube_dev.school_teachers t
    on rm.teacherid = t.teacherid
where
    rm.rn = 1;