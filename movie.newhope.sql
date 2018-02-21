--create schema movie;
drop table if exists movie.new_hope;
create table movie.new_hope
(idx integer,
location text,
location_counter integer,
actor text,
lines text,
neg double precision,
neu double precision,
pos double precision,
compound double precision);

copy movie.new_hope
from 'C:\Users\Noah\Desktop\python\starwars\sw_newhope.csv' CSV HEADER;

--remove empty lines (potentially badly parsed actors)
delete 
from movie.new_hope
where lines is null;


--clean location and actor
drop table if exists movie.sw;
create table movie.sw as
select idx, location, location_counter, ''::text as clean_location, ''::text as int_ext, actor, ''::text as clean_actor, 
lines, array_length(regexp_split_to_array(lines, '\s'),1) as word_count, neg, neu, pos, compound
from movie.new_hope;

-- location
update movie.sw set clean_location = split_part(location, ' - ',1);
update movie.sw set int_ext = split_part(location, ' ',1);

--actor
update movie.sw
set clean_actor = replace(actor,'''S VOICE','');



select idx, clean_location, location_counter, clean_actor, lines, neg, neu, pos, compound, word_count
from movie.sw
where neg > 0.3
and pos < 0.3;
 

select clean_actor, count(*)
from movie.sw
group by clean_actor;



select clean_location, location_counter, avg(neg) as avg_neg, avg(neu) as avg_neu, avg(pos) as avg_pos, avg(compound) as avg_compound, count(*) as num_lines
from movie.sw
group by clean_location, location_counter
order by location_counter, clean_location;



select *
from movie.sw
where location_counter > 99


select *
from movie.sw
where idx > 797
and idx < 799


--TO DO
--create a new table with actors as columns and location as rows
--also need 
select clean_actor, count(*)
from movie.sw
group by clean_actor
having count(*) > 5
order by count(*) desc



select *
from movie.sw
order by idx
limit 10


--aggregate by location (will need to create flag for scene change)
create table movie.sw_location_aggregate as




select location, count(*), min(idx), max(idx), max(idx)-min(idx)+1
from movie.sw
group by location
having count(*) > 2





--test
select clean_actor, sum(word_count)
from sw
group by clean_actor;


select actor, sum(word_count)
from sw
group by actor

select clean_location, sum(word_count)
from sw
group by clean_location

select int_ext, sum(word_count)
from sw
group by int_ext

select int_ext, clean_actor, sum(word_count)
from sw
group by int_ext, clean_actor




select actor, replace(actor,'''S VOICE','')
from movie.new_hope
where actor != replace(actor,'''S VOICE','')






select distinct actor
from movie.new_hope


select *
from movie.new_hope
where actor = 'AREA'

select location, actor, count(*)
from movie.new_hope
group by location, actor
order by count(*) desc