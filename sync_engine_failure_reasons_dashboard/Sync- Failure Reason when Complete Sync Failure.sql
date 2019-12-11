--select *
select submission_date_s3 as day,
case when failure_reason is null then 'no_reason' else failure_reason.name end as reason,
count(*) count_of_errors
from sync_flat_summary
where failure_reason is not null
group by 1,2

order by 1
--limit 1
