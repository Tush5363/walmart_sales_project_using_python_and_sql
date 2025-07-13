SELECT * FROM public.walmart
select count(distinct Branch) from walmart


---Business Problems
--Q.1 Find diffrent payment method and number of transactions,number of qty sold
SELECT payment_method,count(*) as no_of_trnasactions, sum(quantity) as qty_sold from walmart
group by payment_method

--Q.2 Identtify the highest-rated category in each branch,displaying the branch ,category,avg rating
select * from (select branch,category,avg(rating)as avg_rating, 
rank() over(partition by branch order by avg(rating) desc) as rank
from walmart
group by branch,category)
where rank=1

--Q.3 Identity the busiest day fro each branch based on the number of transactions
-- select date,TO_CHAR(TO_DATE(date,'DD/MM/YY'),'Day') as Day_name
-- from walmart
select * from (SELECT branch,TO_CHAR(TO_DATE(date,'DD/MM/YY'),'Day') as Day_name,count(*) as no_transaction,
rank() over(partition by branch order by count(*) desc) as rank
from walmart
group by branch, Day_name)
where rank=1


--Q.4 Calculate the total quantity of items sold per payment method.list Payment_method and total_quantity
select payment_method,sum(quantity) from walmart group by payment_method


--Q.5 Determine the average,minimum and maximum rating of category for each city
--list the city,average_rating,min_rating and max_rating.
Select city,category ,avg(rating),max(rating),min(rating) from walmart group by city,category


--Q.6 Calculate the total profit for each category by considering total_profits as 
--(unit_price * quantity * profit_margin). list category and total_profit,orderd from highest to lowest profit.
select category,sum(unit_price * quantity * profit_margin) as total_profit from walmart group by category

--Q.7 Determine the most common payment method for each Branch,Display branch and preferred_payment_method.
select * from(Select branch,payment_method ,count(*)as total_transactions,
rank() over(partition by branch order by count(*) desc)
from walmart group by branch,payment_method) as rank
where rank=1

--Q.8 Categorize sales into 3 groups Morning,afternoon,evening
--find out which of the shift has more no. of transactions
SELECT branch,
CASE
WHEN extract(hour from (time::time)) < 12 then'Morning'
WHEN extract(hour from (time::time)) between 12 and 17 then 'Afternoon'
else 'Evening'
End day_time,
count(*)
from walmart group by branch,day_time order by branch,count(*) desc

--Q.9 Identify 5 branch with highest decrease ration in revenue compare to last year(current year 2023 and last year 2022)

	with revenue_2022 as
		(select branch,sum(total)as revenue
		from walmart
		where extract(year from to_date(date,'dd/mm/yy'))=2022
		group by branch),
	
	revenue_2023 as
	(
		select branch,sum(total)as revenue
		from walmart
		where extract(year from to_date(date,'dd/mm/yy'))=2023
		group by branch
	
	)
	select ls.branch,ls.revenue as last_year_revenue,cs.revenue as current_year_revenue,
	round((ls.revenue-cs.revenue)::numeric/ls.revenue::numeric*100,2)as revenue_decreas_ration
	from revenue_2022 as ls
	join
	revenue_2023 as cs
	on ls.branch=cs.branch
	where ls.revenue>cs.revenue
	order by revenue_decreas_ration desc
	limit 5










