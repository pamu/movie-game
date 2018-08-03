{-# LANGUAGE OverloadedStrings #-}

module GameSpec
  ( spec
  ) where

import Control.Monad.Identity
import Data.Text.Lazy
import Domain.APIResult
import Domain.GameState
import Domain.Movie
import Game.Logic (playGame)
import Test.Hspec

spec :: Spec
spec = do
  describe "play game function" $ do
    it "terminates after 3 trials" $ do
      (trials $ runIdentity $ simplePlayGame "scala" "Scala") `shouldBe` 3
    it "ignores case and spaces around " $ do
      (trials $ runIdentity $ simplePlayGame "scala " " ScAlA") `shouldBe` 3
    it "terminates immediately when it fails to find movie for given name" $ do
      (trials $ runIdentity $ simplePlayGame "Haskell" "Scala") `shouldBe` 1
      (trials $ runIdentity $ playGameError "Haskell") `shouldBe` 1
    it "terminates immediately when error like network error occurs" $ do
      let gameState = runIdentity $ playGameFatalError "oops network error"
      trials gameState `shouldBe` 0
      internalError gameState `shouldBe` Just "oops network error"

simplePlayGame query title =
  playGame
    (Identity query)
    (const $
     Identity $
     MoviePayload Movie {title = title, plot = "Scala lang", year = 2018})
    (const $ Identity ())
    (Identity ())

playGameError errorMsg =
  playGame
    (Identity "scala")
    (const $ Identity $ MovieNotFound errorMsg)
    (const $ Identity ())
    (Identity ())

playGameFatalError errorMsg =
  playGame
    (Identity "scala")
    (const $ Identity $ FatalError errorMsg)
    (const $ Identity ())
    (Identity ())
