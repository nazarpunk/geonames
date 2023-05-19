drop table if exists npData;
create table npData
(
    id int not null,            # id of record in geonames database
    ref varchar(255),
    distance int,
    ua varchar(255),
    ru varchar(255),
    name varchar(200) not null, # name of geographical point (utf8)
    pnt POINT not null srid 0,
    fc char(1) null,            # feature class : see http://www.geonames.org/export/codes.html
    f varchar(10) null,         # feature code : see http://www.geonames.org/export/codes.html
    a1 varchar(20) null,        # admin1 code : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code
    a2 varchar(80) null,        # admin2 code : code for the second administrative division, a county in the US, see file admin2Codes.txt
    a3 varchar(20) null,        # admin3 code : code for third level administrative division
    a4 varchar(20) null,        # admin4 code : code for fourth level administrative division
    spatial index (pnt)
);

insert into npData (id, name, pnt, fc, f, a1, a2, a3, a4)
select id,
       name,
       st_pointfromtext(concat('POINT(', lon, ' ', lat, ')')),
       fc,
       f,
       a1,
       a2,
       a3,
       a4
from allCountries
where iso = 'UA'
  and fc = 'P';

update npData as d
set d.ref = (select ref from np order by st_distance_sphere(pnt, d.pnt) limit 1)
where true;

update npData a
    left join np as b on
        b.Ref = a.ref
set a.ua       = b.Description,
    a.ru       = b.DescriptionRu,
    a.distance = st_distance_sphere(a.pnt, b.pnt)
where true;

delete
from npData
where distance > 500;

insert into alternateNamesV2 (pk, id, iso, name, p)
select 0, id, 'uk', ua, true
from npData;

insert into alternateNamesV2 (pk, id, iso, name, p)
select 0, id, 'ru', ru, true
from npData;
