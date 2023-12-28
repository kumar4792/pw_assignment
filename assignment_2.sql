-- Question 1: 
-- Retrieve the total number of rentals made in the Sakila database. 
-- Hint: Use the COUNT() function. 
use mavenmovies
select * from rental
select customer_id , count(rental_id) as rental_count from rental group by customer_id

-- Question 2: 
-- Find the average rental duration (in days) of movies rented from the Sakila database.
-- Hint: Utilize the AVG() function.
 
select round(avg(datediff(return_date,rental_date))) as rental_days from rental

-- Question 3: 
-- Display the first name and last name of customers in uppercase. 
-- Hint: Use the UPPER () function. 

select upper(concat(first_name," ",last_name)) from customer

-- Question 4: 
-- Extract the month from the rental date and display it alongside the rental ID. 
-- Hint: Employ the MONTH() function. 

select rental_id,month(rental_date) as month from rental

-- Question 5 : 
-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals). 
-- Hint: Use COUNT () in con j unction w ith GROUP BY

select customer_id, count(rental_id) as rental_count from rental group by customer_id


-- Display the title of the movie , customer ' s first name , and last name who rented it. 
-- Hint: Use J OIN bet w een the film , inventory , rental , and customer tables. 

SELECT 
    title, CONCAT(first_name, ' ', last_name) AS C_name
FROM
    film
        INNER JOIN
    inventory ON film.film_id = inventory.film_id
        INNER JOIN
    rental ON inventory.inventory_id = rental.inventory_id
        INNER JOIN
        
       
    customer ON rental.customer_id = customer.customer_id
    
 -- Question 8: 
-- Retrieve the names of all actors who have appeared in the film "Gone Trouble." 
-- Hint: Use JOIN between the film actor, film, and actor tables

SELECT 
    first_name
FROM
    actor
        INNER JOIN
    film_actor ON actor.actor_id = film_actor.actor_id
        INNER JOIN
    film ON film_actor.film_id = film.film_id
WHERE
    title LIKE 'gone trouble'
    
    
    -- Question 1: 
-- Determine the total number of rentals for each category of movies. 
-- Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.


SELECT 
    c.category_id,c.name,COUNT(rental_id) as film_count
FROM
    rental r
        INNER JOIN
    inventory i  ON r.inventory_id = i.inventory_id
        INNER JOIN
    film_category fc ON i.film_id = fc.film_id
    inner join category c on fc.category_id = c.category_id group by c.category_id  
    
    
  -- Question 2: 
-- Find the average rental rate of movies in each language. 
-- Hint: JOIN film and language tables, then use AVG () and GROUP BY
    
SELECT 
    name, AVG(rental_rate)
FROM
    language
        LEFT JOIN
    film ON language.language_id = film.language_id
GROUP BY language.name


-- Question 3: 
-- Retrieve the customer names along with the total amount they've spent on rentals. 
-- Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY. 

SELECT 
    CONCAT(first_name, ' ', Last_name),
    payment.rental_id,
    SUM(amount)
FROM
    customer
        INNER JOIN
    rental ON customer.customer_id = rental.customer_id
        INNER JOIN
    payment ON payment.rental_id = rental.rental_id
GROUP BY payment.rental_id

-- Question 4: 
-- List the titles of movies rented by each customer in a particular city (e.g., 'London'). 
-- Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY. 

SELECT 
    title, first_name, city
FROM
    film
        INNER JOIN
    inventory ON inventory.film_id = film.film_id
        INNER JOIN
    rental ON rental.inventory_id = inventory.inventory_id
        INNER JOIN
    customer ON customer.customer_id = rental.customer_id
        INNER JOIN
    address ON address.address_id = customer.address_id
        INNER JOIN
    city ON address.city_id = city.city_id
WHERE
    city LIKE '%London'
    
    
  -- Question 5 : 
-- Display the top 5 rented movies along with the number of times they've been rented. 
-- Hint: JOIN film, inventory, and rental tables, then use cOUNT() and GROUP BY, and limit the results


SELECT 
    title, COUNT(rental_id) AS rental_count
FROM
    film
        INNER JOIN
    inventory ON inventory.film_id = film.film_id
        INNER JOIN
    rental ON rental.inventory_id = inventory.inventory_id
GROUP BY inventory.film_id order by rental_count desc limit  5


----
-- Question 6 : 
-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2 ). 
-- Hint: Use JOINS with rental, inventory, and customer tables and consider C OUNT() and GROUP BY.

SELECT 
    c.customer_id, c.first_name, c.last_name
FROM
    customer c
        INNER JOIN
    rental r ON c.customer_id = r.customer_id
        INNER JOIN
    inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN
    store s ON i.store_id = s.store_id
WHERE
    s.store_id IN (1 , 2)
GROUP BY c.customer_id , c.first_name , c.last_name
HAVING COUNT(DISTINCT s.store_id) = 2