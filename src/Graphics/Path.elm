module Graphics.Path(Path, 
                     Location, 
                     loc, 
                     line,
                     path,
                     compose) where

import Util
import Graphics.Location as Location

type Location = Location.Location

loc : (Float, Float) -> Location
loc = Location.loc

type Path 
 = { length : Float
   , locationAt : Float -> Location
   }

{-|

  Given a start Location and an end Location produces
  a Path that is a line between the Locations. The locationAt
  0 is the start location and the locationAt (path.length) is the
  end location. All inputs will fall upon the line between the
  two points.

 -}
line : Location -> Location -> Path
line start end =
    let dLeft = end.left - start.left
        dTop = end.top - start.top
        length = Location.distance start end
        locationAt pos =
          let percentage = pos/length
              newLeft = start.left + dLeft*percentage
              newTop = start.top + dTop*percentage
          in Location.loc (newLeft, newTop)
    in { length = length, locationAt = locationAt }
       
{-|       

  Creates a path connecting each Location together in order from left to right.

 -}
path : [Location] -> Path
path ls =
    case ls of
      (a::b::[]) -> line a b
      (a::b::ls) -> Util.foldl compose (line a b) <| pathHelper b (ls)
    
pathHelper : Location -> [Location] -> [Path]
pathHelper a (b::ls) = 
  case ls of
    [] -> [line a b]
    _ -> line a b :: pathHelper b ls
       
{-|       

  Compose two paths together into one with a line segment
  connecting the end of the first path with the start of
  the second path. The length of the path is the sum of the
  two paths plus the line segment connectin them.

 -}
compose : Path -> Path -> Path
compose first second =
  let endFirst = first.locationAt first.length
      startSecond = second.locationAt 0
      mergePath = line endFirst startSecond
      length = first.length + second.length + mergePath.length
      firstWeight = first.length/length
      mergePathWeight = mergePath.length/length
      secondWeight = second.length/length
      locationAt pos =
        let percentage = pos/length
            inFirst = percentage < firstWeight
        in if inFirst then first.locationAt ((percentage/firstWeight)*first.length)
           else 
             let inMerge = (percentage - firstWeight) < mergePathWeight
             in if inMerge then mergePath.locationAt (((percentage - firstWeight)/mergePathWeight)*mergePath.length)
                else
                  second.locationAt (((percentage - firstWeight - mergePathWeight)/secondWeight) * second.length)
  in {length = length, locationAt = locationAt }
            