module Graphics.Location(Location, 
                         loc,
                         distance,
                         totalDistance) where

import Util (..)

{-|
  A Location within a Form
 -}
type Location 
 = { left : Float
   , top : Float
   }

{-|   
  Creates a Location
 -}
loc : (Float, Float) -> Location
loc (left, top) = {left = left, top = top}   

distance : Location -> Location -> Float
distance l0 l1 = 
  let a = abs (l0.left - l1.left)
      b = abs (l0.top - l1.top)
  in sqrt <| a*a + b*b

totalDistance : [Location] -> Float
totalDistance ls = 
  let (_, val) =
        case ls of
          [] -> (loc (0,0), 0)
          (l::ls) -> foldl (\(l1, acc) l0 -> (l0, acc + (distance l0 l1))) (l, 0) ls
  in val
