drop table tags;

create table tags
(
    id bigint not null,
    tag varchar(50) not null,
    constraint tags_pk primary key (id)
);

alter table tags owner to postgres;
