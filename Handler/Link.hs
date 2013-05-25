module Handler.Link where

import Prelude
import Control.Monad
import Import
import Delicious

getLinkR :: Handler RepHtml
getLinkR = do
    defaultLayout $ do
        links <- liftIO $ getEntriesFromFile "delicious.html"
        $(widgetFile "link")

linkUrl :: Link -> String
linkUrl (Link _ url _ _ _ _) = url

linkTitle :: Link -> String
linkTitle (Link title _ _ _ _ _) = title
