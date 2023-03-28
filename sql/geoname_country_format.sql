alter table geoname_country
drop column area,
drop column population,
drop column continent,
drop column neighbours,
drop column postal_code_format,
drop column postal_code_regex,
drop column phone,
drop column currency_code,
drop column currency_name,
drop column languages,
drop column tld,
drop column equivalent_fips_code,
drop column capital;

alter table geoname_country modify id int first;

alter table geoname_country
add name json null after name_en;

update geoname_country set name = '{}';

update geoname_country set name = json_remove(name, '$.ua');

#en
update geoname_country set name = json_set(name, '$.en', name_en);

# ru
update geoname_country as g
set g.name = json_set(g.name, '$.ru', (select alternate_name
from alternate_names
where id= g.id and iso='ru'
order by preferred desc
limit 1));

# ua
update geoname_country as g
set g.name = json_set(g.name, '$.uk', (select alternate_name
from alternate_names
where id= g.id and iso='uk'
order by preferred desc
limit 1));