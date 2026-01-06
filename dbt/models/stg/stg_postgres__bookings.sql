with source as (
select
    *,
    now() as created_at
from
    {{ source('flights', 'bookings') }}
)

,renamed as (
select
    book_ref
    ,book_date as booked_at
    ,total_amount
    ,created_at
from
    source
)

select * from renamed