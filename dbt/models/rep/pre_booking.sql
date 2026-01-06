with src_tbl as (
    select * from {{ ref('flights') }}
)

,flights_with_rn as (
select		book_id
			,booked_at
			,ticket_id
			,flight_id
			,scheduled_departure_at
			,departure_airport
			,row_number() over(partition by book_id, ticket_id order by scheduled_departure_at asc) as rn
from 		src_tbl
)

select 		date(date_trunc('month' ,booked_at)) as book_dt
			,date(date_trunc('month' ,scheduled_departure_at)) as scheduled_departure_dt
			,count(ticket_id) as ticket_cnt
from		flights_with_rn
where 		rn = 1
group by 	1, 2