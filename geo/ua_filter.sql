delete
from alternateNamesV2 as an
where an.iso in ('ru', 'uk')
  and an.name not regexp '[А-Яа-я]';

drop table if exists ua_fix;
create table ua_fix
(
    id int not null
);

insert into ua_fix (id)
select an.id
from alternateNamesV2 as an
         left join allCountries as ac on ac.id = an.id
where ac.iso = 'UA'
  and ac.fc = 'P'
  and an.iso in ('ru', 'uk')
  and an.name regexp '[А-Яа-я]';

create index id on ua_fix (id);

delete
from allCountries as ac
where ac.iso = 'UA'
  and ac.fc = 'P'
  and ac.id not in (select id from ua_fix)