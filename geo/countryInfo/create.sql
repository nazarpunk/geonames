drop table if exists countryInfo;

# create
alter table countryInfo
    change geonameid id int not null first,
    change `#ISO` iso char(2) not null,
    change ISO3 iso3 char(3) not null,
    change `ISO-Numeric` ison int not null,
    modify fips char(2) null,
    change Country country varchar(200) not null,
    drop column Capital,
    drop column `Area(in sq km)`,
    drop column `Population`,
    drop column `Continent`,
    drop column `tld`,
    drop column `CurrencyCode`,
    drop column `CurrencyName`,
    drop column `Phone`,
    drop column `Postal Code Format`,
    drop column `Postal Code Regex`,
    drop column `Languages`,
    drop column `EquivalentFipsCode`;

# index

select *
from allCountries as ac
where ac.id in (select id from countryInfo);