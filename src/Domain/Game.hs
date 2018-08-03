{-# LANGUAGE GADTs #-}

module Domain.Game where

data Game m a where
        Continue ::
            (Monad m, Show a, Eq a) => (a -> m (a, Game m a)) -> Game m a
        GameOver :: Game m a
