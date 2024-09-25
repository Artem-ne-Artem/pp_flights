with src_tbl as (
select		book_id
			,book_date
			,ticket_id
			,flight_id
			,scheduled_departure
			,departure_airport
			,row_number() over(partition by book_id, ticket_id order by scheduled_departure asc) as rn
from 		{{ ref('flights') }}
)

select 		date(date_trunc('month' ,book_date)) as book_dt
			,date(date_trunc('month' ,scheduled_departure)) as scheduled_departure_dt
			,count(ticket_id) as ticket_cnt
from		src_tbl
where 		rn = 1
group by 	1,2