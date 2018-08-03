{-# LANGUAGE OverloadedStrings #-}

module HTTP.API where

import Control.Arrow
import Control.Exception
import Control.Monad
import Data.Aeson
import Data.Text.Lazy
import Domain.APIError
import Domain.APIResult
import Domain.Movie
import Network.HTTP.Client
import Network.HTTP.Types.Status (statusCode)
import Prelude hiding (concat, error)

apiKey :: Text
apiKey = "faa04c35"

queryURL :: Text -> Text
queryURL query =
  concat ["http://www.omdbapi.com/?t=", query, "&", "apikey=", apiKey]

find :: Text -> IO APIResult
find query =
  ((try (search query)) :: IO (Either SomeException APIResult)) >>=
  (\either ->
     case either of
       Right value -> return value
       Left _ ->
         return $
         FatalError
           "Fetching results failed, may be check your internet connection.")
  where
    search :: Text -> IO APIResult
    search query = do
      manager <- newManager defaultManagerSettings
      req <- parseRequest $ unpack $ queryURL query
      response <- httpLbs req manager
      let code = statusCode $ responseStatus $ response
      let body = responseBody response
      return $
        if code == 200
          then (handleMovieEither (eitherDecode body :: Either String Movie)) <>
               (handleAPIErrorEither
                  (eitherDecode body :: Either String APIError))
          else MovieNotFound $ pack $ "Bad response code: " ++ show code

handleMovieEither :: Either String Movie -> APIResult
handleMovieEither (Right movie) = MoviePayload movie
handleMovieEither (Left msg) = MovieNotFound $ pack msg

handleAPIErrorEither :: Either String APIError -> APIResult
handleAPIErrorEither (Right apiError) = MovieNotFound $ error apiError
handleAPIErrorEither (Left msg) = MovieNotFound $ pack msg
