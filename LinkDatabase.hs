module LinkDatabase (
) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import Delicious
import Data.List
import Data.Time (UTCTime)

main = do
    conn <- connectToDB
    getLinksForUser conn "daisuke"

insertUrl conn = do
    stmt <- prepareInsertUrl conn
    execute stmt [toSql "daisuke", toSql "http://www.google.com/"]

prepareInsertUrl conn =
    prepare conn "PERFORM insert_url(?, ?)"

getLinksForUser conn loginId = do
    results <- quickQuery' conn
        "SELECT * FROM get_links_for_user(?)" [ toSql loginId ]
    return $ map sqlToLink results

getTagsForEntry conn entryId = do
    results <- quickQuery' conn
        "SELECT * FROM get_tags_for_url_entry(?)" [ toSql entryId ]
    return $ map sqlToTags results

upsertLink conn link = do
    stmt <- conn "PERFORM insert_link(?, ?, ?, ?, ?)"
    execute stmt 

connectToDB :: IO Connection
connectToDB = connectPostgreSQL "host=localhost dbname=weboku user=daisuke password=daisuke"

runQueryNoParam conn query = run conn query []

sqlToLink x = case x of
    [title, url, private, comment, time]
        -> Link { title = fromSql title,
                  url = fromSql url,
                  private = fromSql private,
                  comment = fromSql comment,
                  date = fromSql time,
                  tags = [] }
    _ -> error "Could not build link."

sqlToTags x = case x of
    [tags] -> fromSql tags
    _ -> error "Could not build tags."

-- Test data
-- testLink = Link { title = "Google", url = "http://www.google.com", date = (epochToClockTime 1358690486), private = False, tags = ["search", "google"], comment = Nothing }
