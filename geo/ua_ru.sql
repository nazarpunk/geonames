drop table if exists n;
create table n
(
    `id`   int not null,
    `iso`  varchar(7) default null,
    `name` varchar(400),
    `ru`   varchar(400),
    `uk`   varchar(400),
    key `id` (`id`),
    key `iso` (`iso`)
) engine = InnoDB;

insert into n (id, iso, name)
select id, iso, c.name
from allCountries as c
where c.iso = 'ua'
  and c.fc = 'P'
  and c.f in ('PPL', 'PPLC', 'PPLA', 'PPLA2', 'PPLA3');

update n
set ru = (select name from alternateNamesV2 where id = n.id and iso = 'ru' limit 1),
    uk = (select name from alternateNamesV2 where id = n.id and iso = 'uk' limit 1)
where true;

delete
from allCountries
where iso = 'ua'
  and fc = 'P'
  and id not in (select id from n where ru is not null and uk is not null);

delete
from alternateNamesV2 as n
where not exists(select 1 from allCountries where id = n.id);

drop table if exists n;