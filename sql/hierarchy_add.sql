update geoname as g set g.parent_id = (select parent_id from hierarchy where child_id = g.id);


select child_id, count(child_id) from hierarchy where adm is null group by child_id having count(child_id) > 1;

select parent_id, count(parent_id) from hierarchy group by parent_id having count(parent_id) > 1;