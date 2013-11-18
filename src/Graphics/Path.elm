module Graphics.Path where

import Graphics.Location as Location

type Location = Location.Location

type Path 
 = { length : Float
   , locationAt : Float -> Location
   }