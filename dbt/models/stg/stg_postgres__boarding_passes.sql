select
    *,
    now() as created_at
from
    {{ source('flights', 'boarding_passes') }}