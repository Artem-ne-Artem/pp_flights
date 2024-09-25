with src_tbl as (
select * from {{ ref('flights') }}
)

,prep_booking as (
select		date(book_date) as date
			,book_id
			,book_amount
			,count(distinct flight_number) as tickets_cnt
from 		src_tbl
group by 	1,2,3
)

,booking as (
select 		date
			,coalesce(count(case when tickets_cnt = 1 then book_id end), 0) as book_one_passenger_cnt
			,coalesce(sum(case when tickets_cnt = 1 then book_amount end), 0) as book_one_passenger_amount
			,coalesce(count(case when tickets_cnt > 1 then book_id end), 0) as book_several_passenger_cnt
			,coalesce(sum(case when tickets_cnt > 1 then book_amount end), 0) as book_several_passenger_amount
			,count(book_id) as book_cnt
			,sum(book_amount) as book_amount
from 		prep_booking
group by 	1
)

,flights as (
select		date(scheduled_departure) as date
			,count(distinct flight_id) as flights_cnt		-- кол-во рейсов (полётов)
			,sum(flight_amount) as flights_amount			-- кол-во билетов (один билет может проходить по нескольким рейсам, если это билет с пересадками)
			,count(ticket_id) as tickets_cnt				-- пассажиропоток
from 		src_tbl
group by 	1
)

select 		coalesce(b.date, f.date) as date
			,coalesce(sum(b.book_one_passenger_cnt), 0) as book_one_passenger_cnt
			,coalesce(sum(b.book_one_passenger_amount), 0) as book_one_passenger_amount
			,coalesce(sum(b.book_several_passenger_cnt), 0) as book_several_passenger_cnt
			,coalesce(sum(b.book_several_passenger_amount), 0) as book_several_passenger_amount
			,coalesce(sum(b.book_cnt), 0) as book_cnt
			,coalesce(sum(b.book_amount), 0) as book_amount
			,coalesce(sum(f.flights_cnt), 0) as flights_cnt
			,coalesce(sum(f.flights_amount), 0) as flights_amount
			,coalesce(sum(f.tickets_cnt), 0) as tickets_cnt
from 		booking as b
full join 	flights as f
			on b.date = f.date
group by 	coalesce(b.date, f.date)