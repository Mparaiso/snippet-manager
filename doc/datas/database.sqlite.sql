CREATE TABLE IF NOT EXISTS access_levels(
id integer primary key,
access_level varchar(255) not null,
label varchar(255) not null
);

create table if not exists tests(
id integer primary key,
title varchar(255) not null default "default title",
description text not null default "default description",
created datetime ,
updated datetime 
);
create table if not exists menu_item_types(
id integer primary key,
name varchar(255)
);