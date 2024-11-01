USE mavenmovies;

/* We need to understand the special features in our films. Could you pull a list of films which include a Behind the scenes
special feature*/

SELECT title,special_features FROM film 
WHERE special_features LIKE "%Behind the Scenes%";

SELECT rating,COUNT(film_id) AS Film_count FROM film
GROUP BY rating;

SELECT rating,COUNT(film_id),COUNT(film_id) AS count_film FROM film
GROUP BY rating;

/* Could you please pull a count of titles sliced by rental duration*/

SELECT rental_duration,COUNT(title) AS films_with_this_rental_duration FROM film
GROUP BY rental_duration;


/* Can you help me pull a Count of films, along with the average,min and max rental rate,grouped by replacement cost*/

SELECT replacement_cost,COUNT(film_id) AS number_of_films,AVG(rental_rate) AS Avg, MIN(rental_rate) AS cheap_rental,
MAX(rental_rate) AS most_expensive_rental FROM film
GROUP BY replacement_cost ORDER BY replacement_cost DESC;




/* Could you pull a list of customer_ids with less than 15 rentals all-time*/
 
SELECT customer_id,COUNT(*) AS Total_rentals FROM rental
GROUP BY customer_id HAVING COUNT(*)<15;

/* Could you pull me a list of all fim title along with their lengths and rental rates, and sort
them from longest to shortest*/

SELECT title,length,rental_rate FROM film
ORDER BY length DESC;



/* Could you pull a list of first and last name of all customers, and label them either `store 1 active`,`store 1 Inactive",
`Store 2 active", `Store 2 Inactive"?*/

SELECT first_name,Last_name,CASE WHEN store_id=1 AND active=1 THEN "Store 1 Active"
                            WHEN store_id=1 AND active=0 THEN "Store 1 In-Active"
                            WHEN store_id=2 AND active=1 THEN "Store 2 Active"
                            WHEN store_id=2 AND active=0 THEN "Store 2 In-Active" 
                            ELSE "Opening"
                            END AS ACtive_Status FROM customer JOIN store USING(store_id);
                            
 
 /* Could you please create a table to count the number of customers broken down by store_id(in rows), and
 active_status(in columns)*/
 
 SELECT store_id,COUNT(CASE WHEN active=1 THEN customer_id ELSE NULL END) AS active,
                 COUNT(CASE WHEN active=0 THEN customer_id ELSE NULL END) AS in_active FROM customer
                 GROUP BY store_id
                 ORDER BY store_id;
                 
/*We will need a list of all staff members, including their first and last names,email address, and the store
identification number where they work*/

SELECT first_name,last_name,email,ST.store_id 
FROM staff ST JOIN store SR 
ON ST.store_id=SR.store_id;

/* We will need seperate counts of inventory items held at each of your two stores*/

SELECT store_id,COUNT(inventory_id) AS inventory_item_count FROM inventory
GROUP BY store_id;

/*We will need a count of active customers for each of your stores. Seperately,Please*/

SELECT store_id,COUNT(CASE WHEN active=1 THEN customer_id ELSE NULL END) AS active_status FROM customer
GROUP BY store_id;

/* In order to access the liability of a data breach, we will need you to provide a count of all customer email address stored in the
database*/

SELECT COUNT(email) AS email_count FROM customer;

/* we are interested in how diverse your film offering is as a means of understanding how likely you are to
keep customers engaged in the future. Please provide a count of unique film titles you have in inventory at
each store and then provide a count of the unique categories of films you provide*/

SELECT store_id,COUNT(DISTINCT film_id) AS film_count FROM inventory
GROUP BY store_id;

SELECT COUNT(DISTINCT name) AS movie_names FROM category;

/* We would like to understand the replacement cost of your films, Please provide the replacement cost for the
film that is least expensive to replace, the most expensive to replace, and the average of all films you carry*/

SELECT MIN(replacement_cost) AS min_rp,
	   MAX(replacement_cost) AS max_rp,
       AVG(replacement_cost) AS Avg_rp FROM film;
       
/* We are interested in having you put payment monitoring systems and maximum payment processing restrictions in place in order
to minimize the future risk of fraud by your staff. Please provide the average payment you process, as well as the maximum payment
you have processed*/

SELECT AVG(amount) AS avg_payment,
       MAX(amount) AS max_payment FROM payment;


/* We would like to better understand what your customer base looks like. Please provide a list of all customer
identification values, with a count of rentals they have made all-time, with your highest volume customers at the top
of the list*/

SELECT customer_id,COUNT(rental_id) AS rental_count FROM rental
GROUP BY customer_id ORDER BY rental_count DESC;
                 
                 
/* I would like to see the film`s title,description and the store_id value
associated with each item and its inventory_id. Thanks!"*/

SELECT 
inventory_id,store_id,title,description 
FROM film JOIN inventory USING(film_id);


/* Can you pull a list of titles, and figure out how many actors are associated with each title?*/

SELECT DISTINCT title,COUNT(actor_id) AS actors_acted 
FROM film F LEFT JOIN film_actor FA ON F.film_id=FA.film_id
GROUP BY title;


/* It would be great to have a list of all actors, with each title that they appear in. Could you please pull that for me?"*/

SELECT first_name,last_name,title 
FROM actor A 
JOIN film_actor FA ON FA.actor_id=A.actor_id JOIN film F ON F.film_id=FA.film_id;

/* Could you pull a list of distinct titles and their descriptions, currently available in
inventory at store 2*/

SELECT DISTINCT F.title,description FROM film F JOIN inventory I 
ON F.film_id=I.film_id 
JOIN store S ON I.store_id=S.store_id
WHERE S.store_id=2;

/* Could you pull a list of all staff and advisor names, and including a column nothing wheather they
are a saff member or advisor? Thanks! */

SELECT "staff" AS Type,first_name,last_name FROM staff
UNION
SELECT "advisor" AS Type,first_name,last_name FROM advisor;

/* My partner and I want to come by each of the stores in person and meet the managers. Please send over the manger`s names
at each store, with the full address of each property (Street address, district, city and country please)*/

SELECT first_name,last_name,address,district,city,country FROM staff ST LEFT JOIN store S ON ST.store_id=S.store_id LEFT JOIN
address A ON A.address_id=ST.address_id
LEFT JOIN city C ON C.city_id=A.city_id
LEFT JOIN country CT ON CT.country_id=C.country_id;

/* I would like to get a better understanding of all the inventory that would come along with the business.
Please pull together a list of each inventory item you have stocked, including the store_id number, the inventory_id,
the name of the film, the film rating,its rental rate and replacement cost*/

SELECT I.inventory_id,S.store_id,rating,rental_rate,replacement_cost FROM film F LEFT JOIN inventory I ON F.film_id=I.inventory_id
LEFT JOIN store S ON I.store_id=S.store_id;


/* From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory.
We would like to know how many inventory items you have with each rating at each store*/

SELECT I.store_id,rating,COUNT(inventory_id) AS Total_inventory FROM Inventory I LEFT JOIN Film F ON F.film_id=I.film_id
LEFT JOIN store S ON I.store_id=S.store_id
GROUP BY I.store_id,rating;
