module Graphics.Animation.BasicAnimationExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import open Graphics.Animation

-- The square does a full rotation every 2 seconds, scales between 1.0
-- and 2.0 on an interval of 4 seconds and travels around in a square path
-- continuously every 8 seconds
square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (100, 100)
           , orientation <- 0
         }
squarePath = Path.path <| map loc [(100,100), (-100,100), (-100,-100), (100,-100), (100,100)]
movement = loopN 2 <| path squarePath (4*second)
rotation = loopN 8 <| rotate 360 (1*second)
scaling = scale 4.0 (8*second)
scaleRotate = scaling <*> rotation
squareBuilder = oscillate <| ease sineOut <| scaleRotate <*> movement
squareAnimation = squareBuilder.build 0 square

scene t =
  let renderables = animateAll [squareAnimation] t
      element = render 400 400 renderables
  in element

main = scene <~ foldp (+) 0 (fps 50)

