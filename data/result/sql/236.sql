with kenyan_teachers as (
    select 
        teacherid
    from 
        ant_icube_dev.school_teachers
    where 
        address like '%Kenya%'
)
select
    s.subjectname as `科目名称`,
    avg(cast(m.markobtained as double)) as `平均分`
from
    ant_icube_dev.school_marks m
    join kenyan_teachers kt on m.teacherid = kt.teacherid
    join ant_icube_dev.school_subject s on m.subjectid = s.subjectid
group by
    s.subjectname;