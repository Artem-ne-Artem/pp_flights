select		a.aircraft_code
 			,a.model ->> 'en' as model
			,a.range 
			,count(case when s.fare_conditions = 'Business' then s.seat_no end) as seats_business_cnt
			,count(case when s.fare_conditions <> 'Business' then s.seat_no end) as seats_comfort_economy_cnt
			,count(s.seat_no) as seats_cnt                      
from 		{{source('flights', 'seats')}} as s
left join   {{source('flights', 'aircrafts_data')}} as a
            on s.aircraft_code = a.aircraft_code
group by 	1,2,3