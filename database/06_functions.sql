-- 8.B. Function to Compute the Age of a Passenger 
 CREATE FUNCTION fn_GetPassengerAge
(
-- Input parameter: the passenger_id for which the age will be calculated
    @passenger_id INT
)
RETURNS INT
AS
BEGIN
-- Declare a variable to store the calculated age
    DECLARE @age INT;
	 -- Select the age using DATEDIFF and adjusting for whether the birthday has already occurred this year
       SELECT @age = DATEDIFF(YEAR, dob, GETDATE())-- Calculate the difference in years between the passenger's date of birth and the current date
    - CASE
	-- Check if the birthday hasn't occurred yet this year, and subtract 1 from the age if true
        WHEN MONTH(dob) > MONTH(GETDATE()) -- If the month of birth is later than the current month
             OR (MONTH(dob) = MONTH(GETDATE()) AND DAY(dob) > DAY(GETDATE())) -- Or if it's the same month but the birthday hasn't occurred yet
        THEN 1 ELSE 0 -- Subtract 1 from the age if the birthday is yet to occur, otherwise, no adjustment needed
      END
    FROM Passengers
    WHERE passenger_id = @passenger_id; -- Filter by the specific passenger id
	-- Return the calculated age
      RETURN @age;
END;
