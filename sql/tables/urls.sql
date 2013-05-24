drop table urls;

create table urls
(
  id bigint not null,
  url varchar(300),
  constraint urls_pk primary key (id)
);

alter table urls owner to postgres;
grant all on table urls to weboku;
