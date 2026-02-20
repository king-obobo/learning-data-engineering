with fct_monthly_revenue as (
    select
        pickup_zone,
        revenue_month,
        revenue_monthly_fare,
        revenue_monthly_extra,
        revenue_monthly_mta_tax,
        revenue_monthly_tip_amount,
        revenue_monthly_tolls_amount,
        revenue_monthly_ehail_fee,
        revenue_monthly_improvement_surcharge,
        revenue_monthly_total_amount,
        total_monthly_trips,
        avg_monthly_passenger_count,
        avg_monthly_trip_distance
    from {{ ref('fct_monthly_revenue') }}       
)
select count(*) as total_records from fct_monthly_revenue