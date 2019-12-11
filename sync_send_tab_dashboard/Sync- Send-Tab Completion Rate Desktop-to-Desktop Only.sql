--select event_category, event_method, event_object, count(*) from sync_events_v1 group by 1,2,3 order by 4 desc

with
    sends as (
        select
        event_flow_id,
        submission_date_s3 as day_sent,
        event_object as sending_event,
        event_device_os as target_os
        from sync_events_v1
        where event_method = 'displayURI'
        and event_object = 'sendcommand'
        and event_device_os is not null
        and event_device_os != 'Android'
        and event_device_os != 'iOS'
        ),

    receives as (
        select
        event_flow_id,
        submission_date_s3 as day_received,
        event_object as receiving_event
        from sync_events_v1
        where event_method = 'displayURI'
        and event_object = 'processcommand'
    ),

    joined as (
        select
        sends.event_flow_id,
        sends.day_sent,
        receives.day_received,
        sends.sending_event,
        receives.receiving_event,
        sends.target_os
        from sends
        left join receives
        on sends.event_flow_id = receives.event_flow_id
    ),

    day_totals as (
        select
        joined.day_sent,
        count(*) as total_sent,
        count(case when receiving_event is not null then True else null end) as total_received
        from joined
        group by 1
        order by 1
    )

select day_totals.day_sent, day_totals.total_sent, day_totals.total_received, (cast(day_totals.total_received as double) / cast(day_totals.total_sent as double)) * 100 as percent_received from day_totals order by 1

    
