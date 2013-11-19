module Graphics.Animation.BasicAnimationExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import open Graphics.Animation

-- The triangle moves once starting after 2 seconds.
triangle : Renderable
triangle = { defaultRenderable |
               form <- filled green <| Collage.ngon 3 20
             , location <- loc (-150, 80)  
           }
trianglePath = Path.line (loc (-150, 80)) (loc (150, 80))
triangleAnimation = animatePath trianglePath (2*second)
animateTriangle = triangleAnimation.animate (2*second) triangle

-- The ball oscillates between (-50, -50) and (50, 50) on an interval of
-- 2 seconds (1 second to get between each end) and starts after 1 second
ball : Renderable
ball = { defaultRenderable |
           form <- filled blue <| circle 20
         , location <- loc (-50, -50)  
       }
ballPath = Path.line (loc (-50, -50)) (loc (50, 50))
ballAnimation = oscillate <| animatePath ballPath (1*second)
animateBall = ballAnimation.animate (1*second) ball

-- The square does a full rotation every 2 seconds, scales between 1.0
-- and 2.0 on an interval of 4 seconds and travels around in a square path
-- continuously every 8 seconds
square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (100, 100)  
         }
squarePath = Path.path <| map loc [(100,100), (-100,100), (-100,-100), (100,-100), (100,100)]
movement = loop <| animatePath squarePath (8*second)
rotation = loop <| animateRotate 90 (500*millisecond)
scaling = oscillate <| animateScaleTo 2.0 (2*second)
squareAnimation = mergeMany [scaling, rotation, movement]
animateSquare = squareAnimation.animate 0 square

scene t =
  let renderables = animateAll [animateSquare, animateBall, animateTriangle] t
      element = render 400 400 renderables
  in element

main = scene <~ foldp (+) 0 (fps 50)

