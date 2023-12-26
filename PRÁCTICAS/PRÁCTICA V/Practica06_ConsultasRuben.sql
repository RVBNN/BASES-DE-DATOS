# 10.
select f.title, count(actor_id) from film as f
join film_actor as fa using(film_id)
join actor as a using(actor_id)
group by 1
having count(actor_id)>10;

# 11.
select c.customer_id, c.first_name,c.last_name, cast(r.rental_date as date), p.amount from customer as c
join rental as r using(customer_id)
join payment as p using(rental_id)
# Condicion fecha:
where cast(r.rental_date as date) = (select cast(max(r.rental_date) as date) from customer as c
join rental as r using(customer_id)
join payment as p using(rental_id)
where year(r.rental_date) = 2005) and
# Condicion nombres:
c.last_name in (select distinct c.last_name from customer as c
join rental as r using(customer_id)
join payment as p using(rental_id)
where c.last_name like 'w%a' or
c.last_name like 'w%e' or
c.last_name like 'w%i' or
c.last_name like 'w%o' or
c.last_name like 'w%u') and
# Condicion precio minimo:
p.amount = (select min(amount) from customer as c
join rental as r using(customer_id)
join payment as p using(rental_id)
where amount not like 0.00)
;

