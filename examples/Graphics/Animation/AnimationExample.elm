module Graphics.Animation.BasicAnimationExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import open Graphics.Animation
import open Graphics.Renderable

square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (-100, -100)
         }

builder = (ease sineIn . ease sineIn <|
           path (Path.line (loc (-100, -100)) (loc (0, 0))) <>
           rotate (360 + 50) <>
           scale 8.0 <| 3 * second) >>
          
          (delay (0.2 * second) <|
           scale 0.75 <> 
           rotate (-50) <| 0.2 * second) >>
          
          (delay (0.2 * second) <| loop <| rotate (-360) (3*second))
           
squareAnimation = builder.build 0 square

scene t =
  let renderables = animateAll [squareAnimation] t
      element = render 400 400 renderables
  in element

main = scene <~ foldp (+) 0 (fps 50)

