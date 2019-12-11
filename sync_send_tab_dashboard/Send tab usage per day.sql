
    select
        submission_date_s3 AS day,
        --app_channel as channel,
        COUNT(CASE WHEN event_object = 'sendcommand' THEN TRUE ELSE NULL END) AS sent,
        COUNT(CASE WHEN event_object = 'processcommand' THEN TRUE ELSE NULL END) AS received
    from telemetry.sync_events_v1
    where submission_date_s3 > '20170801'
    and event_method = 'displayURI'
    group by 1--, 2
