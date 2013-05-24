drop function if exists get_tags_for_url_entry(varchar);

create function get_tags_for_url_entry(entry_id bigint)
    returns table (tag varchar) as $$
    select t.tag
    from tags_for_url_entries tu
         inner join tags t on t.id = tu.tag_id
    where tu.url_entry_id = entry_id
$$ language sql;
