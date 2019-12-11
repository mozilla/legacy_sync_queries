-- select i.validation from sync_summary cross join unnest(engines) as t(i) where i.validation is not null limit 1
-- select * from sync_summary limit 1
-- select * from sync_bmk_validation_problems limit 1
with
    validations as (
        select
        sync_summary.submission_date_s3 as day,
        app_channel,
        count (distinct case when i.validation is not null then uid else null end) as n_validated
        from sync_summary
        cross join unnest(engines) as t(i)
        where submission_date_s3 >= '20180101'
        and app_version like '5%'
        and app_name like 'Fennec%'
        group by 1,2
    )

select * from validations
