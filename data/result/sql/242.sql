with -- 获取教师Joseph的teacherid
teachers_cte as (
    select
        teacherid
    from
        ant_icube_dev.school_teachers
    where
        firstname = 'Joseph'
),
-- 获取斯瓦希里语科目subjectid
subjects_cte as (
    select
        subjectid
    from
        ant_icube_dev.school_subject
    where
        subjectname = 'Swahili'
),
-- 关联成绩表和学生表
base_data as (
    select
        m.markobtained,
        m.studentid,
        s.firstname,
        s.lastname
    from
        ant_icube_dev.school_marks m
        inner join teachers_cte t on m.teacherid = t.teacherid
        inner join subjects_cte sub on m.subjectid = sub.subjectid
        inner join ant_icube_dev.school_students s on m.studentid = s.studentid
),
-- 计算科学科目平均分
avg_score as (
    select
        avg(cast(markobtained as double)) as avg_mark
    from
        base_data
) -- 筛选高于平均分的记录
select
    markobtained as `markobtained`,
    studentid as `studentid`,
    firstname as `firstname`,
    lastname as `lastname`
from
    base_data
where
    cast(markobtained as double) > (select avg_mark from avg_score);