with
    probs as (
        select
        *
        from sync_bmk_validation_problems p
        where submission_day >= '20180101'
        and app_version like '5%'
        and app_name like 'Fennec%'
    ),

    affected_users as (
        select
        submission_day as day,
        engine_validation_problem_name,
        count(distinct uid) as users_affected
        from probs
        group by 1,2
    ),

    validations as (
        select
        sync_summary.submission_date_s3 as day,
        count (distinct case when i.validation is not null then uid else null end) as n_validated
        from sync_summary
        cross join unnest(engines) as t(i)
        where submission_date_s3 >= '20180101'
        and app_version like '5%'
        and app_name like 'Fennec%'
        group by 1
    )

select affected_users.day,
affected_users.engine_validation_problem_name,
affected_users.users_affected,
validations.n_validated as total_validated,
cast(affected_users.users_affected as double) / cast(validations.n_validated as double) * 100 as pct_users_affected
from affected_users
inner join validations
on affected_users.day = validations.day
