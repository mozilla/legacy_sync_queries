--select *
select submission_date_s3 as day,
case when engine_name is null then 'no_engine' else engine_name end as engine,
count(*) as count_of_errors
from sync_flat_summary
where failure_reason is not null
group by 1,2

order by 1
--limit 1
