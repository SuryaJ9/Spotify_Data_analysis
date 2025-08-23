
-- Easy Level
-- 1) Get the total number of comments for tracks where licensed = TRUE.
select track,sum(comments) as total from spotify
where lincensed = 'TRUE'
group by track
order by total DESC
limit 3;


-- 2) Find the tracks that belong to the album type single.

select track,count(track) as cnt from spotify 
where album_type = 'single'
group by track;

-- 3)Count the total number of tracks by each artist.

select artist,
count(track) as total_track from spotify
group by artist;

-- Medium Level

-- 1) Calculate the average danceability of tracks in each album.

 select album, avg(danceability) AS avg_danceability
 from spotify
 group by album
 order by avg_danceability;
 -- Medium Level

-- 2) Find the top 5 tracks with the highest energy values.

 select track,round(sum(energy_liveness)::numeric,2) as energy_value from spotify
 group by track
 order by energy_value DESC
 limit 5;
 
 -- 3) List all tracks along with their views and likes where official_video = TRUE.
 
 select track, round(sum(views)::numeric / 1000000,2) as tot_views_in_millions,sum(likes) from
 spotify
 where official_video = 'true'
 group by track
 limit 3;

 -- 4) For each album, calculate the total views of all associated tracks.

select album,
count(track) as tot_track,
round(sum(views)::numeric / 1000000,2) as tot_views_in_millions from spotify
group by album
order by tot_views_in_millions DESC;

-- 5) Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT 
    track,
    artist,
    album,
    stream,
    views,
    (stream - views) AS stream_minus_views
FROM 
    spotify
WHERE 
    stream > views
ORDER BY 
    stream_minus_views DESC;

--- Advanced Level
-- 1) Find the top 3 most-viewed tracks for each artist using window functions.
with Rank_status AS(
select artist,
album,track,views,
RANK() OVER (PARTITION BY artist order by views desc) as rank
from spotify
)
select
artist,album,track,views,rank from Rank_status
where 
rank <= 3
order by
artist,views DESC;

select
track,
artist,
album,
liveness
from spotify
where 
liveness > (select avg(liveness) from spotify)
order by 
liveness DESC;

-- 3) Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte as(
select album,
MAX(energy) as highest_energy,
MIN(energy) as lowest_energy
from spotify
GROUP BY 1
)
select 
album,
highest_energy - lowest_energy as energy_diff
from cte
order by 2 DESC;

-- 4)Find tracks where the energy-to-liveness ratio is greater than 1.2
select
track,
artist,
album,
energy,
liveness,
(energy / NULLIF(liveness,0)) AS energy_liveness_ratio
FROM 
spotify 
where 
(energy / NULLIF(liveness,0)) > 1.2
ORDER BY
energy_liveness_ratio DESC;

-- 5) Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
    track,
    artist,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM 
    spotify
ORDER BY 
    views DESC;
