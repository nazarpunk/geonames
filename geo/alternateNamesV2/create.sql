drop table if exists alternateNamesV2;
create table alternateNamesV2
(
    pk   int          not null, # alternateNameId : the id of this alternate name
    id   int          not null, # geonameid : geonameId referring to id in table 'geoname'
    iso  varchar(7)   null,     # isolanguage : iso 639 language code 2- or 3-characters; 4-characters 'post' for postal codes and 'iata','icao' and faac for airport codes, fr_1793 for French Revolution names,  abbr for abbreviation, link to a website (mostly to wikipedia), wkdt for the wikidataid
    name varchar(400) not null, # alternate name : alternate name or name variant
    p    boolean      null,     # isPreferredName : '1', if this alternate name is an official/preferred name
    s    boolean      null,     # isShortName : '1', if this is a short name like 'California' for 'State of California'
    c    boolean      null,     # isColloquial : '1', if this alternate name is a colloquial or slang term. Example: 'Big Apple' for 'New York'.
    h    boolean      null,     #isHistoric : '1', if this alternate name is historic and was used in the past. Example 'Bombay' for 'Mumbai'.
    C9   varchar(30)  null,     # from : period when the name was used
    C10  varchar(30)  null      # to : period when the name was used
);