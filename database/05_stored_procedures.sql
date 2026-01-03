-- 4.A. Stored procedure to search for passengers by last name 
-- and return their ticket details sorted by latest issue date
	CREATE PROCEDURE SearchPassengersByLastName
    @LastName VARCHAR(50)
	AS
	BEGIN
    SELECT p.passenger_id, p.first_name, p.last_name, t.ticket_id, t.issuedate, t.eboarding_number
    FROM
        Passengers p
    INNER JOIN Reservations r ON p.passenger_id = r.passenger_id
    INNER JOIN PNR pnr ON r.reservation_id = pnr.reservation_id
    INNER JOIN Payments pay ON pay.pnr_id = pnr.pnr_id
    INNER JOIN Ticket_Issuance ti ON ti.payment_id = pay.payment_id
    INNER JOIN Tickets t ON t.ticket_issuance_id = ti.ticket_issuance_id
    WHERE
        p.last_name LIKE '%' + @LastName + '%' -- Match passengers by partial last name
    ORDER BY
        t.issuedate DESC;
	END;

	EXEC SearchPassengersByLastName @lastName = 'White';

-- 4.B. Stored Procedure to search for passengers by last name 
-- and return Business Class passengers with a reservation today and meal preference.
CREATE PROCEDURE GetTodaysBusinessClassMeals1
AS
BEGIN
    SELECT
        p.passenger_id,
        p.first_name,
        p.last_name,
        m.meal_type,
        r.reservation_date, tc.travel_class_name
    FROM
        Passengers p
    INNER JOIN Reservations r ON p.passenger_id = r.passenger_id
    INNER JOIN Travel_Class tc ON r.travel_class_id = tc.travel_class_id
    INNER JOIN Meals m ON r.meal_id = m.meal_id
    WHERE
        tc.travel_class_name = 'Business' -- Filter to include only Business Class passengers
        AND r.reservation_date = CAST(GETDATE() AS DATE); -- Filter to include only reservations made today
END;

EXEC GetTodaysBusinessClassMeals1

-- 4.C. Insert a New Employee into the Database 
CREATE PROCEDURE InsertNewEmployee1
  (@employee_id INT, @first_name VARCHAR(50), @middle_name VARCHAR(50), @last_name VARCHAR(50), @username VARCHAR(50),
    @password VARCHAR(255), @role VARCHAR(50), @email VARCHAR(100), @address_id INT)
AS
BEGIN
    INSERT INTO Employees (employee_id, first_name, middle_name, last_name, username,
        password, role, email, address_id
    )
    VALUES (
        @employee_id, @first_name, @middle_name, @last_name, @username, @password, @role, @email, @address_id
    );
END;

-- Declare a variable to hold the hashed password
DECLARE @hashed_password VARBINARY(256);
-- Generate a SHA2_256 hash of the plain-text password '110303pet_'
SET @hashed_password = HASHBYTES('SHA2_256', CONVERT(VARCHAR(255), '110303pet_'));

EXEC InsertNewEmployee1 @employee_id=011,  @first_name= 'Peter', 
    @middle_name= 'Williams', @last_name ='Zeb', @username ='Zeb55501', @password =@hashed_password,
    @role ='Staff', @email = 'peter.zeb@gmail.com', @address_id =2;

 SELECT * FROM Employees AS E
      WHERE E.employee_id=011;

-- 4.D. Stored Procedure to Update Details of a Passenger Who Has Previously Booked a Flight 
CREATE PROCEDURE UpdatePassengerDetails
    @passenger_id INT, @first_name VARCHAR(50), @middle_name VARCHAR(50),  @last_name VARCHAR(50),
    @email VARCHAR(100), @passport_no VARCHAR(20), @emergency_contact_number VARCHAR(20)
AS
BEGIN
 -- Check if the passenger has at least one reservation
    IF EXISTS (
        SELECT 1 
        FROM Reservations 
        WHERE passenger_id = @passenger_id
    )
    BEGIN
	-- If a reservation exists, update the passenger's details
        UPDATE Passengers
        SET 
            first_name = @first_name, middle_name = @middle_name, last_name = @last_name,
            email = @email, passport_no = @passport_no, emergency_contact_number = @emergency_contact_number
        WHERE 
            passenger_id = @passenger_id;
    END
END;

-- 8.A. Stored Procedure to Report Revenue for Each Flight 
CREATE PROCEDURE sp_GetFlightRevenueReport
AS
BEGIN
-- Disable the message about the number of rows affected for better performance
    SET NOCOUNT ON;
-- Selecting revenue report for each flight
    SELECT
        f.flight_id,
        f.flight_number,
		-- Count the total number of tickets issued for this flight
        COUNT(t.ticket_id) AS total_tickets_issued,
		-- Calculate the total base fare revenue for this flight
        SUM(t.fare) AS base_fare_total,
		-- Calculate the total baggage fees for this flight. If baggage fee is NULL, treat it as 0
        SUM(ISNULL(b.baggage_fee, 0)) AS total_baggage_fee,
		-- Calculate the total meal fees. If a meal is upgraded, charge 20
        SUM(CASE WHEN m.upgraded_meal = 1 THEN 20 ELSE 0 END) AS total_meal_fee,
		-- Calculate the total seat fees for preferred seats charge 30 for preferred seats
        SUM(CASE WHEN s.preferred_seat = 1 THEN 30 ELSE 0 END) AS total_seat_fee, -- Seat fee for preferred seats
        -- Total revenue calculation
        SUM(
            t.fare +
            ISNULL(b.baggage_fee, 0) + -- Base fare
            CASE WHEN m.upgraded_meal = 1 THEN 20 ELSE 0 END +  -- Meal fee for upgraded meals
            CASE WHEN s.preferred_seat = 1 THEN 30 ELSE 0 END
        ) AS total_revenue
    FROM Tickets t
    INNER JOIN Ticket_Issuance ti ON t.ticket_issuance_id = ti.ticket_issuance_id
    INNER JOIN Payments pay ON ti.payment_id = pay.payment_id
    INNER JOIN PNR pnr ON pay.PNR_ID = pnr.PNR_ID
    INNER JOIN Reservations r ON r.reservation_id = pnr.reservation_id
    INNER JOIN Flights f ON r.flight_id = f.flight_id
    LEFT JOIN Baggage b ON r.baggage_id = b.baggage_id
    LEFT JOIN Meals m ON r.meal_id = m.meal_id
    LEFT JOIN Seats s ON r.seat_id = s.seat_id
	-- Group by flight ID and flight number to calculate totals per flight
    GROUP BY f.flight_id, f.flight_number
	-- Order the result by flight ID for better readability
    ORDER BY f.flight_id;
END;
--Stored Procedure to Prevent Double Booking by managing concurrency
CREATE PROCEDURE sp_ReserveSeat
 @reservation_id INT,   @passenger_id INT, @flight_id INT, @seat_id INT,  @travel_class_id INT, @meal_id INT, @baggage_id INT,
 @reservation_status VARCHAR(20) = 'Confirmed'
AS
BEGIN
    SET NOCOUNT ON;

    -- Set highest isolation level to avoid phantom reads
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRANSACTION;

    -- Step 1: Check if seat is available, with row-level lock
    IF EXISTS (
        SELECT 1 
        FROM Seats WITH (UPDLOCK, HOLDLOCK)
        WHERE seat_id = @seat_id AND availability_status = 'Available'
    )
    BEGIN
        -- Step 2: Update seat to reserved
        UPDATE Seats
        SET availability_status = 'Reserved'
        WHERE seat_id = @seat_id;

        -- Step 3: Insert reservation
        INSERT INTO Reservations (reservation_id, passenger_id, flight_id, seat_id, travel_class_id, meal_id, baggage_id,
 reservation_status)
        VALUES (@reservation_id,   @passenger_id, @flight_id, @seat_id,  @travel_class_id, @meal_id, @baggage_id,
 @reservation_status
);

        COMMIT; -- If seat is available
        PRINT 'Seat reserved successfully.';
    END
    ELSE
    BEGIN
        ROLLBACK; -- If seat is unavailable
        PRINT 'Seat is already booked or unavailable.';
    END
END;

 EXEC sp_ReserveSeat @reservation_id=2000,   @passenger_id=104, @flight_id=203, @seat_id=212,  @travel_class_id=1002, @meal_id=211, @baggage_id=231
 
