module Util where

replicate : Int -> a -> [a]
replicate n a =
  if n <= 0 then [] else a::(replicate (n-1) a)
                            
zipWith3 : (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
zipWith3 f xs ys zs =
  case (xs, ys, zs) of
    ((x::xs), (y::ys), (z::zs)) -> ((f x y z) :: (zipWith3 f xs ys zs))
    _ -> []
    
zipWith4 : (a -> b -> c -> d -> e) -> [a] -> [b] -> [c] -> [d] -> [e]
zipWith4 f ws xs ys zs =
  case (ws, xs, ys, zs) of
    ((w::ws), (x::xs), (y::ys), (z::zs)) -> ((f w x y z) :: (zipWith4 f ws xs ys zs))
    _ -> []
    