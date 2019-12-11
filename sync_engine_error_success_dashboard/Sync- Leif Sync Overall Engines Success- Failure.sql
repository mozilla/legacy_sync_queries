
with
    counts as (
        select submission_date_s3 as day,
--        case when app_name like 'Fennec%' then 'Android' when app_name = 'Nightly' then 'Nightly' when app_name like '%Beta' then 'Beta' when app_name = 'Firefox' then 'Desktop' else 'unknown' end as platform,
        engine_name as engine,
        count(*) as total,
        count(case when engine_status is not null then true else null end) as count_errors,
        count(case when engine_status is null then true else null end) as count_success
        from telemetry.sync_flat_summary
        where engine_name in ('bookmarks','history','tabs','addons','addresses','passwords','prefs')
        and cast(submission_date_s3 as integer) >= 20170619
        group by 1,2--,3
        order by 1
    ),


    rates as (
        select counts.day as day,
        --counts.platform as platform,
        counts.engine as engine,
        counts.total as total,
        counts.count_errors as errors,
        counts.count_success as success,
        cast(counts.count_errors as double) / cast(counts.total as double) * 100 as error_rate,
        cast(counts.count_success as double) / cast(counts.total as double) * 100 as success_rate
        from counts
        --where counts.platform = 'Android'
        order by 1
    )

select * from rates

--addons, creditcards, addys, logins
--dtop v mobile
--ask kit about sync ordering
-- user input
