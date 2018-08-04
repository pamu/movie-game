{-# LANGUAGE OverloadedStrings #-}

module WinnerSpec
  ( spec
  ) where

import Data.List
import Domain.GameState
import Domain.Movie
import Domain.Winner
import Game.Logic (winner)
import Test.Hspec

spec :: Spec
spec = do
  describe "decision" $ do
    it "returns Nobody when error occurs" $ do
      let (value, _) = winner initGameState {internalError = Just "some error"}
      value `shouldBe` (Nobody "some error")
    it
      "returns computer when trials is equal to computer win streak and trials >= 3" $ do
      let (value, _) = winner initGameState {trials = 3, computerWinStreak = 3}
      value `shouldBe` Computer
    it "returns Human when trials is greater than computer win streak" $ do
      let (value, _) = winner initGameState {trials = 2, computerWinStreak = 1}
      value `shouldBe` Human
    it "returns movies after one round which are sorted by year" $ do
      let movie = Movie {title = "Java", plot = "java lang", year = "2016"}
      let movies =
            [ movie
            , movie {title = "Scala", plot = "Scala lang", year = "2017"}
            , movie {title = "Haskell", plot = "Haskell lang", year = "2018"}
            ]
      let sorted = sortOn year movies
      let (_, winnerMovies) =
            winner
              initGameState
              {trials = 3, computerWinStreak = 3, searches = fmap Right movies}
      winnerMovies `shouldBe` sorted
