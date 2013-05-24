import System.Time.Utils
import Delicious

main :: IO ()
main = do
    entries <- getEntries
    putStrLn $ show entries

testLink = Link { title = "Google", url = "http://www.google.com", date = (epochToClockTime 1358690486), private = False, tags = ["search", "google"], comment = Nothing }
