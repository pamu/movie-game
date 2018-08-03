{-# LANGUAGE OverloadedStrings #-}

module Domain.APIResult where

import Data.Semigroup
import Data.Text.Lazy
import Domain.Movie

data APIResult
  = MoviePayload !Movie
  | MovieNotFound !Text
  | FatalError !Text
  deriving (Show, Eq)

instance Semigroup APIResult where
  a@(MoviePayload _) <> _ = a
  _ <> b@(MoviePayload _) = b
  a <> _ = a
