{-# LANGUAGE GADTs #-}

module Domain.Game where

{-|
    Game can be two states
    1. Continue state (which contains current state and next action)
    2. GameOver state (which contains only game results (game state))
-}
data Game m a where
        Continue ::
            (Monad m, Show a, Eq a) => (a -> m (a, Game m a)) -> Game m a
        GameOver :: Game m a
