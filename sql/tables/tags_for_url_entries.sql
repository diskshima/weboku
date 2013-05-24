drop table tags_for_url_entries;

create table tags_for_url_entries
(
    id           bigint not null,
    url_entry_id bigint not null,
    tag_id       bigint not null,

    constraint tags_for_url_entries_pk primary key(id)
);

alter table tags_for_url_entries owner to postgres;
