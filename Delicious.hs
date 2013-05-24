module Delicious (
    Link(..),
    linkEquals,
    urlEquals,
    stripLastSlash,
    getEntriesFromFile
) where

import Prelude
import System.IO.UTF8 as U8
import Data.Time (UTCTime)
import Data.Time.Clock.POSIX (posixSecondsToUTCTime)
import Text.StringLike
import Text.HTML.TagSoup
import Data.List.Split

data Link = Link { title   :: String,
                   url     :: String,
                   date    :: UTCTime,
                   private :: Bool,
                   tags    :: [String],
                   comment :: Maybe String }
    deriving (Show)

instance Eq Link where
    (Link _ url1 _ _ _ _) == (Link _ url2 _ _ _ _) = url1 == url2

linkEquals :: Link -> Link -> Bool
linkEquals (Link _ url1 _ _ _ _) (Link _ url2 _ _ _ _) = urlEquals url1 url2

urlEquals :: String -> String -> Bool
urlEquals url1 url2 = (stripLastSlash url1) == (stripLastSlash url2)

stripLastSlash :: String -> String
stripLastSlash (x:xs)
    | x:xs == '/':[] = []
    | x:xs == x:[]   = x : xs
    | otherwise      = x : (stripLastSlash xs)

getEntriesFromFile :: String -> IO [Link]
getEntriesFromFile filename = do
    text <- U8.readFile filename
    return $ parseDeliciousFile text

parseDeliciousFile :: String -> [Link]
parseDeliciousFile text = buildLinks $ takeDTTags $ parseTags text

takeDTTags :: StringLike a => [Tag a] -> [Tag a]
takeDTTags tags = head $ sections (~== ("<DT>" :: String)) tags

buildLinks :: [Tag String] -> [Link]
buildLinks x = case x of
    TagOpen "DT" [] : TagOpen "A" attr : TagText title : TagClose "A" : TagText _ : nextTag : nextNextTag : xs
        -> case nextTag of 
            TagOpen "DD" _ -> buildLinkFromAttribute title attr (takeText nextNextTag)  : buildLinks xs
            _              -> buildLinkFromAttribute title attr Nothing : buildLinks (nextTag : nextNextTag : xs)
    _ -> []

takeText :: Tag String -> Maybe String
takeText tag = case tag of
    TagText text -> Just text
    _            -> Nothing

buildLinkFromAttribute title attr comment
    = case attr of
        [("HREF", url), ("ADD_DATE", date), ("PRIVATE", private), ("TAGS", tags)]
            -> buildLink title url date private tags comment
        _   -> error "Failed to match attributes"

buildLink title url dateStr private tags comment
    = Link { title = title, url = url,
             date = stringToUTCTime dateStr,
             private = (isPrivate private),
             tags = (splitOn "," tags),
             comment = comment }

stringToUTCTime = posixSecondsToUTCTime . fromIntegral . read

isPrivate :: String -> Bool
isPrivate str = case str of
    "0" -> False
    _   -> True

findDuplicates :: Eq a => [a] -> [a]
findDuplicates = findDuplicatesBy (==)

findDuplicatesBy :: (a -> a -> Bool) -> [a] -> [a]
findDuplicatesBy f (x:xs)
    | count >= 2 = x : leftOver
    | otherwise  = leftOver
    where count = countBy (f x) (x:xs)
          leftOver = findDuplicatesBy f xs
findDuplicatesBy _ _ = []

countBy :: (a -> Bool) -> [a] -> Int
countBy p (x:xs) = case p x of
    True  -> 1 + countBy p xs
    False -> countBy p xs
countBy _ [] = 0
