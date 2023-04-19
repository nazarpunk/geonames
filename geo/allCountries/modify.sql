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
    drop column C19
;

# is country @formatter:off
alter table allCountries add co boolean default false not null after iso;
create index co on allCountries (co);

# index
create index id on allCountries (id);
create index co_iso on allCountries (co, iso);
create index iso on allCountries (iso);
create index iso_fc_a1 on allCountries (iso,fc,a1);

# co
update allCountries as ac set ac.co = exists(select 1 from countryInfo where id = ac.id) where true;

# fc
create index fc on allCountries (fc);
delete from allCountries where fc is null or fc not in ('A', 'P');
alter table allCountries modify fc char(1) not null;

# f @formatter:on
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