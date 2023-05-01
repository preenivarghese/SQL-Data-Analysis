--Who is senior most employee based on job title?
select * from employee order by levels desc limit 1

--Which countries have the most invoices?
select count(invoice_id) as "Invoice Count", billing_country as "Country" 
from invoice
group by 2
order by 1 desc

--Which are top 3 values for total invoices?
select total as "Total Invoices" from invoice order by total desc limit 3

--Which city has the best customers? We would like to throw a organize a promotional music festival in the city that made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
select billing_city as "City", sum(total) as "Invoice Total"
from invoice
group by 1
order by 2 desc limit 1

--Who is the best customer? The customer who has spent the most money will be declared as the best customer.
--Write a query to find out the customer who has spent the most money.
select invoice.customer_id as "Customer ID", customer.first_name as "First Name", customer.last_name as "Last Name",
sum(invoice.total) as "Total Money Spent"
from customer inner join invoice
on customer.customer_id = invoice.customer_id
group by 1,2,3
order by 4 desc
limit 1

--Write a query to return the email, first name, last name and Genre of all Rock Music listners. Return your list ordered alphabetically by email starting with A.
select distinct customer.first_name as "First Name", customer.last_name as "Last Name",
customer.email as "Email"
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
where genre.name like '%Rock%'
order by email 

--Let’s invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name, and total track count of the top 10 rock bands.
select artist.name as "Artist Name", count(track.track_id) as "Number of Tracks" from artist 
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name like '%Rock%'
group by 1
order by 2 desc
limit 10

--Return all the track names that have song length greater than average song length. Return the name and song length for each track. Order by song length with the longest song length displayed first.
select name as "Song Name", milliseconds as "Song Length" from track
where milliseconds > (select avg(milliseconds) from track)
order by 2 desc

--Find how much amount is spent by each customer on artists. Write a query to return customer name, artist name and total spent.
select * from customer
select * from invoice
select * from invoice_line		
select * from track
select * from album
select * from artist

with best_selling_artist as (select artist.artist_id as artist_id, artist.name as artist_name,
			 sum(invoice_line.unit_price*invoice_line.quantity) as total_spent from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join invoice_line on track.track_id = invoice_line.track_id
group by 1,2
order by 3 desc)
select distinct customer.first_name as "First Name",customer.last_name as "Last Name",
best_selling_artist.artist_name as "Artist Name",
sum(invoice_line.unit_price*invoice_line.quantity) as "Total Spent" from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id
join best_selling_artist on album.artist_id = best_selling_artist.artist_id
group by 1,2,3 
order by 1,4 desc

--We want to find out the most popular music genre for each country. We determine the most popular genre by counting the number of purchases ie highest number of purchases for that genre. Write a query that returns each country along with top genre.
select * from genre
select * from track
select * from invoice_line
select * from invoice

with popular_genre as (select genre.name as genre_name, invoice.billing_country as country,
count(invoice_line.quantity) as purchases,
row_number() over(partition by invoice.billing_country order by count(invoice_line.quantity) desc) as rownum
from genre
join track on genre.genre_id = track.genre_id
join invoice_line on track.track_id = invoice_line.track_id
join invoice on invoice_line.invoice_id = invoice.invoice_id
group by 1,2
order by 2,3 desc)
select popular_genre.country as "Country", popular_genre.genre_name as "Genre", popular_genre.purchases as "Purchases"
from popular_genre
where rownum = 1

--Write a query that determines the customer that has spent the most on each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount is shared, provide all customers who spent this amount. 
select * from invoice
select * from customer

with popular_customer as (select customer.first_name,customer.last_name, invoice.billing_country as country,
sum(invoice.total) as total_spent,
row_number() over(partition by invoice.billing_country order by sum(invoice.total) desc) as rownum
from customer
join invoice on customer.customer_id = invoice.customer_id
group by 1,2,3
order by 3,4 desc)
select popular_customer.country as "Country", popular_customer.first_name as "First Name", popular_customer.last_name as "Last Name",
popular_customer.total_spent as "Total Spent"
from popular_customer
where rownum = 1








