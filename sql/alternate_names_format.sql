delete from alternate_names where iso not in('en', 'ru', 'uk');

alter table alternate_names
drop column from_time,
drop column to_time;

delete from alternate_names where colloquial or historic or short;
