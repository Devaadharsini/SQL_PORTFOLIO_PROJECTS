
use new;

select top 5* from sm;

select distinct  Post_Type from sm;

-- General Data Exploration
--How many records are in the dataset?

select Count(*) from sm;

--What are the distinct platforms represented in the data?

select distinct  PLATFORM from sm;

--What is the range of dates in the dataset?

select min(post_date) as start_date, max(post_date) as end_date from sm ;

--Engagement Metrics Analysis
--Which posts received the highest and lowest engagement?

select post_type, round(max(engagement_rate),2) as max_er,round(min(engagement_rate),2) as min_er from sm group by post_type ;


--What is the average engagement per platform?

select PLATFORM,round(avg(engagement_rate),2) as avg_er from sm group by PLATFORM;


--Which platform has the highest total engagement?

with high_total_ER as(
select platform,sum(engagement_rate) as total_Er

from sm group by PLATFORM)

select platform,round(max(total_Er),2) as highest_total_engagement from high_total_ER group by PLATFORM;


--Content Performance Analysis
--How does post type (e.g., image, video, text) affect average engagement?

select post_type , round(avg(engagement_rate),2) as avg_Er from sm group by post_Type;


--Temporal Analysis

--What is the trend in total engagement over time?

select post_date , round(sum(engagement_rate),1) as total_er from sm group by post_date order by post_date asc;


--Which day of the week sees the highest average engagement?

select high_avg_er as(
select day(post_date) as day, round(avg(engagement_rate),1) as avg_Er from sm group by post_date  )
select day,max(avg_Er) as high_avg from sm group by day order by day desc;

--User Interaction Analysis
--top 3 users have the highest average engagement per post?

with cte as (
select top 3 post_id ,post_type, round(avg(engagement_rate),2) as high_avg_er from sm group by post_id,post_type )
select post_id ,post_type,max(high_avg_er) as high_avg from cte group by post_id,post_type ;


--Audience Demographics Analysis
--Which age group has the highest average engagement?

with age_cte as (
select Audience_Age,round(avg(engagement_rate),2) as avg_er from sm group by Audience_Age)
select Audience_Age,max(avg_er) as max_avg_er from age_cte group by Audience_Age order by Audience_Age desc;


--What is the distribution of posts across different user locations?

select count(post_id) as dist_post,audience_location from sm group by audience_location order by audience_location asc;

select  top 1* from sm;

-- Do users from different locations show a significant difference in engagement?

select audience_location, round(avg(engagement_rate),2) as avg from sm group by audience_location order by audience_location asc;

--User Behavior Analysis
--What is the average engagement for each user's posts?

select post_id, round(avg(engagement_rate),2) as avg_er from sm group by post_id order by avg_er desc;




-- Post Type Analysis
--Which post types perform best in terms of average engagement?

 select post_type,round(avg(engagement_rate),2) as avg_er from sm group by post_type order by avg_er ;

 --How many posts of each type are in the dataset?

 select post_type,count(*) as num_posts from sm group by post_type order by num_posts; 
 
 --Post Performance Analysis

 --Which posts generate the most comments per share?

 
 select post_id , comments/nullif(shares,0) as comments_per_share from sm  order by comments_per_share desc

 --Which posts have the highest engagement?

select top 1 post_id , round(sum(engagement_rate),2) as total_er from sm group by post_id order by total_er desc;

--What is the average engagement across all posts?

select round(sum(engagement_rate),2) as avg_er from sm;

--How many posts received no engagement at all?

select count(post_id) as no_eng_post from sm where engagement_rate=0;

--What percentage of posts have engagement higher than the average?

WITH AvgEngagement AS (
    SELECT round(AVG(engagement_rate),2) AS avg_engagement 
    FROM sm
)
SELECT 
   COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sm) AS percentage_above_avg
FROM sm, AvgEngagement
WHERE engagement_rate > avg_engagement;


--Post Timing Analysis
--What is the distribution of posts by hour of the day?

with hr_cte as (
select post_id , datepart(hour,Post_Timestamp) as hr  from sm   )
select  count(post_id) as posts , hr from hr_cte group by hr order by hr desc ; 


--Which day of the week has the highest total engagement?
--Highest Engagement Day


with day_cte as (
select  post_date, sum(engagement_rate) as tot_er from sm group by post_date)
select   top  1 datepart(day,post_date) as day , round(max(tot_er),2) as high_er from day_cte group by  datepart(day,post_date) 
order by high_er desc  ;


-- What is the trend of engagement over time?

select DATEPART(hour,post_timestamp) as time , round(avg(engagement_rate),2) as avg from sm group by  DATEPART(hour,post_timestamp) order by time desc;

--Engagement and Interaction Analysis

--Which posts have the highest comments-to-engagement ratio?

select post_id, round(comments/nullif(engagement_rate,0),2) as comments_to_engagement from sm order by comments_to_engagement desc;




-- Engagement Metrics Analysis (Likes, Comments, Shares, Impressions, Reach)

--Which post received the highest number of likes?

select top 1 post_id , max(likes) as likes from sm group by post_id order by likes desc


--What is the average number of likes, comments, and shares per post?

select post_id , round(avg(Likes),2) as avg_likes, round(avg(comments),2) as avg_comments,round(avg(shares),2) as avg_shares
from sm group by post_id ;


--Which posts have the highest engagement rate (likes + comments + shares) relative to impressions?


select top 1 post_id , (likes + comments + shares )*100/nullif(impressions,0)  as relation from sm order by relation desc;

select top 1 post_id , engagement_rate/nullif(impressions,0)  as relation from sm order by relation desc;

--What is the average reach and impressions per post?

select post_id,avg(reach) as avg_reach,avg(impressions) as avg_imp from sm group by post_id;


--Which posts have the highest reach-to-impressions ratio?

select top 1 post_id,reach*100.0/nullif(impressions,0)as reach_to_impressions from sm order by reach_to_impressions desc;

--Which platform generates the highest average likes, comments, and shares per post?

select top 1 platform , avg(likes) as avg_likes,avg(comments) as avg_comments,avg(shares) as avg_shares from sm 
group by platform order by avg_likes desc;

--Audience Analysis (Age, Gender, Location, Interests)
--What is the distribution of posts by audience age group?

select count(post_id) as posts  , Audience_Age from sm group by Audience_Age order by Audience_Age asc;

--How does audience gender affect average engagement (likes, comments, shares)?

select Audience_Gender, avg(likes) as avg_likes,avg(comments) as avg_comments ,avg(shares) as avg_shares from sm group by Audience_Gender;

--Which audience locations generate the highest average impressions?

select top 1 audience_location , avg(impressions) as avg_imp from sm group by audience_location order by avg_imp desc;

--What are the top audience interests based on average reach?

select audience_interests,avg(reach) as avg_reach from sm 

--Which combination of audience age group and gender has the highest average engagement?


select * from sm;

select case 
when audience_age between 0 and 18 then '0-18'
WHEN audience_age BETWEEN 19 AND 34 THEN '19-34'
WHEN audience_age BETWEEN 35 AND 49 THEN '35-49'
WHEN audience_age BETWEEN 50 AND 64 THEN '50-64'
ELSE '65+'
END AS age_group,

audience_gender , avg(engagement_rate) as avg_er 
from sm group by audience_age,audience_gender order by avg_er desc;


with age_cte as (
SELECT
    CASE
        WHEN audience_age BETWEEN 0 AND 18 THEN '0-18'
        WHEN audience_age BETWEEN 19 AND 34 THEN '19-34'
        WHEN audience_age BETWEEN 35 AND 49 THEN '35-49'
        WHEN audience_age BETWEEN 50 AND 64 THEN '50-64'
        ELSE '65+'
    END AS age_group,audience_gender,engagement_rate
    
FROM
    sm)
select age_group, audience_gender , avg(engagement_rate) as avg_Er from age_cte
GROUP BY
    age_group,
    audience_gender
ORDER BY
   age_group  ;
    

---Post and Platform Analysis (platform, post_type)
--What is the distribution of posts by platform?


select platform,count(post_id) as posts from sm group by  platform order by posts desc;


--Which post type performs best in terms of average likes, comments, and shares?

select post_type , avg(likes) as avg_likes,avg(comments) as avg_comments ,avg(shares) as avg_shares 
from sm group by post_type;

--Which platform has the highest reach-to-impressions ratio on average?

select top 1 platform , round(avg(reach*100.0/nullif(impressions,0)),2) as reach_to_impressions 
from sm  group by platform order by reach_to_impressions desc;

--What is the most common post type for each platform?

select post_type,platform,count(post_id) as posts from sm 
group by post_type,platform order by posts desc;

--What is the engagement trend over time for each post type?

select  post_type,datepart(hour,post_timestamp) as time , reach from sm order by time desc


SELECT post_date, post_type, SUM(likes + comments + shares) AS total_engagement 
FROM sm 
GROUP BY post_date, post_type 
ORDER BY post_date, total_engagement DESC;
