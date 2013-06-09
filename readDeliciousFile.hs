import System.Environment (getArgs)
import Control.Monad (liftM)
import Delicious (getEntriesFromFile)

main :: IO ()
main = do
    filepath <- liftM head getArgs
    links <- getEntriesFromFile filepath
    putStrLn $ show links

-- testLink = Link { title = "Google", url = "http://www.google.com", date = (epochToClockTime 1358690486), private = False, tags = ["search", "google"], comment = Nothing }
