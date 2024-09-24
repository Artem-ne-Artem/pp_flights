select		airport_code
			,airport_name ->> 'en' as airport_name
			,city ->> 'en' as city
			,coordinates
			,timezone
from 		{{source('flights', 'airports_data')}}