--couldn't find a better way to cast the submission date as a proper date... maybe not necessary but it makes the chart look nicer


WITH sends AS
  (SELECT from_iso8601_date(concat(substr(submission_date_s3,1,4),'-',substr(submission_date_s3,5,2),'-',substr(submission_date_s3,7,2))) AS day, uid
   FROM default.sync_events_v1
   WHERE default.sync_events_v1.event_object = 'sendcommand'
   AND default.sync_events_v1.event_method = 'displayURI'),

dev_counts AS
    (SELECT uid,
        count(distinct device_id) as dev_count
    FROM default.sync_events_v1
    GROUP BY 1)

SELECT sends.day,
       dev_counts.dev_count,
       count(distinct sends.uid) as users
FROM sends
inner join dev_counts
on sends.uid = dev_counts.uid
WHERE dev_counts.dev_count < 5
GROUP BY sends.day, dev_counts.dev_count
HAVING sends.day BETWEEN (CURRENT_DATE - interval '7' DAY) AND CURRENT_DATE
ORDER BY sends.day
