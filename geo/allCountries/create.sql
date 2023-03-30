drop table if exists allCountries;

/*
C1 int - id : id of record in geonames database
C2 varchar(200) - name : name of geographical point (utf8)
C3 varchar(200) - asciiname : name of geographical point in plain ascii characters
C4 varchar(10000) - alternatenames : alternatenames, comma separated, ascii names automatically transliterated, convenience attribute from alternatename table
C5 double - latitude : latitude in decimal degrees (wgs84)
C6 double - longitude : longitude in decimal degrees (wgs84)
C7 char(1) - feature class : see http://www.geonames.org/export/codes.html
C8 varchar(10) - feature code : see http://www.geonames.org/export/codes.html
C9 char(2) - country code : ISO-3166 2-letter country code, 2 characters
C10 varchar(200) - cc2 : alternate country codes, comma separated, ISO-3166 2-letter country code, 200 characters
C11 varchar(20) - admin1 code       : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code
C12 varchar(80) - admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt
C13 varchar(20) - admin3 code       : code for third level administrative division
C14 varchar(20) -  admin4 code       : code for fourth level administrative division
C15 bigint - population
C16 int - elevation : in meters, integer
C17 integer dem : digital elevation model, srtm3 or gtopo30, average elevation of 3''x3'' (ca 90mx90m) or 30''x30'' (ca 900mx900m) area in meters, integer. srtm processed by cgiar/ciat.
C18 varchar(40) - timezone : the iana timezone id (see file timeZone.txt) varchar(40)
C19 varchar(40) - modification date : date of last modification in yyyy-MM-dd format
 */

alter table allCountries
    drop column C3,
    drop column C4,
    drop column C5,
    drop column C6,
    drop column C10,
    drop column C15,
    drop column C16,
    drop column C17,
    drop column C18,
    drop column C19;
