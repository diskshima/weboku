drop table users;

create table users
(
    id bigint not null,
    login_id varchar(50) not null,
    constraint users_pk primary key (id)
);

alter table users owner to postgres;
grant all on table urls to weboku;
