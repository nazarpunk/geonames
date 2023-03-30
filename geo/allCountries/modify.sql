/*
C1 int - id : id of record in geonames database
C2 varchar(200) - name : name of geographical point (utf8)
C7 char(1) - feature class : see http://www.geonames.org/export/codes.html
C8 varchar(10) - feature code : see http://www.geonames.org/export/codes.html
C9 char(2) - country code : ISO-3166 2-letter country code, 2 characters
C11 varchar(20) - admin1 code       : fipscode (subject to change to iso code), see exceptions below, see file admin1Codes.txt for display names of this code
C12 varchar(80) - admin2 code       : code for the second administrative division, a county in the US, see file admin2Codes.txt
C13 varchar(20) - admin3 code       : code for third level administrative division
C14 varchar(20) -  admin4 code       : code for fourth level administrative division
 */

# type
alter table allCountries
    change C1 id int not null,
    change C2 name varchar(200) not null,
    change C7 fc char(1) null,
    change C8 f varchar(10) null,
    change C9 iso char(2) null,
    change C11 a1 varchar(20) null,
    change C12 a2 varchar(80) null,
    change C13 a3 varchar(20) null,
    change C14 a4 varchar(20) null;

# is country
alter table allCountries
    add co boolean default false not null after iso;
create index co on allCountries (co);

# noinspection SqlWithoutWhere
update allCountries as ac
set ac.co = exists(select 1 from countryInfo where id = ac.id);


# index
create index id on allCountries (id);
create index iso on allCountries (fc);

# fc
create index fc on allCountries (fc);
delete
from allCountries
where fc is null
   or fc not in ('A', 'P');
alter table allCountries
    modify fc char(1) not null;

# f
create index f on allCountries (f);
delete
from allCountries
where not co
  and f not in (
    # A
                'ADM1', # first-order administrative division	a primary administrative division of a country, such as a state in the United States
                'PCL', # political entity
                'PCLD', # dependent political entity
                'PCLI', # independent political entity
                'PCLF', # freely associated state
                'PCLI', # independent political entity
                'PCLIX', # section of independent political entity
                'PCLS', # semi-independent political entity
                'TERR', # territory
    # P
                'PPL', # populated place	a city, town, village, or other agglomeration of buildings where people live and work
                'PPLA', # seat of a first-order administrative division	seat of a first-order administrative division (PPLC takes precedence over PPLA)
                'PPLA2', # seat of a second-order administrative division
                'PPLA3', # seat of a third-order administrative division
                'PPLA4', # seat of a fourth-order administrative division
                'PPLA5', # seat of a fifth-order administrative division
                'PPLC', # capital of a political entity
                'PPLF', # farm village	a populated place where the population is largely engaged in agricultural activities
                'PPLL', # populated locality	an area similar to a locality but with a small group of dwellings or other buildings
                'PPLX', # section of populated place
                'STLMT' #	israeli settlement
    );