module Graphics.Animation.BasicAnimationExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import open Graphics.Animation
import open Graphics.Renderable

square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (100, 100)  
         }
squarePath = Path.path <| map loc [(100,100), (-100,100), (-100,-100), (100,-100), (100,100)]
movement = loop <| ease sineOut <| path squarePath (8*second)
rotation = oscillate <| ease sineIn <| rotate 360 (1.5*second)
scaling = oscillate <| scale 2.0 (2*second)
squareBuilder = scaling <*> rotation <*> movement
squareAnimation = squareBuilder.build 0 square

scene t =
  let renderables = animateAll [squareAnimation] t
      element = render 400 400 renderables
  in element

main = scene <~ foldp (+) 0 (fps 50)

