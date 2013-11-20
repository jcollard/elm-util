module Graphics.Animation.BasicAnimationExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import open Graphics.Animation
import open Graphics.Renderable

-- The square does a full rotation every 2 seconds, scales between 1.0
-- and 2.0 on an interval of 4 seconds and travels around in a square path
-- continuously every 8 seconds
square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (0, 0)
         }
squarePath = Path.path <| map loc [(100,100), (-100,100), (-100,-100), (100,-100), (100,100)]
rotation = 
  let wait = delay (0.25*second) in
  loop <| 
    wait (rotate 360 (1*second)) >> 
    wait (scale 2.0 (1*second)) >>
    wait (rotate (-360) (1*second)) >>
    wait (scale 0.5 (1*second))
           
squareAnimation = rotation.build 0 square

scene t =
  let renderables = animateAll [squareAnimation] t
      element = render 400 400 renderables
  in element

main = scene <~ foldp (+) 0 (fps 50)

