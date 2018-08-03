module Domain.GameState where

import Data.Text.Lazy
import Domain.Movie
import Domain.Winner

data GameState = GameState
  { trials :: !Int
  , computerWinStreak :: !Int
  , searches :: ![Either Text Movie]
  , internalError :: !(Maybe Text)
  } deriving (Show, Eq)

initGameState :: GameState
initGameState =
  GameState
  {trials = 0, computerWinStreak = 0, searches = [], internalError = Nothing}

collectSuccessfulSearches :: [Either Text Movie] -> [Movie]
collectSuccessfulSearches tried =
  tried >>= (\x -> either (const []) (\m -> [m]) x)
