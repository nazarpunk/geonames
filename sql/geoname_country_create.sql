drop table if exists geoname_country;
create table geoname_country (
	`iso` text,
	`iso3` text,
	`iso_numeric` int default null,
	`fips` text,
	`country` text,
	`capital` text,
	`area` double default null,
	`population` int default null,
	`continent` text,
	`tld` text,
	`currency_code` text,
	`currency_name` text,
	`phone` text,
	`postal_code_format` text,
	`postal_code_regex` text,
	`languages` text,
	`geonameid` int default null,
	`neighbours` text,
	`equivalent_fips_code` text
) engine = InnoDB default charset = utf8mb4 collate = utf8mb4_general_ci