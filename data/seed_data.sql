--INSERT statement
-- Insert into Countries table
INSERT INTO Countries(country_id, country_name) VALUES
(010, 'USA'),
(011, 'UK' ),
(012, 'Nigeria'),
(013, 'Egypt'),
(014, 'UAE'),
(015, 'Canada'),
(016, 'France');

-- Insert into Cities table
INSERT INTO Cities (city_id, city_name, country_id) VALUES
(020, 'Los Angeles', 010 ),
(021, 'New York', 010 ),
(022, 'London', 011 ),
(023, 'Manchester', 011 ),
(024, 'Abuja', 012 ),
(025, 'Lagos', 012 ),
(026, 'Cairo', 013 ),
(027, 'Dubai', 014 ),
(028, 'Ontario', 015 ),
(029, 'Paris', 016 );

-- Insert into Airport table
INSERT INTO Airports (airport_id, airport_code, airport_name, city_id) VALUES
(101, 'LAX', 'Los Angeles International Airport', 020),
(102, 'JFK','John F. Kennedy International Airport', 021 ),
(103, 'LHR', 'London Heathrow Airport',022 ),
(104, 'ABV', 'Nnamdi Azikwe International Airport', 024 ),
(105, 'ABS', 'Abu Simbel', 026),
(106, 'LOS', 'Murtala Muhammed International Airport', 025),
(107, 'DXB', 'Dubai International Airport', 027 );

-- Insert into Routes table
INSERT INTO Routes (route_id, origin_airport_id, destination_airport_id) VALUES
(171, 101,102),
(272, 102, 103),
(373, 102, 107),
(474, 104, 106),
(575, 105, 103),
(676, 107, 101),
(777, 106, 107);

-- Insert into Airplanes table
INSERT INTO Airplanes (airplane_id, airplane_type, capacity, manufacturer) VALUES
(910, 'Boeing 737', 300, 'Boeing' ),
(911, 'Airbus A320', 250, 'Airbus' ),
(912, 'Airbus A420', 250, 'Airbus' ),
(913, 'Airbus A521', 300, 'Airbus' ),
(914, 'Airbus A322', 300, 'Airbus' ),
(915, 'Boeing 777', 300, 'Boeing'),
(916, 'Boeing 787', 300, 'Boeing');

-- Insert into Flights table
INSERT INTO Flights(flight_id, route_id, airplane_id, flight_number, departure_time, arrival_time)VALUES
(201, 171, 910, 'AA100', '2025-07-05 14:00:00', '2025-08-05 17:00:00'),
(202, 272, 911, 'BA200',  '2025-07-01 12:00:00', '2025-07-01 16:00:00'),
(203, 373, 912, 'BA400', '2025-08-01 12:00:00', '2025-08-01 17:00:00'),
(204, 474, 913, 'BA500', '2025-09-01 12:00:00', '2025-09-01 18:00:00'),
(205, 575, 914, 'BA600', '2025-10-01 12:00:00', '2025-10-01 17:00:00' ),
(206, 272, 911, 'BA201', '2025-10-01 12:00:00', '2025-10-01 18:00:00' ),
(207, 676, 915, 'EK300', '2025-11-01 10:00:00', '2025-11-01 15:00:00');

-- Insert into Address table
INSERT INTO Address (street_address, city, region, postal_code, country) VALUES
('123 Main St', 'Los Angeles', 'California', '90001', 'USA'),
('456 Oak Rd', 'New York', 'New York', '10001', 'USA'),
('300 Muritala Muhammed Way', 'Ikeja', 'Lagos', '100101', 'Nigeria'),
('50 Alesi Street', 'Zubi', 'Abuja', '100001', 'Nigeria'),
('79 Muhammad Salman Way', 'Cartoon', 'Cairo', 'E11 S33 ', 'Egypt'),
('789 Kelvin Birch', 'Chesterfield', 'England', 'E1 6AN', 'UK'),
('17 Macy Drive', 'New York', 'New York', 'E1 6AN', 'USA'),
('10 Hawthorne Street', 'Sheffield', 'England', 'S1 6AN', 'UK'),
('789 Kelvin Birch', 'Chesterfield', 'England', 'E1 6AN', 'UK'),
('101 Pine Ln', 'Dubai', 'Dubai', 'DXB 100', 'UAE');

-- Insert into Employees table
INSERT INTO Employees (
    employee_id, first_name, middle_name, last_name,
    username, password, role, email,
    address_id
) VALUES
(1, 'John', 'Allen', 'Doe', 'johndoe',
 CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password123'), 2),
 'Staff', 'john.doe@gmail.com', 1),
(2, 'Peter', 'Smith', 'Arms', 'peterarms',
 CONVERT(VARCHAR(254), HASHBYTES('SHA2_256', 'password459'), 2),
 'Staff', 'peterarms@gmail.com', 2),
(3, 'Sly', 'Elvis', 'Johnson', 'johnson123',
 CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password455'), 2),
 'Staff', 'sly.elvis@gmail.com', 3),
(4, 'Jane', 'B', 'Smith', 'janesmith',
 CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password456'), 2),
 'Supervisor', 'jane.smith@gmail.com', 4),
(5, 'Janneth', 'Low', 'Janes', 'janes',
 CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password457'), 2),
 'Supervisor', 'janneth.janes@gmail.com', 3),
(6, 'Mark', 'Lewis', 'Smith', 'lewissmith',
 CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password458'), 2),
 'Staff', 'mark.lewis@gmail.com', 4),
(7, 'Max', 'Web', 'Olive', 'olive',
 CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password459'), 2),
 'Staff', 'max.olive@gmail.com', 4);

 -- Insert into Passengers table
INSERT INTO Passengers (passenger_id, email, dob, first_name, middle_name, last_name, passport_no, address_id) VALUES
(101, 'alice.johnson@gmail.com', '1980-04-20', 'Alice', 'Elliot', 'Johnson', 'P12345678', 5),
(102, 'bob.williams@gmail.com', '1960-07-15', 'Bob', 'Fowler', 'Williams', 'P23456789', 6),
(103, 'charlie.brown@gmail.com', '1990-12-10', 'Charlie', NULL, 'Brown', 'P34567890', 7),
(104,'david.jones@gmail.com', '1985-03-25', 'David', 'G', 'Jones', 'P45678901', 8),
(105, 'eve.harry@gmail.com', '1975-06-30', 'Eve', 'Harry', 'Taylor', 'P56789012', 9),
(106, 'frank.anderson@gmail.com', '1995-09-05', 'Frank', NULL, 'Anderson', 'P67890123', 9),
(107, 'grace.thomas@gmail.com', '1989-01-15', 'Grace', 'Iva', 'Thomas', 'P78901234', 8),
(108, 'hannah.moore@gmail.com', '1982-11-20', 'Hannah', 'James', 'Moore', 'P89012345', 7),
(109, 'irene.jackson@gmail.com', '2000-02-10', 'Irene', 'King', 'Jackson', 'P90123456', 7),
(110, 'jack.white@gmail.com', '1992-06-25', 'Jack', 'L', 'White', 'P01234567', 10),
(111, 'james.white@gmail.com', '1992-06-27', 'James', 'Luke', 'White', 'P01234567', 7),
(112, 'john.white@gmail.com', '1992-06-28', 'John', 'Loveth', 'White', 'P01234567', 10);

-- Insert into Travel_Class table
INSERT INTO Travel_Class (travel_class_id, travel_class_name, travel_class_capacity)
VALUES
(1001, 'Business', 50),
(1002, 'First Class', 20),
(1003, 'Economy', 200),
(1004, 'Super Priority', 10);

-- Insert into SeatTypes tables
INSERT INTO SeatTypes (seat_type_id, seat_type) VALUES
(301, 'Bulkhead Seat'),
(302, 'Recliner Seat'),
(303, 'Lie-Flat Seat'),
(304, 'Herringbone Seat'),
(305, 'Window Seat'),
(306, 'Aisle Seat'),
(307, 'Middle Seat');

-- Insert into Seats table
INSERT INTO Seats (seat_id, seat_type_id, seat_number, preferred_seat, availability_status, seat_assignment) VALUES
(211, 307, 'A12', 0, 'Available', 'Standard'),
(212, 302, 'B15', 1, 'Available', 'Preferred'),
(213, 306, 'C16', 0, 'Available', 'Standard'),
(214, 301, 'D17', 1, 'Available', 'Preferred'),
(215, 305, 'A22', 0, 'Available', 'Standard'),
(216, 306, 'B23', 0, 'Available','Standard'),
(217, 303, 'C24', 1, 'Available', 'Preferred'),
(218, 304,'D25', 1, 'Available', 'Preferred'),
(219, 307, 'A33', 0, 'Available', 'Standard'),
(220, 301,'B31', 1, 'Booked', NULL);

-- Insert into Meals table
INSERT INTO Meals (meal_id, upgraded_meal, meal_type) VALUES
(111,  1,  'Vegetarian'),
(211, 0, 'Non-Vegetarian'),
(311, 1, 'Non-Vegetarian'),
(411, 0,'Vegetarian'),
(511,  1, 'Vegetarian'),
(611, 0,'Non-Vegetarian'),
(711, 1, 'Non-Vegetarian'),
(811, 0,  'Vegetarian'),
(911, 1,  'Non-Vegetarian'),
(1011, 0, 'Vegetarian');

-- Insert into Baggage table
INSERT INTO Baggage (baggage_id, baggage_weight, check_in_status, is_extra_baggage) VALUES
(131, 60.00, 'Checked_in', 1),
(231,  25.00, 'Checked_in', 0),
(331,  75.00, 'Checked_in', 1),
(431, 30.00, 'Checked_in', 0),
(531, 10.00, 'Checked_in', 0),
(631,  85.00, 'Checked_in', 1),
(731, 350.00, 'Checked_in', 1),
(831,  28.00, 'Checked_in', 0),
(931, 70.00, 'Checked_in', 1),
(1031, 112.00, 'Checked_in', 1);

-- Insert into Reservations table
INSERT INTO Reservations (reservation_id, flight_id, passenger_id, travel_class_id, seat_id, meal_id, baggage_id) VALUES
(200, 202, 102,1001, 212, 111, 131 ),
(300, 203, 103, 1002, 213, 211, 231),
(400, 204, 104,1003, 214, 311, 331),
(500, 205, 105, 1004, 215, 411, 431),
(600, 206, 106,1001,  216, 511, 531),
(700, 207, 107, 1002, 217, 611, 631),
(800, 201, 108, 1003, 218, 711, 731),
(900, 202, 109, 1004, 219, 811, 831),
(1000, 203, 110, 1001, 220, 911, 931 );

INSERT INTO Reservations (reservation_id, flight_id, passenger_id, travel_class_id, seat_id, meal_id, baggage_id) VALUES
(1500, 202, 111,1001, 212, 111, 131 ),
(1600, 203, 112, 1002, 213, 211, 231);
INSERT INTO Reservations (reservation_id, flight_id, passenger_id, travel_class_id, seat_id, meal_id, baggage_id) VALUES
(1700, 202, 102,1001, 212, 111, 131 ),
(1800, 203, 104, 1002, 213, 211, 231);




SELECT * FROM PNR -- To obtain the pnr_id from PNR table

-- Insert into Payments table
INSERT INTO Payments (payment_id, PNR_ID, payment_amount, payment_method, payment_status, payment_type) VALUES
(848, 90447,  150.00, 'Credit Card', 'Paid', 'Full'),
(849, 103685,  250.00, 'Debit Card', 'Paid', 'Full'),
(843, 228507,  350.00, 'Credit Card', 'Paid', 'Full'),
(844, 584123,  150.00, 'Credit Card', 'Paid', 'Full'),
(845, 625367,  250.00, 'Debit Card', 'Paid', 'Full'),
(846, 635981,  150.00, 'Credit Card', 'Paid', 'Full'),
(847, 637816,  200.00, 'Debit Card', 'Paid', 'Full');

-- Insert into Ticket_Issuance table
INSERT INTO Ticket_Issuance (ticket_issuance_id, payment_id, employee_id) VALUES
(408, 848,  001 ),
(409, 849,  002 ),
(403, 843,  002 ),
(404, 844,  003 ),
(405, 845,  001 ),
(406, 846,  002 ),
(407, 847, 003);

--Insert into Tickets table
INSERT INTO Tickets (ticket_id, ticket_issuance_id, eboarding_number, fare) VALUES
(518, 408, 'TICKET0011',  150.00),
(519, 409, 'TICKET0022', 250.00),
(513, 403, 'TICKET003', 350.00),
(514, 404, 'TICKET004', 150.00),
(515, 405, 'TICKET005', 250.00),
(516, 406, 'TICKET006', 150.00),
(517, 407, 'TICKET007', 200.00);
