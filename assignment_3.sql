-- 1.**Join Practice:**
-- Write a query to display the customer's first name, last name, email, and city they live in.

SELECT 
    CONCAT(first_name, ' ', last_name), email, city
FROM
    customer
        INNER JOIN
    address ON customer.address_id = address.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
    	
    
-- 2. **Subquery Practice (Single Row):**
-- Retrieve the film title, description, and release year for the film 
-- that has the longest duration.(length)

select title,description,release_year,length from film where length > (select max(length) from film)

select title,description,release_year from film where length > (select Avg(length) from film)



-- 3. **Join Practice (Multiple Joins):**
-- List the customer name, rental date, and film title for each rental made. 
-- Include customers who have never
-- rented a film.

SELECT 
    CONCAT(first_name, ' ', last_name), rental_date, title
FROM
    customer
		Inner JOIN
    rental ON customer.customer_id = rental.customer_id
        INNER JOIN
    inventory ON inventory.inventory_id = rental.inventory_id
        INNER JOIN
    film ON film.film_id = inventory.film_id 
    
    
    -- 4. **Subquery Practice (Multiple Rows):**
-- Find the number of actors for each film.
--  Display the film title and the number of actors for each film.

SELECT 
    title, COUNT(actor_id) AS actor_count
FROM
    film
        INNER JOIN
    film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id



-- 5. **Join Practice (Using Aliases):**
-- Display the first name, last name, and email of customers along with the rental date, film title, and rental 
-- return date.
SELECT 
    CONCAT(first_name, ' ', last_name) AS name,
    email,
    rental_date,
    title,
    return_date
FROM
    customer c
        INNER JOIN
    rental r ON r.customer_id = c.customer_id
        INNER JOIN
    inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN
    film f ON i.film_id = f.film_id
    
    
-- 6. **Subquery Practice (Conditional):**
-- Retrieve the film titles that are rented by customers whose email domain ends with '.org'.
-- Note Email .net not avalible in data set so changed to .org

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            inventory
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    rental
                WHERE
                    customer_id IN (SELECT 
                            customer_id
                        FROM
                            customer
                        WHERE
                            email LIKE '%.org')))
                            
                            
 - 7. **Join Practice (Aggregation):**
-- Show the total number of rentals made by each customer, along with their first and last names.

SELECT 
    CONCAT(first_name, ' ', last_name),
    COUNT(rental_id) AS rental_count
FROM
    customer
        INNER JOIN
    rental ON customer.customer_id = rental.customer_id
GROUP BY rental.customer_id



 -- 9. **Join Practice (Self Join):**
-- Display the customer first name, last name, and email along with the names 
-- of other customers living in the same city.


SELECT 
    CONCAT(c.first_name, c.last_name) AS name,
    c.email,
    a.city_id
FROM
    customer c,
    address a
WHERE
    c.address_id = a.address_id
ORDER BY a.city_id




-- 11. **Subquery Practice (Nested Subquery):**
-- Retrieve the film titles along with their descriptions and lengths that have a rental rate 
-- greater than the  average rental rate of films released in the same year.

SELECT 
    title, description, length
FROM
    film
WHERE
    rental_rate > (SELECT 
            AVG(rental_rate)
        FROM
            film
        WHERE
            release_year = film.release_year)
            
-- 12. **Subquery Practice (IN Operator):**
-- List the first name, last name, and email of customers who have rented at least one film in the 'Documentary' category.

SELECT 
    first_name, last_name,email
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            rental
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    inventory
                WHERE
                    (SELECT 
                            COUNT(film_id)
                        FROM
                            film_category
                        WHERE
                            (SELECT 
                                    category_id
                                FROM
                                    category
                                WHERE
                                    film_category.category_id = category.category_id
                                        AND name LIKE 'Documentary'))))
                                        
 -- 13. **Subquery Practice (Scalar Subquery):**
-- Show the title, rental rate, and difference from the average rental rate for each film.

SELECT 
    title, rental_rate
FROM
    film
WHERE
    rental_rate - (SELECT 
            AVG(rental_rate)
        FROM
            film)
            
            
 -- 14. **Subquery Practice (Existence Check):**
-- Retrieve the titles of films that have never been rented.


SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            film_id
        FROM
            inventory
        WHERE
            inventory_id NOT IN (SELECT 
                    inventory_id
                FROM
                    rental))
                    

 -- 15. **Subquery Practice (Correlated Subquery - Multiple Conditions):**
-- List the titles of films whose rental rate is higher than the average rental rate 
-- of films released in the same 
-- year and belong to the 'Sci-Fi' category.

SELECT 
    title, rental_rate
FROM
    film
WHERE
    rental_rate > (SELECT 
            AVG(rental_rate)
        FROM
            film
        WHERE
            release_year = film.release_year
                AND film_id IN (SELECT 
                    film_id
                FROM
                    category
                WHERE
                    category_id IN (SELECT 
                            category_id
                        FROM
                            category
                        WHERE
                            name = 'Sci-Fi')))  
                            
 -- 16. **Subquery Practice (Conditional Aggregation):**
-- Find the number of films rented by each customer, excluding customers
-- who have rented fewer than TEN
-- films.

SELECT 
    CONCAT(first_name, ' ', last_name)
FROM
    customer
WHERE
    (SELECT 
            COUNT(*)
        FROM
            rental
        WHERE
            rental.customer_id = customer.customer_id) > 10
-- using Join

SELECT 
    CONCAT(first_name, ' ', last_name), COUNT(rental_id)
FROM
    customer
        INNER JOIN
    rental ON rental.customer_id = customer.customer_id
GROUP BY rental.customer_id
HAVING COUNT(rental_id) > 10  
