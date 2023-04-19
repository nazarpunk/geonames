drop table if exists allCountries;
create table allCountries
(
    id   int            not null, # id of record in geonames database
    name varchar(200)   not null, # name of geographical point (utf8)
    C3   varchar(200)   null,     # asciiname : name of geographical point in plain ascii characters
    C4   varchar(10000) null,     # alternatenames : alternatenames, comma separated, ascii names automatically transliterated, convenience attribute from alternatename table
    C5   double         null,     # latitude in decimal degrees (wgs84)
    C6   double         null,     # longitude in decimal degrees (wgs84)
    fc   char(1)        null,     # feature class : see http://www.geonames.org/export/codes.html
    f    varchar(10)    null,     # feature code : see http://www.geonames.org/export/codes.html
    iso  char(2)        null,     # country code : ISO-3166 2-letter country code, 2 characters
    C10  varchar(200)   null,     # cc2 : alternate country codes, comma separated, ISO-3166 2-letter country code, 200 characters
    a1   varchar(20)    null,     # admin1 code : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code
    a2   varchar(80)    null,     # admin2 code : code for the second administrative division, a county in the US, see file admin2Codes.txt
    a3   varchar(20)    null,     # admin3 code : code for third level administrative division
    a4   varchar(20)    null,     # admin4 code : code for fourth level administrative division
    C15  bigint         null,     # population
    C16  int            null,     # elevation : in meters
    C17  int            null,     # dem : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
    C18  varchar(40)    null,     # timezone : the iana timezone id (see file timeZone.txt) varchar(40)
    C19  varchar(40)    null      # modification date : date of last modification in yyyy-MM-dd format
);