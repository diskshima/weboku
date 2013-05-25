module Handler.Links where

import Prelude
import Control.Monad
import Import
import Delicious

getLinksR :: Handler RepHtml
getLinksR = do
    defaultLayout $ do
        links <- liftIO $ getEntriesFromFile "delicious.html"
        $(widgetFile "links")
