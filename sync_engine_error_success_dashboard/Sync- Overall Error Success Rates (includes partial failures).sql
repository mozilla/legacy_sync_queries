
with
    counts as (
        select submission_date_s3 as day,
        count(*) as total,
        count(case when status is not null then true else null end) as count_errors,
        count(case when status is null then true else null end) as count_success
        from telemetry.sync_summary
        group by 1
        order by 1
    ),


    rates as (
        select counts.day as day,
        counts.total as total,
        counts.count_errors as errors,
        counts.count_success as success,
        cast(counts.count_errors as double) / cast(counts.total as double) * 100 as error_rate,
        cast(counts.count_success as double) / cast(counts.total as double) * 100 as success_rate
        from counts
        order by 1
    )

select * from rates
