with
    probs as (select
        *,
        case when p.app_version like '8.%' or p.app_version like '9.%' or p.app_version like '10.%' then 'ios' when (p.app_version like '5%' and app_name not like 'Fenn%') then 'desktop' when app_name like 'Fenn%' then 'android' else null end as platform
        from sync_bmk_validation_problems p
    ),

    -- this part de-dupes multiple submissions from the same client that have the same problem type and problem count in the same day
    d_sub as (select uid,
            submission_day as day,
            engine_validation_problem_name,
            engine_validation_problem_count,
            sum(engine_validation_problem_count) / count(engine_validation_problem_count) as problem_count
            from probs where platform = 'ios'
            group by 1,2,3,4
        ),

    affected_users as (select submission_day as day,
            engine_validation_problem_name,
            count(distinct uid) as users_affected
            from probs
            group by 1,2
        ),

    problems_per_day as (select d_sub.day,
            d_sub.engine_validation_problem_name,
            sum(problem_count) as count_problems,
            avg(problem_count) as avg_prob,
            min(problem_count) as min_prob,
            max(problem_count) as max_prob,
            STDDEV_POP(problem_count) as std_prob
            from d_sub
            group by 1,2 order by 1
        )

select problems_per_day.*,
affected_users.users_affected,
cast(problems_per_day.count_problems as double) / cast(affected_users.users_affected as double) as problems_per_user
from problems_per_day
inner join affected_users
on problems_per_day.day = affected_users.day
and problems_per_day.engine_validation_problem_name = affected_users.engine_validation_problem_name
