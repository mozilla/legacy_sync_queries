with
    probs as (select
        *,
        case when p.app_version like '8.%' or p.app_version like '9.%' or p.app_version like '10.%' then 'ios' when (p.app_version like '5%' and app_name not like 'Fenn%') then 'desktop' when app_name like 'Fenn%' then 'android' else null end as platform
        from sync_bmk_validation_problems p
        where p.submission_day > '20171110'
        --and p.app_version like '5%' and app_name not like 'Fenn%'
    ),

    -- this part de-dupes multiple submissions from the same client that have the same problem type and problem count in the same day
    d_sub as (select uid,
            submission_day as day,
            platform,
            --engine_validation_problem_name,
            engine_validation_problem_count,
            sum(engine_validation_problem_count) / count(engine_validation_problem_count) as problem_count
            from probs --where platform = 'desktop'
            where submission_day > '20171110'
            group by 1,2,3,4
        ),

    affected_users as (select submission_day as day,
            platform,
            --engine_validation_problem_name,
            count(distinct uid) as users_affected
            from probs
            group by 1,2
        ),

    problems_per_day as (select d_sub.day,
            platform,
            --d_sub.engine_validation_problem_name,
            sum(problem_count) as count_problems
            --avg(problem_count) as avg_prob,
            --min(problem_count) as min_prob,
            --max(problem_count) as max_prob
            --STDDEV_POP(problem_count) as std_prob
            from d_sub
            group by 1,2 order by 1
        ),

    validated_by_platform AS (
      SELECT
      	uid,
      	case when app_version like '8.%' or app_version like '9.%' or app_version like '10.%' then 'ios' when (app_version like '5%' and app_name not like 'Fenn%') then 'desktop' when app_name like 'Fenn%' then 'android' else null end as platform,
      	submission_date_s3 AS day,
      	engine
      FROM sync_summary
      CROSS JOIN UNNEST(engines) AS t (engine)
      where submission_date_s3 > '20171110'
      --and app_version like '5%' and app_name not like 'Fenn%'
    ),

    desktop_validated as (select
    day,
    platform,
    count(distinct uid) as count_users
    from validated_by_platform where engine.validation is not null group by 1,2
    )

select problems_per_day.*,
affected_users.users_affected,
cast(problems_per_day.count_problems as double) / cast(desktop_validated.count_users as double) as problems_per_user,
desktop_validated.count_users,
cast(affected_users.users_affected as double) / cast (desktop_validated.count_users as double) as prop_users_affected
from problems_per_day
inner join affected_users
on problems_per_day.day = affected_users.day
and problems_per_day.platform = affected_users.platform
inner join desktop_validated
on problems_per_day.day = desktop_validated.day
and problems_per_day.platform = desktop_validated.platform
