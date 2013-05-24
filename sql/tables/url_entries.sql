drop table url_entries;

create table url_entries
(
    id          bigint not null,
    user_id     bigint not null references users(id),
    url_id      bigint not null references urls(id),
    title       varchar(100) not null,
    private     boolean not null,
    comment     varchar(1000) null,
    update_time timestamp not null,

    constraint url_entries_pk primary key (id)
);

alter table url_entries owner to postgres;
grant all on table urls to weboku;
