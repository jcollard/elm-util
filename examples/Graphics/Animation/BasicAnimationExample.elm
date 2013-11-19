module Graphics.Animation.BasicAnimationExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import open Graphics.Animation

ball : Renderable
ball = { defaultRenderable |
           form <- filled blue <| circle 20
         , location <- loc (-50, -50)  
       }
ballPath = Path.line (loc (-50, -50)) (loc (50, 50))
ballAnimation = oscillate <| animatePath ballPath (1*second)
animateBall = ballAnimation.animate (1*second) ball

square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (100, 100)  
         }
squarePath = Path.path <| map loc [(100,100), (-100,100), (-100,-100), (100,-100), (100,100)]
rotation = loop <| animateRotate 90 (500*millisecond)
movement = loop <| animatePath squarePath (8*second)
scaling = oscillate <| animateScaleTo 2.0 (2*second)
squareAnimation = mergeMany [scaling, rotation, movement]
animateSquare = squareAnimation.animate 0 square

scene t =
  let square' = animateSquare t
      ball' = animateBall t
      element = render 400 400 [square', ball']
  in element

main = scene <~ foldp (+) 0 (fps 50)

