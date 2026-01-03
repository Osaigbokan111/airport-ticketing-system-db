-- Querying tge Airport_Ticketing_System_DB

-- 3. Selects unique passengers with pending reservations who are older than 40 
SELECT DISTINCT P.passenger_id, P.first_name, P.last_name, P.dob, 
DATEDIFF(YEAR, P.dob, GETDATE()) AS age, R.reservation_status -- Calculates age based on DOB
FROM 
	Passengers  P
JOIN 
	Reservations  R ON P.passenger_id = R.passenger_id
WHERE R.reservation_status= 'Pending' AND
DATEDIFF(YEAR, P.dob, GETDATE()) > 40;

SELECT * FROM Airport_Ticketing_SystemDB1
