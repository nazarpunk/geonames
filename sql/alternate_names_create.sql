drop table if exists alternate_names;

create table `alternate_names` (
	`id` int default null,
	`geonameid` int default null,
	`iso` varchar(10),
	`alternate_name` text,
	`preferred` tinyint(1) default null,
	`short` tinyint(1) default null,
	`colloquial` tinyint(1) default null,
	`historic` tinyint(1) default null,
	`from_time` text,
	`to_time` text,
	index (id),
	index (geonameid)
) engine = InnoDB default charset = utf8mb4 collate = utf8mb4_general_ci