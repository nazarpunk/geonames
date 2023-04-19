# noinspection SqlWithoutWhereForFile
# @formatter:off

delete from alternateNamesV2 as n where not exists(select 1 from allCountries where id = n.id) or iso is null;

# Киев
update allCountries set a1 = 13 where iso = 'UA' and a1 = 12 and fc='P';
delete from allCountries where id = 703447;
delete from alternateNamesV2 where id = 703447;

delete from alternateNamesV2 where pk = 7841982; # Киевская область

# Севастополь
update allCountries set a1 = 11 where iso = 'UA' and a1 = 20 and fc='P';
delete from allCountries where id = 694422;
delete from alternateNamesV2 where id = 694422;

insert into alternateNamesV2 (pk, id, iso, name, p) select 0, id, 'zz', name,0 from allCountries;

delete from allCountries as c where iso in ('ua','ru') and not exists(select 1 from alternateNamesV2 where id=c.id and iso in('uk','ru'));
delete from alternateNamesV2 as n where not exists(select 1 from allCountries where id = n.id) or iso is null;

# clear names
drop table if exists an;
create table an like alternateNamesV2;

insert into an (pk, id, iso, name, p) select pk, id, iso, name, p from alternateNamesV2 where iso = 'zz';
delete from alternateNamesV2 as n where iso in ('ru', 'uk') and exists(select 1 from an where id = n.id and name = n.name);
drop table if exists an;

# @formatter:on