{-# LANGUAGE OverloadedStrings #-}

module Domain.Movie where

import Control.Applicative
import Control.Monad
import Data.Aeson (FromJSON(..))
import Data.Aeson.Types
import Data.List
import Data.Text.Lazy hiding (concat, intersperse)

type Year = Int

data Movie = Movie
  { title :: !Text
  , plot :: !Text
  , year :: !Year
  } deriving (Eq)

instance Show Movie where
  show (Movie title plot year) =
    concat $
    intersperse
      "\n"
      [ "\n"
      , "Title: " ++ show title
      , "Plot: " ++ show plot
      , "Year: " ++ show year
      , "\n"
      ]

showMovies :: [Movie] -> String
showMovies movies = concat $ intersperse "\n" $ fmap show movies

instance FromJSON Movie where
  parseJSON (Object o) =
    Movie <$> o .: "Title" <*> o .: "Plot" <*>
    (fmap (\x -> read x :: Int) (o .: "Year"))
  parseJSON _ = mzero
