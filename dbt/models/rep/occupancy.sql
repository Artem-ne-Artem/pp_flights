with src_tbl as (
    select * from {{ ref('flights') }}
)

select			flight_number
				,departure_city
				,arrival_city
				,departure_airport
				,arrival_airport
				,extract(hour from scheduled_departure_at) as hour_scheduled_departure
				,extract(hour from scheduled_arrival_at) as hour_scheduled_arrival
				,ceil(trunc(extract(epoch from (scheduled_arrival_at - scheduled_departure_at)) / 60) / 60) as duration_hours
				,aircraft_model
				,seats_cnt
				,seats_business_cnt
				,count(ticket_id) as seats_cnt_boarding
				,count(case when fare_conditions = 'Business' then ticket_id end) as seats_business_cnt_boarding
				,count(distinct flight_id) as flight_cnt
from            src_tbl
group by 		1,2,3,4,5,6,7,8,9,10,11