{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as TIO
import Domain.Movie
import Domain.Winner
import Game.Logic
import HTTP.API

onSuccess :: Movie -> IO ()
onSuccess movie = do
  putStrLn ""
  putStrLn "I know it:"
  putStrLn $ show movie

onFailure :: IO ()
onFailure = do
  putStrLn ""
  putStrLn "Im beaten. I don't know that movie."
  putStrLn ""

takeInput :: IO T.Text
takeInput = do
  putStrLn ""
  putStrLn "Name a movie:"
  TIO.getLine

main :: IO ()
main =
  forever $ do
    putStrLn "I bet you can't tell me a movie I don't know in 3 tries!"
    gameState <- playGame takeInput find onSuccess onFailure
    let (player, movies) = winner gameState
    putStrLn "***************************"
    case player of
      Computer -> putStrLn "I won"
      Human -> putStrLn "You won"
      Nobody msg -> do
        putStrLn "Nobody won"
        putStrLn $ "Error occurred: " ++ show msg
    putStrLn "***************************"
    putStrLn ""
    if (not $ null movies)
      then do
        putStrLn "The movies that I knew about:"
        putStrLn $ showMovies movies
      else return ()
    putStrLn ""
