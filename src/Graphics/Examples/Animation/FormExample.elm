module Graphics.Examples.Animation.FormExample where

import Graphics.Collage as Collage
import Graphics.Animation (..)
import Graphics.Animation.Form (..)

square = Collage.move (-100, -100) <| filled red <| Collage.square 1

builder = (ease sineIn . ease sineIn <|
           move (100, 100) <>
           rotate (4*360 + 50) <>
           scale 200.0 <| 10 * second) >>
          
          (delay (0.2 * second) <|
           scale 0.75 <> 
           rotate (-50) <| 0.2 * second) >>
          
          (delay (0.2 * second) <| loop <| rotate (-360) (3*second))

squareAnimation = builder.build 0 square

scene t =
  let forms = animateAll [squareAnimation] t
      element = collage 400 400 forms
  in element

main = scene <~ foldp (+) 0 (fps 50)
