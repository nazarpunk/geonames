drop table if exists hierarchy;
create table hierarchy (
	parent_id int,
	child_id int,
	adm varchar(12) default null,
	index (parent_id),
	index (child_id)
) engine = InnoDB default charset = utf8mb4 collate = utf8mb4_general_ci