module Domain.Winner where

import Data.Text.Lazy

data Winner
  = Computer
  | Human
  | Nobody { reason :: !Text}
  deriving (Show, Eq)
