--couldn't find a better way to cast the submission date as a proper date... maybe not necessary but it makes the chart look nicer


WITH daydate AS
  (SELECT from_iso8601_date(concat(substr(submission_date_s3,1,4),'-',substr(submission_date_s3,5,2),'-',substr(submission_date_s3,7,2))) AS day,
          uid
   FROM default.sync_events_v1
   WHERE default.sync_events_v1.event_object = 'sendcommand'
   AND default.sync_events_v1.event_method = 'displayURI')

SELECT day,
       count(DISTINCT uid) AS number_of_users
FROM daydate
GROUP BY day HAVING day BETWEEN (CURRENT_DATE - interval '7' DAY) AND CURRENT_DATE
ORDER BY day
