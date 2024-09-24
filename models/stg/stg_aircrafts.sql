select		aircraft_code
 			,model ->> 'en' as model
			,range
from 		{{source('flights', 'aircrafts_data')}}