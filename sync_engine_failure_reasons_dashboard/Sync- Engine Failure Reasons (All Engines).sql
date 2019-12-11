--select *
select submission_date_s3 as day,
--engine_name as engine,
engine_failure_reason.name as reason,
count(*) count_of_errors
from sync_flat_summary
where engine_name in ('bookmarks','history','tabs','addons','addresses','passwords','logins','prefs') and
engine_failure_reason is not null
group by 1,2
order by 1


--limit 1
