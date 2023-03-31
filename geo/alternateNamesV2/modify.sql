/*
C2 int - geonameid : geonameId referring to id in table 'geoname'
C3 varchar(7) - isolanguage : iso 639 language code 2- or 3-characters; 4-characters 'post' for postal codes and 'iata','icao' and faac for airport codes, fr_1793 for French Revolution names,  abbr for abbreviation, link to a website (mostly to wikipedia), wkdt for the wikidataid
C4 varchar(400) - alternate name : alternate name or name variant
C5 boolean - isPreferredName : '1', if this alternate name is an official/preferred name
C6 boolean - isShortName : '1', if this is a short name like 'California' for 'State of California'
C7 boolean - isColloquial : '1', if this alternate name is a colloquial or slang term. Example: 'Big Apple' for 'New York'.
C8 boolean - isHistoric : '1', if this alternate name is historic and was used in the past. Example 'Bombay' for 'Mumbai'.
*/

# type
alter table alternateNamesV2
    change C1 pk int not null,
    change C2 id int not null,
    change C3 iso varchar(7) null,
    change C4 name varchar(400) not null,
    change C5 p boolean null,
    change C6 s boolean null,
    change C7 c boolean null,
    change C8 h boolean null;

# index
create index pk on alternateNamesV2 (pk);
create index id on alternateNamesV2 (id);

# iso
create index iso on alternateNamesV2 (iso);
delete
from alternateNamesV2
where iso not in ('en', 'ru', 'uk');

# boolean
create index s on alternateNamesV2 (s);
create index c on alternateNamesV2 (c);
create index h on alternateNamesV2 (h);

delete
from alternateNamesV2
where s
   or c
   or h;

alter table alternateNamesV2
    drop column s,
    drop column c,
    drop column h;

#p
create index p on alternateNamesV2 (p);
update alternateNamesV2
set p = 0
where p is null;

insert into alternateNamesV2 (pk, id, iso, name, p)
select 0, id, 'en', name, 0
from allCountries;