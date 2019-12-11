
WITH platform AS (
  SELECT
  	uid,
    case when app_version like '8.%' or app_version like '9.%' or app_version like '10.%' then 'ios' when (app_version like '5%' and app_name not like 'Fenn%') then 'desktop' when app_name like 'Fenn%' then 'android' else null end as platform,
    --app_channel,
  	submission_date_s3 AS day,
  	engines
  FROM sync_summary
  where submission_date_s3 > '20171108'
  --and app_version like '5%'
  --and os not like 'And%'
  --LIMIT 1000000
),

platform_engines as (SELECT
    *
    from platform
    CROSS JOIN UNNEST(engines) AS t (engine)
)

 --ios as (SELECT day, count(distinct uid) as count_users from validated_by_platform where engine.validation is not null and platform = 'ios' group by 1)--,
 --desktop as (SELECT day, count(distinct uid) as count_users from validated_by_platform where engine.validation is not null and platform = 'desktop' group by 1)
 --select ios.*, desktop.count_users from ios inner JOIN desktop on ios.day = desktop.day
 --select * from ios
 SELECT day, platform, count(distinct uid) as count_users from platform_engines where engine.validation is not null group by 1,2
 --select * from desktop_engines limit 1
 --select * from desktop limit 1
 --select * from desktop
 --select distinct app_name from sync_summary
