-- Emerson Maggiolo

USE Sakila;

-- Lab Step 1: Create a view to add and determine a payment total for each customer
-- I ran the customer list views and it produced vera mccoy and relvent information
CREATE VIEW customer_totals as
select customer_id, SUM(amount) AS Total 
FROM payment
GROUP BY Customer_id
ORDER BY total;

SELECT * FROM customer_totals;

-- Lab Step 2: View and Create a stored procedure
-- Pick a stored procedure. Run it and enter data for the parameters.
-- List the stored procedure names here and the output.
-- I viewed the film_in_stock stored procedure in the Sakila schema.
-- Run it and enter 1 for the first two parameters and Output was 4.
 

-- create and run the following code to store to create a stored procedure. Refresh your screen 
-- The answer to this stored procedure is PG 194
delimiter //
create procedure sp_GetMovieCounts()
Begin
	select rating, count(film_ID)
    from film
    group by rating;
END //
Delimiter ;

-- Lab Step 3: Analyze the code and run the get_customer_balance function
-- with the following parameters: 195, 20050902
-- They owe $0



-- Lab Step 4: Create a trigger 
-- Create a trigger that fires when anyone inserts a new row into the film table
create trigger tr_ins_film
before insert on sakila.film
for each row
set new.title = upper(new.title);

select * from film;

-- Test the trigger 
insert into film (film_id, title, language_id)
values (9999, 'Maverick', 1);

select film_id, title
from film
where film_id = 9999;

-- Lab Step 5: Create and run a stored procedure to generate an email list using a cursor
DELIMITER $$
CREATE PROCEDURE createNewslettermaillist(INOUT emails VARCHAR(4000))
BEGIN
	-- Declare some variables
    DECLARE terminate INT DEFAULT FALSE; 
    DECLARE emailAddr VARCHAR (255) DEFAULT"";
    -- Declare and name the cursor for the SQL to select all emails from address_id 101-104
    DECLARE collect_email CURSOR FOR 
SELECT email FROM sakila.customer WHERE (address_id > 100 AND address_id < 105); 
	-- Declare and name the handler with the variabletterminate set for the end of the loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminate = TRUE;
    -- Open the cursor 
    OPEN collect_email;
    -- Start the loop with the label name, getEmails
    getEmails : LOOP
    -- The firsy task is to fetch the cursor.
    FETCH collect_email INTO emailAddr;
    IF terminate =TRUE THEN
		LEAVE getEmails;
	END IF;
    SET emails = CONCAT(emailAddr, "|", emails);
    -- SET just stores a value for a variable. CONCAT will take the first string (emailAddr), add to it the pipe (|),
    -- Then add to that the second string. Thus, the current line's email address will always appear "before" the prior ones (emails).
    END LOOP getEmails;
    
    -- Close the Cursor
    CLOSE collect_email;
END$$

-- reset the delimiter back to normal symbol

DELIMITER ;

-- Run the stored procedure 
SET @emails = "";
CALL createNewsLetterEmailList(@emails);
SELECT @emails;


    
    
    
    









