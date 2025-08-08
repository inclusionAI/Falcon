with LatestExam as (
    select 
        studentid,
        subjectid,
        max(examdate) as latest_examdate
    from 
        ant_icube_dev.school_marks
    group by 
        studentid, 
        subjectid
),
MaxMarks as (
    select 
        m.studentid,
        m.subjectid,
        max(cast(m.markobtained as int)) as max_mark
    from 
        ant_icube_dev.school_marks m
    inner join LatestExam le 
        on m.studentid = le.studentid 
        and m.subjectid = le.subjectid 
        and m.examdate = le.latest_examdate
    group by 
        m.studentid, 
        m.subjectid
),
StudentSubjects as (
    select 
        mm.studentid,
        mm.subjectid,
        sub.subjectname,
        mm.max_mark
    from 
        MaxMarks mm
    inner join ant_icube_dev.school_subject sub 
        on mm.subjectid = sub.subjectid
),
RankedSubjects as (
    select 
        studentid,
        subjectid,
        subjectname,
        max_mark,
        dense_rank() over (partition by subjectid order by max_mark desc) as rank_num
    from 
        StudentSubjects
),
TopSubjects as (
    select 
        studentid,
        count(*) as high_score_count
    from 
        RankedSubjects
    where 
        rank_num = 1
    group by 
        studentid
)
select 
    st.studentid as `studentid`,
    st.firstname as `firstname`,
    st.lastname as `lastname`,
    ts.high_score_count as `high_score_subject_count`,
    case 
        when ts.high_score_count > 2 then 'Yes' 
        else 'No' 
    end as `exceeds_two`
from 
    TopSubjects ts
inner join ant_icube_dev.school_students st 
    on ts.studentid = st.studentid;