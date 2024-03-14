#Creating a Customer Summary Report
#In this exercise, you will create a customer summary report that summarizes key information 
#about customers in the Sakila database, including their rental history and payment details. 
#The report will be generated using a combination of views, CTEs, and temporary tables.
#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

SELECT * FROM sakila.customer;
SELECT * FROM sakila.rental;
select * from sakila.payment;

create view v_rental_info_per_cust as
select c.customer_id, c.first_name, c.last_name, c.email, COUNT(r.customer_id) as rental_count
from sakila.customer c
join sakila.rental r on c.customer_id = r.customer_id
group by c.customer_id;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
#The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
#calculate the total amount paid by each customer.

create temporary table total_paid_per_cust as
select v.*, sum(p.amount) as total_spent
from v_rental_info_per_cust v
join payment p on p.customer_id = v.customer_id
group by v.customer_id;

select * from total_paid_per_cust;
 

#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: 
#customer name, email, rental_count, total_paid and average_payment_per_rental, 
#this last column is a derived column from total_paid and rental_count.

with rental_info_total_paid_per_cust as (
    select v.*, t.total_spent
    from sakila.v_rental_info_per_cust v
    join total_paid_per_cust t on v.customer_id = t.customer_id
)
select *,
       total_spent / rental_count as avg_payment_per_rental
from rental_info_total_paid_per_cust;
 


    
