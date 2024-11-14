drop database if exists walmart_proj;
create database walmart_proj;
use walmart_proj;
select * from walmart_analysis;

#adding one more column
select time, 
case when time between "00:00:00" and "12:00:00" then "Morning"
      when time between "12:01:00" and "16:00:00" then "Afternoon"
      else "Evening"
end as Parts_of_the_day from walmart_analysis
order by time;

#adding one more column
alter table walmart_analysis add column Parts_of_the_day text;
update walmart_analysis set Parts_of_the_day=(case when time between "00:00:00" and "12:00:00" then "Morning"
                                                   when time between "12:01:00" and "16:00:00" then "Afternoon"
                                                   else "Evening"
                                             end);

#adding day_name and month_name column
alter table walmart_analysis add column day_name text;
update walmart_analysis set day_name=dayname(date);

alter table walmart_analysis add column month_name text;
update walmart_analysis set month_name=monthname(date);
select * from walmart_analysis;

#GENERIC QUESTION
#Q1. How many unique cities does the data have?
select distinct city,count(*) from walmart_analysis
group by city;

#Q2. In which city is each branch?
select distinct city,branch from walmart_analysis;

#-- What is the total revenue by month?
select sum(total) as total_revenue,month_name from walmart_analysis
group by month_name
order by total_revenue desc;

#-- What month had the largest COGS?
select month_name,sum(cogs) as cogs from walmart_analysis
group by month_name
order by cogs desc;

#-- What is the city with the largest revenue?
select sum(total) as total_revenue,city from walmart_analysis
group by city
order by total_revenue desc;

#-- Which branch sold more products than average product sold?
select branch,sum(Quantity) as qty from walmart_analysis
group by branch
having qty>(select avg(Quantity) from walmart_analysis);
									
# whats the most common payment method
select payment,count(*) from walmart_analysis
group by payment;

#number of sales made in each time of the day per weekday
select Parts_of_the_day,count(*) from walmart_analysis
group by Parts_of_the_day;

#whats the gender distribution per branch
select gender,count(*) from walmart_analysis
where branch="C"
group by gender;

#-- Which time of the day do customers give most ratings?
select distinct Parts_of_the_day,sum(rating) from walmart_analysis
group by Parts_of_the_day;

#-- Which time of the day do customers give most ratings per branch?
select distinct branch,Parts_of_the_day,sum(rating) as rating from walmart_analysis
#where branch="A"
group by branch,Parts_of_the_day
order by branch ;

#-- Which day of the week has the best avg ratings?
select day_name,avg(Rating) from walmart_analysis
group by day_name
order by avg(Rating) desc;

#-- Which day of the week has the best average ratings per branch?
select avg(Rating),day_name from walmart_analysis
group by branch,day_name
having branch="A"

#-- What is the gender of most of the customers?
select gender,count(*) from walmart_analysis
group by gender;

#replacing payment column by payment_mode
alter table walmart_analysis change column Payment Payment_mode text;

# convert text variable for date to date variable
alter table walmart_analysis
modify column date date;
describe walmart_analysis;
 
#how long have been they working by adding another column
alter table walmart_analysis
add column days_stayed int;
update walmart_analysis set days_stayed=timestampdiff(day,date,curdate());

#min and max days stayed
select min(days_stayed) as min_day,max(days_stayed) as max_day from walmart_analysis;

#rating conditions
select rating,count(*),case 
when rating>=9 then "best"
when rating>=7 then "better"
when rating>=5 then "need improvement"
when rating>=4 then "given next chance"
else "bad"
end as remarks from walmart_analysis
group by Rating
order by rating desc;


#find the time at which sales are highest
select hour from (select hour(time) as hour, sum(total) as sales from walmart_analysis
group by hour
order by sales desc
limit 1) total_amount;

#display daily the sales by day of the week
select dayofweek(date) as week,sum(total) from walmart_analysis
group by week
order by week;


####

