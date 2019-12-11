
with
    counts as (
        select submission_date_s3 as day,
        --case when app_name like 'Fennec%' then 'Android' when app_name = 'Nightly' then 'Nightly' when app_name like '%Beta' then 'Beta' when app_name = 'Firefox' then 'Desktop' else 'unknown' end as platform,
        engine_failure_reason.name as failure_reason_name,
        count(*) as total,
        count(case when engine_failure_reason is not null then true else null end) as count_errors,
        count(case when engine_failure_reason is null then true else null end) as count_success
        from telemetry.sync_flat_summary
        --where engine_name in ('bookmarks','history','tabs','addons','creditcards','addresses','passwords','logins','prefs')
        where os = 'Android'
        and engine_name = 'passwords'
        group by 1,2
        order by 1
    ),


    rates as (
        select counts.day as day,
        counts.failure_reason_name as failure_reason_name,
        counts.total as total,
        counts.count_errors as errors,
        counts.count_success as success,
        cast(counts.count_errors as double) / cast(counts.total as double) * 100 as error_rate,
        cast(counts.count_success as double) / cast(counts.total as double) * 100 as success_rate
        from counts
        order by 1
    )

select * from rates

--addons, creditcards, addys, logins
--dtop v mobile
--ask kit about sync ordering
-- user input
