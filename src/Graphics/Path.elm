module Graphics.Path(Path, Location, loc, line) where

import Graphics.Location as Location

type Location = Location.Location

loc : (Float, Float) -> Location
loc = Location.loc

type Path 
 = { length : Float
   , locationAt : Float -> Location
   }

line : Location -> Location -> Path
line start end =
    let dLeft = end.left - start.left
        dTop = end.top - start.top
        length = Location.distance start end
        locationAt pos =
          let percentage = pos/length
              newLeft = start.left + dLeft*percentage
              newTop = start.left + dTop*percentage
          in Location.loc (newLeft, newTop)
    in { length = length, locationAt = locationAt }