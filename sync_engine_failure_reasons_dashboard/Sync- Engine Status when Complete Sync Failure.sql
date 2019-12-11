--select *
select submission_date_s3 as day,
case when engine_status is null then 'no_status' else engine_status end as status,
count(*) count_of_errors
from sync_flat_summary
where failure_reason is not null
group by 1,2

order by 1
--limit 1
