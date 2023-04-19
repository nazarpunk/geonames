create table allCountries
(
    id int not null,
    name varchar(200) not null,
    fc char not null,
    f varchar(10) null,
    iso char(2) null,
    co tinyint(1) default 0 not null,
    a1 varchar(20) null,
    a2 varchar(80) null,
    a3 varchar(20) null,
    a4 varchar(20) null
);

create index co
    on allCountries (co);

create index f
    on allCountries (f);

create index fc
    on allCountries (fc);

create index id
    on allCountries (id);

create index iso
    on allCountries (iso);

create index iso_fc_a1
    on allCountries (iso, fc, a1);

create table alternateNamesV2
(
    pk int default 0 not null,
    id int not null,
    iso char(2) null,
    name varchar(400) not null,
    p tinyint(1) default 0 null
);

create index id
    on alternateNamesV2 (id);

create index iso
    on alternateNamesV2 (iso);

create index p
    on alternateNamesV2 (p);

create index pk
    on alternateNamesV2 (pk);

create table dial_code
(
    iso_alpha2 char(2) not null,
    geoname_id int not null,
    flag char(2) not null,
    dial_code char(10) not null,
    min_length int not null,
    max_length int not null,
    sub_min smallint default 0 not null,
    sub_max smallint default 0 not null,
    constraint iso_alpha2
        unique (iso_alpha2)
);

create table vk_city
(
    id int not null
        primary key,
    country_id int null,
    region_id int null,
    name json null,
    area json null
);

create index vk_city_country_id_index
    on vk_city (country_id);

create index vk_city_region_id_index
    on vk_city (region_id);

create table vk_country
(
    id int not null
        primary key,
    iso char(2) null,
    region_count int default 0 not null,
    city_count int default 0 not null,
    name json null
);

create index city_count
    on vk_country (city_count);

create index iso
    on vk_country (iso);

create index region_count
    on vk_country (region_count);

create table vk_region
(
    id int not null
        primary key,
    country_id int null,
    city_count int default 0 not null,
    name json null
);

create index city_count
    on vk_region (city_count);

create index vk_region_country_id_index
    on vk_region (country_id);

create definer = root@localhost function item_name(id int, language char(2)) returns varchar(400) reads sql data
begin
    return (select name
            from alternateNamesV2 as n
            where n.id = id
            order by language_order(n.iso, language) desc, p desc
            limit 1);
end;

create definer = root@localhost function language_order(iso char(2), language char(2)) returns int deterministic
begin
    if language = 'uk' then
        return find_in_set(iso, 'en,ru,uk') ;
    end if;

    if language = 'ru' then
        return find_in_set(iso, 'en,uk,ru') ;
    end if;

    return find_in_set(iso, 'en');
end;

create definer = root@localhost procedure list(IN item varchar(10), IN item_id bigint unsigned, IN _language varchar(10))
proc:
begin

    # countries
    if item = 'co' then
        select c.id, item_name(c.id, _language) as name
        from allCountries as c
        where co;

        leave proc;
    end if;

    # regions
    if item = 're' then #
        select iso into @iso from allCountries where id = item_id and co;
        if @iso is null then
            select null where false;
            leave proc;
        end if;
        select id, item_name(c.id, _language) as name
        from allCountries as c
        where not co
          and iso = @iso
          and f = 'ADM1'
        order by name;
    end if;

    # cities
    if item = 'ci' then #
        select iso, a1 into @iso,@a1 from allCountries where id = item_id and not co;
        if @iso is null or @a1 is null then
            select null where false;
            leave proc;
        end if;

        select id, item_name(c.id, _language) as name
        from allCountries as c
        where not co
          and iso = @iso
          and a1 = @a1
        order by name;
    end if;

end;

