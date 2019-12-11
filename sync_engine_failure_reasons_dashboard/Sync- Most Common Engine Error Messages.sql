select submission_date_s3 as day, engine_failure_reason.value, count(distinct uid) as affected_users, count(*) as total_errors
from sync_flat_summary
where engine_failure_reason is not null
and engine_failure_reason.value like '%Error%'
group by 1,2
having count(*) > 999
order by 1, 2 desc
