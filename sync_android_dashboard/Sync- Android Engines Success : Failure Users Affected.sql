
with
    counts_errors as (
        select submission_date_s3 as day,
        --case when app_name like 'Fennec%' then 'Android' when app_name = 'Nightly' then 'Nightly' when app_name like '%Beta' then 'Beta' when app_name = 'Firefox' then 'Desktop' else 'unknown' end as platform,
        engine_name as engine,
        count(distinct uid) as users_affected
        --count(case when engine_failure_reason is not null then true else null end) as count_errors,
        --count(case when engine_failure_reason is null then true else null end) as count_success
        from telemetry.sync_flat_summary
        where os = 'Android'
        and engine_failure_reason is not null
        --where engine_name in ('bookmarks','history','tabs','addons','creditcards','addresses','passwords','logins','prefs')
        group by 1,2
        order by 1
    ),

    counts_total as (
        select submission_date_s3 as day,
        --case when app_name like 'Fennec%' then 'Android' when app_name = 'Nightly' then 'Nightly' when app_name like '%Beta' then 'Beta' when app_name = 'Firefox' then 'Desktop' else 'unknown' end as platform,
        count(distinct uid) as n_users
        --count(case when engine_failure_reason is not null then true else null end) as count_errors,
        --count(case when engine_failure_reason is null then true else null end) as count_success
        from telemetry.sync_flat_summary
        where os = 'Android'
        --where engine_name in ('bookmarks','history','tabs','addons','creditcards','addresses','passwords','logins','prefs')
        group by 1
        order by 1
    ),

    rates as (
        select counts_errors.day as day,
        counts_errors.engine as engine,
        counts_errors.users_affected as users_affected,
        counts_total.n_users as total_users,
        cast(counts_errors.users_affected as double) / cast(counts_total.n_users as double) * 100 as pct_affected
        from counts_errors
        inner join counts_total
        on counts_errors.day = counts_total.day
--        and counts_errors.engine = counts_total.engine
        order by 1
    )

select * from rates

--addons, creditcards, addys, logins
--dtop v mobile
--ask kit about sync ordering
-- user input
