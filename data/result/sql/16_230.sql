with cte_student_marks as (
    select
        s.subjectid,
        s.subjectname,
        m.markobtained,
        m.studentid,
        st.firstname,
        st.lastname
    from
        ant_icube_dev.school_marks m
        join ant_icube_dev.school_subject s on m.subjectid = s.subjectid
        join ant_icube_dev.school_students st on m.studentid = trim(st.studentid)
),
cte_ranked_marks as (
    select
        subjectname,
        concat(firstname, ' ', lastname) as student_fullname,
        cast(markobtained as bigint) as markobtained,
        row_number() over (
            partition by subjectid
            order by cast(markobtained as bigint) desc
        ) as ranking
    from
        cte_student_marks
)
select
    subjectname as `科目名称`,
    student_fullname as `学生姓名`,
    markobtained as `成绩`
from
    cte_ranked_marks
where
    ranking <= 2;