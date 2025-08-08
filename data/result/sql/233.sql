with TeacherStudentAvg as (
    select 
        m.teacherid,
        avg(cast(m.markobtained as double)) as student_avg
    from 
        ant_icube_dev.school_marks m
    inner join 
        ant_icube_dev.school_students s 
    on 
        m.studentid = s.studentid
    group by 
        m.teacherid
    having 
        avg(cast(m.markobtained as double)) > 85
)
select distinct
    concat(t.lastname,' ',t.firstname) as `教师姓名`
from 
    ant_icube_dev.school_teachers t
inner join 
    TeacherStudentAvg a 
on 
    t.teacherid = a.teacherid;