use sakila;

-- 1A
select first_name, last_name
from actor;

-- 1B
select UPPER(CONCAT(first_name, ' ', last_name)) as 'Actor Name'
from actor;

-- 2A
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2B
select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

-- 2C
select actor_id, first_name, last_name
from actor
where last_name like '%LI%'
order by last_name, first_name;

-- 2D
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3A
alter table actor 
add column description BLOB NULL;

-- 3B
alter table actor
drop column description;

-- 4A
select last_name, count(*) as 'Number of Actors'
from actor
group by last_name;

-- 4B
select last_name, count(*) as 'Number of Actors'
from actor
group by last_name
having count(*) > 1;

-- 4C
update actor
set first_name = 'HARPO'
where first_name='Groucho' and last_name='Williams';

-- 4D
update actor
set first_name = 'GROUCHO'
where first_name='Harpo' and last_name='Williams';

-- 5A
show create table address;

-- 6A
select s.first_name, s.last_name, a.address
from staff s join address a on s.address_id=a.address_id;

-- 6B
select s.first_name, s.last_name, sum(p.amount) as "Total Payments"
from staff s join payment p on s.staff_id=p.staff_id
where p.payment_date LIKE '2005-08-%'
group by s.staff_id;

-- 6C
select f.title, count(*) as "Actor Count"
from film f join film_actor fa on f.film_id=fa.film_id
group by f.film_id;

-- 6D
select f.title, count(*) as "Inventory Count"
from film f join inventory i on f.film_id=i.film_id
where f.title = 'Hunchback Impossible'; 

-- 6E
select c.first_name, c.last_name, sum(p.amount) as 'Total Payments'
from customer c join payment p on c.customer_id=p.customer_id
group by c.customer_id
order by c.last_name;

-- 7A
select title
from film
where (title like "Q%" or title like "K%")
and language_id = 
	(select language_id from language where name="English");
    
-- 7B
select first_name, last_name
from actor
where actor_id in
	(select actor_id from film_actor where film_id in
		(select film_id from film where title = 'Alone Trip')
	);
    
-- 7C
select c.first_name, c.last_name, c.email
from customer c join address a on c.address_id=a.address_id join city ci on ci.city_id=a.city_id join country co on ci.country_id=co.country_id
where co.country = "Canada";

-- 7D
select title
from film
where film_id in
	(select film_id from film_category where category_id in
		(select category_id from category where name = "Family")
	);
    
-- 7E
select f.title, count(r.rental_id) as "Rental Count"
from film f 
	join inventory i on f.film_id=i.film_id 
    join rental r on i.inventory_id=r.inventory_id
group by f.film_id
order by count(r.rental_id) DESC;

-- 7F
select s.store_id, sum(p.amount) as "Total Payments"
from staff s join payment p on s.staff_id=p.staff_id
group by s.store_id;

-- 7G
select s.store_id, ci.city, co.country
from store s 
	join address a on s.address_id=a.address_id 
	join city ci on a.city_id=ci.city_id 
	join country co on ci.country_id=co.country_id;
    
-- 7H
select c.name, sum(p.amount) as 'Total Payments'
from payment p
	join rental r on p.rental_id=r.rental_id
    join inventory i on i.inventory_id=r.inventory_id
    join film_category fc on i.film_id=fc.film_id
    join category c on fc.category_id=c.category_id
group by c.category_id
order by sum(p.amount) DESC
limit 5;

-- 8A
create view top_five_genres as
select c.name, sum(p.amount) as 'Total Payments'
from payment p
	join rental r on p.rental_id=r.rental_id
    join inventory i on i.inventory_id=r.inventory_id
    join film_category fc on i.film_id=fc.film_id
    join category c on fc.category_id=c.category_id
group by c.category_id
order by sum(p.amount) DESC
limit 5;

-- 8B
select *
from top_five_genres;

-- 8C
drop view top_five_genres;