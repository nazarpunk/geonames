alter table geoname
drop column asciiname,
drop column alternatenames,
drop column latitude,
drop column longitude,
drop column population,
drop column elevation,
drop column dem,
drop column timezone,
drop column modification_date;

delete from geoname where feature_class not in ('A', 'P');

alter table geoname
add parent_id int null after id;

create index parent_id on geoname(parent_id);

alter table geoname
add name json null after admin4_code;

update geoname set name = '{}';

#en
update geoname set name = json_set(name, '$.en', name_en);

# ru
set @k = 'ru';


set @k = 'uk';
set @kj = concat('$.', @k);

update geoname as g
set g.name = json_set(g.name, @kj, (select alternate_name
from alternate_names
where id= g.id and iso=@k
order by preferred desc
limit 1));

update geoname as g
set g.name = json_set(g.name, @kj, (select alternate_name
from alternate_names
where id= g.id
order by preferred desc
limit 1))
where json_extract(g.name, @kj) = cast('null' as json);

update geoname as g
set g.name = json_set(g.name, @kj, json_unquote(json_extract(g.name, '$.en')))
where json_extract(g.name, @kj) = cast('null' as json);

# check
select *
from geoname
where json_extract(name, '$.ru') = cast('null' as json) or json_extract(name, '$.en') = cast('null' as json) or
	json_extract(name, '$.ua') = cast('null' as json);
