/*
with src_ticket_flights as (
    select * from {{ source('flights', 'ticket_flights') }}
)

,src_flights as (
    select * from {{ source('flights', 'flights') }}
)

,src_tickets as (
    select * from {{ source('flights', 'tickets') }}
)

,src_bookings as (
    select * from {{ source('flights', 'bookings') }}
)

,src_boarding_passes as (
    select * from {{ source('flights', 'boarding_passes') }}
)

select 		
			-- аттрибут бронирования
			b.book_ref as book_id
			,b.book_date
			,b.total_amount as book_amount
			-- атрибуты пассажира
			,t.passenger_id			
			-- атрибуты перелёта
			,tf.ticket_no as ticket_id
			,tf.fare_conditions
			,tf.amount as flight_amount
			-- атрибуты посадочного талона
			,bp.boarding_no
			-- атрибуты рейса
			,tf.flight_id
			,f.flight_no as flight_number 
			,count(case when tf.fare_conditions = 'Business' then bp.seat_no end) over (partition by tf.flight_id) as book_business_seats_per_flight_cnt
			,count(bp.seat_no) over (partition by tf.flight_id) as book_seats_per_flight_cnt			
			,f.scheduled_departure
			,f.scheduled_arrival
			,f.scheduled_arrival - f.scheduled_departure as scheduled_duration
			,f.status
			,f.actual_departure
			,f.actual_arrival
			-- атрибуты аэропорта
			,f.departure_airport
			,ap.city as departure_city
			,f.arrival_airport
			,ap2.city as arrival_city
			-- атрибуты самолёта
			,f.aircraft_code
			,a.model as aircraft_model
			,a.seats_cnt
			,a.seats_business_cnt
			,a."range"
from 		src_ticket_flights as tf
-- в flights есть рейсы которых нет в ticket_flights
join 		src_flights as f
			on tf.flight_id = f.flight_id
join 		src_tickets as t
			on tf.ticket_no = t.ticket_no
left join 	src_bookings as b
			on t.book_ref = b.book_ref
left join 	src_boarding_passes as bp
			on tf.ticket_no = bp.ticket_no
			and tf.flight_id = bp.flight_id
            
left join 	{{ ref('stg_aircrafts') }} as a
			on f.aircraft_code = a.aircraft_code
left join 	{{ ref('stg_airports') }} as ap
			on f.departure_airport = ap.airport_code
left join 	{{ ref('stg_airports') }} as ap2
			on f.arrival_airport = ap2.airport_code
*/

select 1