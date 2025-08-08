with student_total_marks as (
    select
        studentid,
        sum(cast(markobtained as bigint)) as total_marks
    from
        ant_icube_dev.school_marks
    group by
        studentid
    having
        sum(cast(markobtained as bigint)) > 90
)
select
    concat(s.lastname, ' ', s.firstname) as `student_fullname`,
    s.contactnumber as `contactnumber`,
    s.email as `email`,
    s.address as `address`
from
    student_total_marks tm
join
    ant_icube_dev.school_students s
on
    tm.studentid = s.studentid;