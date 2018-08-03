module Game.Logic where

import Data.List (sortOn)
import Data.Text.Lazy
import Domain.APIResult
import Domain.Game (Game(..))
import Domain.GameState
       (GameState(..), initGameState, collectSuccessfulSearches)
import Domain.Movie (Year, Movie(..))
import Domain.Winner (Winner(..))

{-|
  Winner declaration logic
  When internal error occurs then nobody is the winner
-}
winner :: GameState -> (Winner, [Movie])
winner (GameState trials computerWinStreak searches internalError) =
  let movies = sortOn year $ collectSuccessfulSearches searches
  in case internalError of
       Just msg -> (Nobody msg, movies)
       Nothing ->
         if trials == computerWinStreak
           then (Computer, movies)
           else (Human, movies)

playGame
  :: (Monad m)
  => m Text -> (Text -> m APIResult) -> (Movie -> m ()) -> (m ()) -> m GameState
playGame nameInput movieFinder onSuccess onFailure =
  stateMachine initGameState continuation
    {-|
      State machine which runs until the next action is exhausted
    -}
  where
    stateMachine
      :: (Monad m)
      => GameState -> Game m GameState -> m GameState
    stateMachine currentState GameOver = return currentState
    stateMachine currentState (Continue f) =
      (f currentState) >>=
      (\(newState, nextAction) -> stateMachine newState nextAction)
    {-|
      Continuation function which holds the core logic and state transitions
    -}
    continuation =
      Continue
        (\state@(GameState trials computerWinStreak searches _) ->
           if trials >= 3
             then return (state, GameOver)
             else do
               name <- nameInput
               result <- movieFinder name
               case result of
                 FatalError msg ->
                   return (state {internalError = Just msg}, GameOver)
                 MovieNotFound _ -> do
                   onFailure
                   return
                     ( (state
                        {trials = trials + 1, searches = (Left name) : searches})
                     , GameOver)
                 MoviePayload movie ->
                   if (strip $ toLower $ title movie) == (strip $ toLower name)
                     then do
                       onSuccess movie
                       return $
                         ( (state
                            { trials = trials + 1
                            , computerWinStreak = computerWinStreak + 1
                            , searches = (Right movie) : searches
                            })
                         , continuation)
                     else do
                       onFailure
                       return
                         ( (state
                            { trials = trials + 1
                            , searches = (Left name) : searches
                            })
                         , GameOver))
