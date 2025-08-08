with avg_mark as (
    select avg(cast(markobtained as double)) as avg
    from ant_icube_dev.school_marks
),
high_marks as (
    select 
        m.teacherid,
        m.studentid
    from ant_icube_dev.school_marks m
    where cast(m.markobtained as double) > (select avg from avg_mark)
),
teacher_student_count as (
    select 
        teacherid,
        count(distinct studentid) as high_score_students
    from high_marks
    group by teacherid
),
teacher_info as (
    select 
        t.teacherid,
        t.firstname,
        t.lastname,
        t.email,
        t.contactnumber,
        t.dateofbirth,
        t.address,
        coalesce(ts.high_score_students, 0) as high_score_students
    from ant_icube_dev.school_teachers t
    left join teacher_student_count ts
    on t.teacherid = ts.teacherid
)
select
    teacherid as `teacherid`,
    firstname as `firstname`,
    lastname as `lastname`,
    email as `email`,
    contactnumber as `contactnumber`,
    dateofbirth as `dateofbirth`,
    address as `address`,
    high_score_students as `high_score_students`,
    rank() over (order by high_score_students desc) as `rank`
from teacher_info;