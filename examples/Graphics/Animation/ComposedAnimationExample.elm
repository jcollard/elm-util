module Graphics.Animation.ComposedAnimationExample where

import Graphics.Collage as Collage
import open Graphics.Animation

-- Creates an Animation from (10, 10) to (-150, 100) 
-- over an interval of 2 seconds
animation0 : MoveAnimation
animation0 = 
  let start = loc (10, 10)
      end = loc (-150, 100)
  in move start end (2*second)
    
-- Creates an Animation from (-150, 100) to (100, -100) 
-- over an interval of 500 milliseconds
animation1 : MoveAnimation
animation1 = 
  let start = loc (-150, 100)
      end = loc (100, -100)
  in move start end (500*millisecond)
     
-- Creates an Animation from (100, -100) to (0, 0) 
-- over an interval of 1 second
animation2 : MoveAnimation
animation2 = 
  let start = loc (100, -100)
      end = loc (0, 0)
  in move start end second

-- Compose animation0 with animation1
composedAnimation0 = animation0 `compose` animation1

-- Compose animation0, animation1, and animation2
composedAnimation1 = composeMany [animation0, animation1, animation2]

-- A Blue Circle
ball : Renderable
ball = 
  {
    element = filled blue <| Collage.circle 20
  , location = loc (10, 10)
  }

-- Create a time varying renderable based on the
-- composition of animation0 and animation1 that 
-- starts at time 0 and renders the ball
animateBall : Time -> Renderable
animateBall = composedAnimation0.animate 0 ball


-- A Green Triangle
triangle : Renderable
triangle =
  {
    element = filled green <| Collage.ngon 3 50
  , location = loc (10, 10)
  }

-- Create a time varying renderable based on the
-- composition of animation0, animation1, and animation2
-- that starts after 1 second and renders the triangle
animateTriangle : Time -> Renderable
animateTriangle = composedAnimation1.animate (1*second) triangle


-- A time varying function that renders the animations
display : Time -> Element
display t = 
  let ball' = animateBall t
      triangle' = animateTriangle t
  in render 500 500 [triangle', ball']


main = display <~ foldp (+) 0 (fps 50)  