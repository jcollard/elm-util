module Graphics.Animation.FormExample where

import Graphics.Collage as Collage
import open Graphics.Animation
import open Graphics.Animation.Form

square = Collage.move (-100, -100) <| filled red <| Collage.square 20

builder = (ease sineIn . ease sineIn <|
           move (100, 100) <>
           rotate (360 + 50) <>
           scale 8.0 <| 3 * second) >>
          
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
