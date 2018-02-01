use sakila;

# check for collation if not you have to use convert the column name to LOWER()
#look a the description column to see if the DB is collated 

# 1.a 
select first_name, last_name from actor;

#1.b 

alter table actor 
add Actor_Name varchar(50);

 update actor set Actor_Name= CONCAT(first_name, '  ' , last_name);

select * from actor;

#2.a

select actor_id, first_name, last_name from actor where first_name="Joe"; 

#2.b 

select last_name from actor where last_name like '%GEN%';

#2.c 

select first_name , last_name  from actor where last_name like '%LI%' 
order by first_name, last_name;

#2.d 

select country_id , country from country where country IN ('Afghanistan','Bangladesh','China');

#3.a

alter table actor 
add middle_name varchar(50)
after first_name;

#3.b 

alter table actor 
modify column  middle_name blob;

#3.c
ALTER TABLE actor
DROP COLUMN middle_name;

#4.a 

select last_name , count(last_name) as Count  from actor
group by last_name;

#4.b 
 select last_name , count(last_name) as Count  from actor
group by last_name
having Count > 1;


#4.c

select actor_id , first_name , last_name from actor
where first_name ='groucho' and last_name ='williams';

UPDATE   actor
SET first_name='HARPO'
where first_name ='GROUCHO' AND LAST_NAME ='WILLIAMS';

#4.d
-- skipping based on Dylan's instructions 

#5. a 

-- shows the syntax of create table, i am not sure if this is needed or the request was to create a table ?

show create table address; 

#'address', 'CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'

-- syntax to create a table 

select * from address;

create table address1( address_id int auto_increment NOT NULL , address varchar(100), address2 varchar(100), district varchar(100),
city_id int(20), postal_code varchar(50), phone varchar(50), location blob, last_update timestamp not null default current_timestamp, 
primary key(address_id));



#6.a 

select S.first_name, S.last_name , A.address 
from staff S left join   address  A 
on S.address_id = A.address_id; 

#6.b 

select S.staff_id, S.first_name, S.last_name , sum(P.amount) as Total_Amount
from staff S left join payment P
on S.staff_id=P.staff_id
where P.payment_date like '%-08%'
group by staff_id;

#6.c 

select F.title, count(FA.actor_id) as Number_Actors
from film F inner join  film_actor FA
on F.film_id = FA.film_id
group by F.title ;

#6.d 

select count(inventory_id) as Number_of_Copies from inventory 
where film_id in (select film_id from film where title = 'Hunchback Impossible');

#6.e 

select C.customer_id, C.first_name ,C.last_name,   sum(P.amount) as Total_Paid
from customer C left join payment P 
on C.customer_id= P.customer_id
group by C.customer_id
order by C.last_name;

# 7.a 

select title from film where
title like 'K%' or title like 'Q%' and 
language_id in (select language_id from language where name ='English') ;

#7.b 
select first_name , last_name from  actor where actor_id in 
(select actor_id from film_actor where film_id in 
(select film_id from film where title= 'Alone Trip'));

# 7.c 


select C.email, A.address_id , CI.city_id, CC.country_id from customer C left outer  join address A 
on C.customer_id = A.address_id
left outer join city CI 
on A.city_id= CI.city_id
left outer join country CC
on CI.country_id = CC.country_id
where CC.country='Canada';

#7.d 

select * from category;

select title from film where film_id in 
(select film_id from film_category where category_id in
(select category_id from category where name ='Family'));

#7.e -- most rented in the decreasing order 

SELECT f.film_id, f.title, COUNT(r.customer_id) AS rent_count
FROM rental r
JOIN inventory i USING (inventory_id) 
JOIN film f USING (film_id)
GROUP BY f.film_id
ORDER BY rent_count DESC;



# 7.f 


select sum(amount) from  payment where staff_id in 
(select  staff_id from staff where store_id in 
(select store_id from store))
group by staff_id; 

#7.g 


select s.store_id , c.city, cc.country
from store s join address a 
on s.address_id= a.address_id
join city c on a.city_id=c.city_id
join country cc on cc.country_id=c.country_id;

#7h 


select   c.name , sum(p.amount) as Total
from payment p left outer join rental r on  p.rental_id=r.rental_id
left outer join inventory i on i.inventory_id=r.inventory_id
left outer join film_category f on i.film_id=f.film_id
left outer join category c on f.category_id = c.category_id
group by c.name
order by Total DESC;


#8.a 
create view gross_rev_genre1 as 
select   c.name as Genre , sum(p.amount) as Total
from payment p left outer join rental r on  p.rental_id=r.rental_id
left outer join inventory i on i.inventory_id=r.inventory_id
left outer join film_category f on i.film_id=f.film_id
left outer join category c on f.category_id = c.category_id
group by c.name
order by Total DESC;

#8.b 
select * from gross_rev_genre1;

#8.c 
drop view gross_rev_genre1;
















































