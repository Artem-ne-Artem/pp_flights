with stg_postgres__ticket_flights as (
    select * from {{ ref ('stg_postgres__ticket_flights') }}
)

,stg_postgres__flights as (
    select * from {{ ref ('stg_postgres__flights') }}
)

,stg_postgres__tickets as (
    select * from {{ ref ('stg_postgres__tickets') }}
)

,stg_postgres__bookings as (
    select * from {{ ref ('stg_postgres__bookings') }}
)

,stg_postgres__boarding_passes as (
    select * from {{ ref ('stg_postgres__boarding_passes') }}
)

,stg_postgres__aircrafts as (
    select * from {{ ref ('stg_postgres__aircrafts') }}
)

,stg_postgres__airports as (
    select * from {{ ref ('stg_postgres__airports') }}
)

,stg_postgres__seats as (
    select * from {{ ref ('stg_postgres__seats') }}
)

,aircrafts as (
    select		
        a.aircraft_code
        ,a.model
        ,a.range 
        ,count(case when s.fare_conditions = 'Business' then s.seat_no end) as seats_business_cnt
        ,count(case when s.fare_conditions <> 'Business' then s.seat_no end) as seats_comfort_economy_cnt
        ,count(s.seat_no) as seats_cnt                      
    from
        stg_postgres__seats as s
    left join
        stg_postgres__aircrafts as a
        on s.aircraft_code = a.aircraft_code
    group by
        1,2,3
)

select
    -- аттрибут бронирования
    b.book_ref as book_id
    ,b.booked_at
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
    ,f.scheduled_departure_at
    ,f.scheduled_arrival_at
    ,f.scheduled_arrival_at - f.scheduled_departure_at as scheduled_duration
    ,f.status
    ,f.actual_departured_at
    ,f.actual_arrivaled_at
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
    ,a.range
from
    stg_postgres__ticket_flights as tf
-- в flights есть рейсы которых нет в ticket_flights
join
    stg_postgres__flights as f
    on tf.flight_id = f.flight_id
join
    stg_postgres__tickets as t
    on tf.ticket_no = t.ticket_no
left join
    stg_postgres__bookings as b
    on t.book_ref = b.book_ref
left join
    stg_postgres__boarding_passes as bp
    on tf.ticket_no = bp.ticket_no
    and tf.flight_id = bp.flight_id
left join
    aircrafts as a
    on f.aircraft_code = a.aircraft_code
left join
    stg_postgres__airports as ap
    on f.departure_airport = ap.airport_code
left join
    stg_postgres__airports as ap2
    on f.arrival_airport = ap2.airport_code