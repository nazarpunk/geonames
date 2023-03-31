drop table if exists alternateNamesV2;

/*
C1 int - alternateNameId : the id of this alternate name
C2 int - geonameid : geonameId referring to id in table 'geoname'
C3 varchar(7) - isolanguage : iso 639 language code 2- or 3-characters; 4-characters 'post' for postal codes and 'iata','icao' and faac for airport codes, fr_1793 for French Revolution names,  abbr for abbreviation, link to a website (mostly to wikipedia), wkdt for the wikidataid
C4 varchar(400) - alternate name : alternate name or name variant
C5 boolean - isPreferredName : '1', if this alternate name is an official/preferred name
C6 boolean - isShortName : '1', if this is a short name like 'California' for 'State of California'
C7 boolean - isColloquial : '1', if this alternate name is a colloquial or slang term. Example: 'Big Apple' for 'New York'.
C8 boolean - isHistoric : '1', if this alternate name is historic and was used in the past. Example 'Bombay' for 'Mumbai'.
C9 varchar(30) - from : from period when the name was used
C10 varchar(30) - to : to period when the name was used
*/

alter table alternateNamesV2
    drop column C9,
    drop column C10;