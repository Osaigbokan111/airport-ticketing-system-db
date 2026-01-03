-- Security, Access and permissions setup

-- 1. SCHEMA SETUP
CREATE SCHEMA TicketingStaff1;

-- 2. ROLE DEFINITIONS
CREATE ROLE Staff;
CREATE ROLE Supervisor;

-- 3. CREATE SECURE VIEWS (limit table access through views)
CREATE VIEW dbo.vw_Reservations1 AS
SELECT * FROM Reservations;

CREATE VIEW dbo.vw_Passengers1 AS
SELECT * FROM Passengers;

-- Move views to TicketingStaff schema
ALTER SCHEMA TicketingStaff1 TRANSFER vw_Reservations1;
ALTER SCHEMA TicketingStaff1 TRANSFER vw_Passengers1;

-- 4. REVOKE BROAD PERMISSIONS FROM PUBLIC
REVOKE SELECT, INSERT, UPDATE, DELETE ON Reservations FROM PUBLIC;
REVOKE SELECT ON Passengers FROM PUBLIC;
REVOKE SELECT, INSERT, UPDATE ON Employees FROM PUBLIC;

-- 5. PERMISSIONS TO ROLES
-- Supervisor gets extended access
GRANT SELECT, INSERT, UPDATE ON Employees TO Supervisor;
GRANT EXECUTE ON sp_GetFlightRevenueReport TO Supervisor;

-- Staff gets limited access via schema-level view permissions
GRANT SELECT, INSERT, UPDATE ON SCHEMA::TicketingStaff1 TO Staff;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::TicketingStaff1 TO Supervisor;

-- 6. LOGIN & USER CREATION
CREATE LOGIN maxw WITH PASSWORD = 'password459';
CREATE LOGIN johnd WITH PASSWORD = 'password123';
CREATE LOGIN petera WITH PASSWORD = 'password456';
CREATE LOGIN johnson1 WITH PASSWORD = 'password789';
CREATE LOGIN janes WITH PASSWORD = 'password456';
CREATE LOGIN Zeb5 WITH PASSWORD = '110303pet';

CREATE USER olive FOR LOGIN maxw;
CREATE USER johndoe FOR LOGIN johnd;
CREATE USER peterarms FOR LOGIN petera;
CREATE USER johnson123 FOR LOGIN johnson1;
CREATE USER janesmith FOR LOGIN janes;
CREATE USER Zeb55501 FOR LOGIN Zeb5;

-- 7. ASSIGN ROLES
EXEC sp_addrolemember 'Staff', 'olive';
EXEC sp_addrolemember 'Staff', 'johndoe';
EXEC sp_addrolemember 'Staff', 'peterarms';
EXEC sp_addrolemember 'Staff', 'johnson123';
EXEC sp_addrolemember 'Staff', 'Zeb55501';
EXEC sp_addrolemember 'Supervisor', 'janesmith';


-- store procedure to authenticate employee login
CREATE PROCEDURE sp_EmployeeLogin2
    @username VARCHAR(50),
    @password VARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @employee_id INT;
    DECLARE @role VARCHAR(50);
    DECLARE @full_name VARCHAR(100);

    -- Authenticate employee
    SELECT 
        @employee_id = employee_id,
        @role = role,
        @full_name = first_name + ' ' + last_name
    FROM Employees
    WHERE username = @username AND password = @password;

    -- Successful login
    IF @employee_id IS NOT NULL
    BEGIN
        PRINT 'Login successful. Welcome: ' + @full_name;
        PRINT 'Role: ' + @role;

        IF @role = 'Supervisor'
            PRINT 'Access granted to all modules.';
        ELSE IF @role = 'Staff'
            PRINT 'Access granted to reservation and passenger modules.';
    END
    ELSE
    BEGIN
        -- Log failed attempt for supervisor
        DECLARE @failed_emp_id INT;

        SELECT @failed_emp_id = employee_id 
        FROM Employees 
        WHERE username = @username;

        IF @failed_emp_id IS NOT NULL
        BEGIN
            INSERT INTO PermissionRequests (employee_id, module_requested, status)
            VALUES (@failed_emp_id, 'Login Attempt', 'Pending');

            PRINT 'Access denied. Supervisor intervention required.';
        END
        ELSE
        BEGIN
            PRINT 'Invalid user. No such username found.';
        END
    END
END;


-- Testing schema set up and employee authentication
GRANT EXECUTE ON sp_EmployeeLogin2 TO Staff;
GRANT EXECUTE ON sp_EmployeeLogin2 TO Supervisor;

DECLARE @hashedPassword VARCHAR(256);

SET @hashedPassword = CONVERT(VARCHAR(256), HASHBYTES('SHA2_256', 'password459'), 2);

EXEC sp_EmployeeLogin2 @username = 'olive', @password = @hashedPassword;

-- Impersonate and test access to view
EXECUTE AS USER = 'olive';
SELECT * FROM TicketingStaff1.vw_Reservations1;
REVERT;
 
 SELECT * FROM PermissionRequests
