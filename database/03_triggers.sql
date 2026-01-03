-- Create triggers
-- Calculates extra baggage fee after inserting or updating a baggage record
CREATE TRIGGER trg_CalculateExtraBaggageFee
ON Baggage
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
-- Update the baggage fee if extra baggage is flagged and weight exceeds 45 kg
    UPDATE B
    SET baggage_fee =
        CASE
            WHEN I.is_extra_baggage = 1 AND I.baggage_weight > 45
            THEN (I.baggage_weight - 45) * 100 -- Fee = excess weight * 100
            ELSE 0
        END
    FROM Baggage B
    INNER JOIN inserted I ON B.baggage_id = I.baggage_id;
END;

-- Sets the meal fee to 20 if it is an upgraded meal
CREATE TRIGGER trg_SetUpgradedMealFee
ON Meals
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
-- Automatically set meal fee to 20 for upgraded meals
    UPDATE M
    SET meal_fee =
        CASE
            WHEN I.upgraded_meal = 1 THEN 20
            ELSE I.meal_fee  -- Keep existing fee if not upgraded
        END
    FROM Meals M
    INNER JOIN inserted I ON M.meal_id = I.meal_id;
END;

--Executes after a new reservation is inserted
CREATE TRIGGER trg_AfterReservationInsert
ON Reservations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update seat availability to 'Reserved'
    UPDATE S
    SET availability_status = 'Reserved'
    FROM Seats S
    INNER JOIN inserted I ON S.seat_id = I.seat_id;

    -- Automatically create a PNR record for the reservation
	INSERT INTO PNR (pnr_id, reservation_id, record_Locator, booking_date, booking_status)
    SELECT
        -- Generate a new PNR ID 
        ABS(CHECKSUM(NEWID())) % 1000000 + 1,  -- Randomized PNR ID between 1 and 1,000,000
        I.reservation_id,
        LEFT(CONVERT(VARCHAR(36), NEWID()), 10), -- Random 10-character record locator
        GETDATE(),
        'Pending'
    FROM inserted I;
END;

-- Executes after a payment is inserted
CREATE TRIGGER trg_AfterPaymentInsert
ON Payments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Only process rows where payment status is 'Paid'
    IF EXISTS (SELECT 1 FROM inserted WHERE payment_status = 'Paid')
    BEGIN
        --  Update PNR status to 'Confirmed'
        UPDATE P
        SET booking_status = 'Confirmed'
        FROM PNR P
        INNER JOIN inserted I ON P.pnr_id = I.pnr_id
        WHERE I.payment_status = 'Paid';

        -- Update Reservation status to 'Confirmed'
        UPDATE R
        SET reservation_status = 'Confirmed'
        FROM Reservations R
        INNER JOIN PNR P ON R.reservation_id = P.reservation_id
        INNER JOIN inserted I ON P.pnr_id = I.pnr_id
        WHERE I.payment_status = 'Paid';

        -- Update Seat availability to 'Booked'
        UPDATE S
        SET availability_status = 'Booked'
        FROM Seats S
        INNER JOIN Reservations R ON S.seat_id = R.seat_id
        INNER JOIN PNR P ON R.reservation_id = P.reservation_id
        INNER JOIN inserted I ON P.pnr_id = I.pnr_id
        WHERE I.payment_status = 'Paid';
    END
END;

-- Ticket trigger
-- 6. Create Trigger on Ticket Table to Seat’s Availability Status Automatically 
CREATE TRIGGER trg_UpdateTicketIssuanceAndSeatsStatus 
ON Tickets
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update ticket issuance status
    UPDATE TI
    SET ticket_issuance_status = 'Issued'
    FROM Ticket_Issuance TI
    INNER JOIN inserted I ON TI.ticket_issuance_id = I.ticket_issuance_id;

    -- Update seat availability status via joined path
    UPDATE S
    SET availability_status = 'Issued'
    FROM Seats S
    INNER JOIN Reservations R ON S.seat_id = R.seat_id
    INNER JOIN PNR P ON R.reservation_id = P.reservation_id
	INNER JOIN Payments Py ON P.pnr_id = Py.pnr_id
    INNER JOIN Ticket_Issuance TI ON Py.payment_id = TI.payment_id
    INNER JOIN inserted I ON TI.ticket_issuance_id = I.ticket_issuance_id
	WHERE seat_assignment IS NOT NULL;
END;

-- Seats trigger
CREATE TRIGGER trg_SetPreferredSeatFee
ON Seats
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Update seat_fee to 30 where preferred_seat = 1
    UPDATE S
    SET seat_fee = 30
    FROM Seats S
    INNER JOIN inserted I ON S.seat_id = I.seat_id
    WHERE I.preferred_seat = 1 AND I.seat_assignment IS NOT NULL ;
END;
