with
    counts_errors as (
        select submission_date_s3 as day,
        count(distinct uid) as users_affected
        from sync_summary
        where app_version not like '5%'
        and failure_reason is not null
        group by 1
        order by 1
    ),

    counts_total as (
        select submission_date_s3 as day,
        count(distinct uid) as total_users
        from sync_summary
        where app_version not like '5%'
        group by 1
        order by 1
    ),

    rates as (
        select counts_errors.day as day,
        counts_errors.users_affected,
        counts_total.total_users,
        cast(counts_errors.users_affected as double) / cast(counts_total.total_users as double) * 100 as pct_users_affected
        from counts_errors
        inner join counts_total
        on counts_errors.day = counts_total.day
        order by 1
    )

select * from rates
