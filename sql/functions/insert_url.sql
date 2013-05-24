DROP FUNCTION IF EXISTS insert_url(VARCHAR, VARCHAR);

CREATE FUNCTION insert_url(login_id_in VARCHAR(50), url_in VARCHAR(300))
    RETURNS void as $$
DECLARE
    user_id_tmp BIGINT;
    url_id_tmp BIGINT;
    new_rel_id BIGINT;
BEGIN
    SELECT INTO user_id_tmp us.id FROM users us where us.login_id = login_id_in;
    SELECT INTO url_id_tmp u.id FROM urls u where u.url = url_in;

    IF url_id_tmp IS NULL THEN
        SELECT INTO url_id_tmp max(id) + 1 FROM urls;
        IF url_id_tmp IS NULL THEN
            SELECT INTO url_id_tmp 0;
        END IF;
        INSERT INTO urls (id, url) VALUES (url_id_tmp, url_in);
    END IF;

    IF NOT EXISTS (SELECT id FROM uut_relations r
        WHERE r.user_id = user_id_tmp
          AND r.url_id = url_id_tmp) THEN
        SELECT INTO new_rel_id max(id) + 1 FROM uut_relations;
        IF new_rel_id IS NULL THEN
            SELECT INTO new_rel_id 0;
        END IF;
        INSERT INTO uut_relations (id, user_id, url_id)
            VALUES (new_rel_id, user_id_tmp, url_id_tmp);
    END IF;
END;
$$ LANGUAGE plpgsql;
