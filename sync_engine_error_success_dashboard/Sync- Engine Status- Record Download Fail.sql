--select *
select submission_date_s3 as day,
engine_name as engine,
engine_status as status,
count(*) count_of_errors
from sync_flat_summary
where engine_name in ('bookmarks','history','tabs','addons','addresses','passwords','logins','prefs') and
engine_failure_reason is not null
group by 1,2,3
--having engine_status = 'error.sync.reason.version_out_of_date'
having engine_status = 'error.engine.reason.record_download_fail'
--having engine_status = 'error.engine.reason.batch_interrupted'
--having engine_status = 'error.engine.reason.unknown_fail'
--having engine_status = 'error.engine.reason.record_upload_fail'
--having engine_status = 'error.engine.reason.apply_fail'
order by 1
--limit 1
