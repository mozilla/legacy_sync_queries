
with
    counts_errors as (
        select submission_date_s3 as day,
        engine_failure_reason.value as reason_value,
        count(distinct uid) as users_affected
        from telemetry.sync_flat_summary
        where os = 'Android'
        and engine_failure_reason is not null
        group by 1,2
        order by 1
    ),

    counts_total as (
        select submission_date_s3 as day, 
        count(distinct uid) as n_users
        from telemetry.sync_flat_summary
        where os = 'Android'
        group by 1
        order by 1
    ),


    rates as (
        select counts_errors.day as day,
        counts_errors.reason_value,
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
