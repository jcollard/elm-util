module Util where

replicate : Int -> a -> [a]
replicate n a =
  if n <= 0 then [] else a::(replicate (n-1) a)