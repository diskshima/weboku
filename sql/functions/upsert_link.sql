DROP FUNCTION IF EXISTS upsert_link(VARCHAR, VARCHAR, VARCHAR, BOOLEAN, VARCHAR, TIMESTAMP);

CREATE FUNCTION upsert_link(login_id_ VARCHAR(50),
    url_ VARCHAR(300), title_ VARCHAR(100),
    private_ BOOLEAN, comment_ VARCHAR(1000),
    update_time_ TIMESTAMP)
    RETURNS void as $$
DECLARE
    user_id BIGINT;
    url_id BIGINT;
    entry_id BIGINT;
    update_time TIMESTAMP;
BEGIN
    SELECT INTO user_id us.id FROM users us WHERE us.login_id = login_id_;
    SELECT INTO url_id u.id FROM urls u WHERE u.url = url_;

    -- Insert URL if missing
    IF url_id IS NULL THEN
        SELECT INTO url_id max(u.id) + 1 FROM urls u;

        IF url_id IS NULL THEN
            SELECT INTO url_id 0;
        END IF;

        INSERT INTO urls (id, url) VALUES (url_id, url_);
    END IF;

    SELECT INTO entry_id ue.id FROM url_entries ue WHERE ue.user_id = user_id AND ue.url_id = url_id;


    -- url_entries (assumes the URL would be key/unique)
    IF entry_id IS NULL THEN
        SELECT INTO entry_id max(ue.id) + 1 FROM url_entries ue;
        IF entry_id IS NULL THEN
            SELECT INTO entry_id 0;
        END IF;

        INSERT INTO url_entries (id, user_id, url_id, title, private, comment, update_time)
            VALUES (entry_id, user_id, url_id, title_, private_, comment_, update_time_);
    ELSE
        UPDATE url_entries SET (title, private, comment, update_time)
            = (title_, private_, comment_, update_time_)
            WHERE id = entry_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
