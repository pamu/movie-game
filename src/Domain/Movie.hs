{-# LANGUAGE OverloadedStrings #-}

module Domain.Movie where

import Control.Applicative
import Control.Monad
import Data.Aeson (FromJSON(..))
import Data.Aeson.Types
import Data.List
import Data.Text.Lazy hiding (concat, intersperse)

type Year = Text

data Movie = Movie
  { title :: !Text
  , plot :: !Text
  , year :: !Text
  } deriving (Eq)

instance Show Movie where
  show (Movie title plot year) =
    concat $
    intersperse
      "\n"
      [ ""
      , "Title: " ++ show title
      , "Plot: " ++ show plot
      , "Year: " ++ show year
      , ""
      ]

showMinimal :: Movie -> String
showMinimal (Movie title _ year) = show title ++ " from " ++ show year

showMovies :: [Movie] -> String
showMovies movies = concat $ intersperse "\n" $ fmap showMinimal movies

instance FromJSON Movie where
  parseJSON (Object o) =
    Movie <$> o .: "Title" <*> o .: "Plot" <*> (o .: "Year")
  parseJSON _ = mzero
