{-# LANGUAGE OverloadedStrings #-}

module Domain.APIError where

import Control.Applicative
import Control.Monad
import Data.Aeson (FromJSON(..))
import Data.Aeson.Types
import Data.Text.Lazy

{-|
  API error when movie is not found
-}
data APIError = APIError
  { error :: !Text
  , response :: !Bool
  } deriving (Eq)

instance FromJSON APIError where
  parseJSON (Object o) =
    APIError <$> o .: "Error" <*> fmap ((==) $ pack "True") (o .: "Response")
  parseJSON _ = mzero
