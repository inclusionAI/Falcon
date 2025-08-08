with 
StudentSubjectMax as (
    select 
        m.studentid,
        m.subjectid,
        max(cast(m.markobtained as int)) as max_score
    from 
        ant_icube_dev.school_marks m
    inner join ant_icube_dev.school_subject sub on m.subjectid = sub.subjectid
    group by 
        m.studentid, 
        m.subjectid
),
RankedStudents as (
    select 
        studentid,
        subjectid,
        max_score,
        row_number() over (
            partition by subjectid 
            order by max_score desc, studentid asc
        ) as rank
    from 
        StudentSubjectMax
),
TopStudents as (
    select 
        studentid,
        subjectid,
        max_score
    from 
        RankedStudents
    where 
        rank <= 3
)
select 
    sub.subjectname as `科目名称`,
    avg(ts.max_score) as `平均分`
from 
    TopStudents ts
inner join ant_icube_dev.school_subject sub on ts.subjectid = sub.subjectid
group by 
    sub.subjectname;