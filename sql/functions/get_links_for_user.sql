drop function if exists get_links_for_user(varchar);

create function get_links_for_user(login_id_in varchar(50))
    returns table (title varchar, url varchar, private boolean,
        comment varchar, update_time timestamp with time zone) as $$
    select l.title, ur.url, l.private, l.comment, l.update_time
    from links l
         inner join users us on l.user_id = us.id
         inner join urls ur on l.url_id = ur.id
    where us.login_id = $1 
$$ language sql;
