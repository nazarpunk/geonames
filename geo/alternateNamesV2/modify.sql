alter table alternateNamesV2
    modify pk int default 0 not null,
    modify p boolean default false null,
    modify s boolean default false null,
    modify c boolean default false null,
    modify h boolean default false null,
    drop column C9,
    drop column C10;

# index @formatter:off
create index pk on alternateNamesV2 (pk);
create index id on alternateNamesV2 (id);

# iso
create index iso on alternateNamesV2 (iso);
delete from alternateNamesV2 where  iso is null or iso not in ('en', 'ru', 'uk');
alter table alternateNamesV2 modify iso char(2) null;

# boolean
create index p on alternateNamesV2 (p);
create index s on alternateNamesV2 (s);
create index c on alternateNamesV2 (c);
create index h on alternateNamesV2 (h);

delete from alternateNamesV2 where s or c or h;

alter table alternateNamesV2
    drop column s,
    drop column c,
    drop column h;