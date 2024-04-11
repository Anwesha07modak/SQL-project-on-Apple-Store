create table appleStore_description_combined AS 

SELECT * FROM appleStore_description1

union ALL

select * from appleStore_description2

union ALL

select * from appleStore_description3

union all 

select * from appleStore_description4


**EXPLANATORY DATA ANALYSIS**

--check the number of unique apps in both tablesAppleStore

select count(distinct id) AS Unique_app_id
from AppleStore

select count(distinct id) AS Unique_app_id
from appleStore_description_combined

--check for any missing values 

select count(*) AS Missing_values
from AppleStore
where track_name is null or user_rating is null or prime_genre is null 

select count(*) AS Missing_values
from appleStore_description_combined
where app_desc is null

---find the number of apps per genre 

select prime_genre, count(*) as number_of_apps
from AppleStore
group by prime_genre
order by number_of_apps DESC

---Overview of the apps rating

select min(user_rating) as min_rating,
       max(user_rating) as max_rating,
       avg(user_rating) as avg_rating
from AppleStore

---How many apps are more than 5 rating 

select DISTINCT count(*) as apps_with_MaxUserRating
from AppleStore
where user_rating ='5'

---Data Analysis

select case 
            when price > 0 then 'paid'
            else 'Free'
         end as APP_Type, 
         avg(user_rating) as Avg_rating 
from AppleStore
group by  APP_Type

---check if apps with more supported language have higher ratings 

select max(lang_num) as max_language_number,
       min(lang_num) as min_language_number
from AppleStore

select case when lang_num < 10 then '<10 languages'
            when lang_num between 10 and 30 then '10-30 languages'
            else '>30 languages'
         end as language,
       round(avg(user_rating),2) as Avg_rating
from AppleStore 
group by language
order by Avg_rating desc

---check genres with low rating


select prime_genre,
       avg(user_rating) as Avg_rating
from AppleStore
group by prime_genre
order by Avg_rating asc
limit 10

---- Check if there is correlation between the length of the app description and the user rating. 

with cte as(
select user_rating
from AppleStore 
group by user_rating)
select apsc.app_desc, cte.user_ratimg
from cte
inner join appleStore_description_combined apsc on cte.id = apsc.id
group by apsc.app_desc, cte.user_ratimg

select max(length(app_desc))
from appleStore_description_combined

select case
          when length(b.app_desc) < 500 then 'short'
          when length(b.app_desc) between 500 and 1000 then 'medium'
          else 'long' end as lengthtype_appdescription,
          round(avg(a.user_rating),2) as average_rating

from AppleStore a
join appleStore_description_combined b
on a.id = b.id
group by lengthtype_appdescription
order by average_rating desc

----Check the top rated apps for each genre
select 
    prime_genre,
    track_name,
    user_rating

from 
    (select 
    prime_genre,
    track_name,
    user_rating,
    rank() over(partition by prime_genre order by user_rating DESC, rating_count_tot desc) as rank
    from 
    AppleStore
    ) as a 
 where
 a.rank = 1



