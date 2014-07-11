module Graphics.Animation.Form(rotate, 
                               move,
                               scale) where

import Graphics.Animation (..)
import Graphics.Collage as Collage

rotate : Float -> Time -> Builder Form
rotate d duration = 
  let animation percentage form =
        let d' = degrees d*percentage
        in Collage.rotate d' form
  in builder animation duration
        
move : (Float, Float) -> Time -> Builder Form
move (left, top) duration =
  let animation percentage form = 
        Collage.move (left*percentage, top*percentage) form
  in builder animation duration
     
scale : Float -> Time -> Builder Form
scale s duration =
  let animation percentage form =
        Collage.scale (1 + (s - 1)*percentage) form
  in builder animation duration
     