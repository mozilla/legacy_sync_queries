
with
    counts_errors as (
        select submission_date_s3 as day,
        count(*) as count_errors
        from sync_summary
        where os = 'Android'
        and failure_reason is not null
        group by 1
        order by 1
    ),

    counts_total as (
        select submission_date_s3 as day,
        count(*) as counts_total
        from sync_summary
        where os = 'Android'
        group by 1
        order by 1
    ),

    rates as (
        select counts_errors.day as day,
        counts_errors.count_errors,
        counts_total.counts_total,
        cast(counts_errors.count_errors as double) / cast(counts_total.counts_total as double) * 100 as error_rate
        from counts_errors
        inner join counts_total
        on counts_errors.day = counts_total.day
        order by 1
    )

select * from rates

--addons, creditcards, addys, logins
--dtop v mobile
--ask kit about sync ordering
-- user input
