with source as (
select
    *,
    now() as created_at
from
    {{ source('flights', 'flights') }}
)

,renamed as (
select
    flight_id
    ,flight_no
    ,aircraft_code

    ,departure_airport
    ,arrival_airport
    ,status

    ,scheduled_departure as scheduled_departure_at
    ,scheduled_arrival as scheduled_arrival_at
    ,actual_departure as actual_departured_at
    ,actual_arrival as actual_arrivaled_at
    ,created_at
from
    source
)

select * from renamed