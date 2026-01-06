with source as (
select
    *,
    now() as created_at
from
    {{ source('flights', 'tickets') }}
)

,renamed as (
select
    ticket_no
    ,book_ref
    ,passenger_id
    ,passenger_name
    ,contact_data
    ,contact_data ->> 'phone' as phone
    ,contact_data ->> 'email' as email
    ,created_at
from
    source
)

select * from renamed