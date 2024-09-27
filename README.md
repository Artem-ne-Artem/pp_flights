## Pet project. Build reporting flights.

#### The project is based on training database "Flights".
- DWH – cloud Postgres
- Transformations – dbt
- Documentation – dbt
- Jobs – dbt
#### Layers:
- Stg – basic transformations
- Cdm – common data marts
- Rep – layer for BI services

[DBT project documentation](https://zb975.us1.dbt.com/accounts/70403103945566/runs/70403122813601/docs/#!/model/model.dbt_flights.flights)

#### Description database
A single booking can include multiple tickets, one for each passenger, each of which is issued a separate ticket (tickets).

A ticket includes one or more flights (ticket_flights).

Multiple flights can be included in a ticket when there is no direct flight connecting the departure and destination points (flight with transfers), or when the ticket is taken "round trip".

Each flight (flights) goes from one airport (airports) to another. Flights with the same number have the same departure and destination points, but will differ in departure date.

![flights_schema_en](https://github.com/user-attachments/assets/750ecb13-340c-4aa5-b558-b0482f9077ee)
