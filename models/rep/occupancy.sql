select			flight_number
				,departure_city
				,arrival_city
				,departure_airport
				,arrival_airport
				,extract(hour from scheduled_departure) as hour_scheduled_departure
				,extract(hour from scheduled_arrival) as hour_scheduled_arrival
				,ceil(trunc(extract(epoch from (scheduled_arrival - scheduled_departure)) / 60) / 60) as duration_hours
				,aircraft_model
				,seats_cnt
				,seats_business_cnt
				,count(ticket_id) as seats_cnt_boarding
				,count(case when fare_conditions = 'Business' then ticket_id end) as seats_business_cnt_boarding
				,count(distinct flight_id) as flight_cnt
from            {{ ref('flights') }}
group by 		flight_number
				,departure_city
				,arrival_city
				,departure_airport
				,arrival_airport
				,extract(hour from scheduled_departure)
				,extract(hour from scheduled_arrival)				
				,ceil(trunc(extract(epoch from (scheduled_arrival - scheduled_departure)) / 60) / 60)
				,aircraft_model
				,seats_cnt
				,seats_business_cnt