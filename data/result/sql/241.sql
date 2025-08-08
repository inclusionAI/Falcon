with joined_marks as (
    select
        m.teacherid,
        m.studentid,
        m.subjectid,
        cast(m.markobtained as int) as markobtained,
        t.firstname as teacher_firstname,
        t.lastname as teacher_lastname
    from
        ant_icube_dev.school_marks m
        join ant_icube_dev.school_teachers t on m.teacherid = t.teacherid
),
student_max_marks as (
    select
        teacherid,
        teacher_firstname,
        teacher_lastname,
        studentid,
        max(markobtained) as max_mark
    from
        joined_marks
    group by
        teacherid,
        teacher_firstname,
        teacher_lastname,
        studentid
),
ranked_records as (
    select
        jm.teacherid,
        smm.teacher_firstname,
        smm.teacher_lastname,
        s.studentid,
        s.firstname as student_firstname,
        s.lastname as student_lastname,
        jm.markobtained,
        sub.subjectname,
        row_number() over (
            partition by jm.teacherid
            order by
                jm.markobtained desc
        ) as rn
    from
        student_max_marks smm
        join joined_marks jm on smm.teacherid = jm.teacherid
        and smm.studentid = jm.studentid
        and smm.max_mark = jm.markobtained
        join ant_icube_dev.school_students s on jm.studentid = s.studentid
        join ant_icube_dev.school_subject sub on jm.subjectid = sub.subjectid
)
select
    concat(teacher_firstname, ' ', teacher_lastname) as `老师姓名`,
    concat(student_firstname, ' ', student_lastname) as `学生姓名`,
    markobtained as `成绩`,
    subjectname as `科目名称`
from
    ranked_records
where
    rn = 1;