module Graphics.Animation.MoveAnimationExample where

import Graphics.Collage as Collage
import open Graphics.Animation

-- Creates an Animation from (200, 200) to (-150, 0) 
-- over an interval of 3 seconds using the
-- sine easing function to move between the locations
animation0 : MoveAnimation
animation0 = 
  let start = loc (200, 200)
      end = loc (-150, 0)
  in ease start end (3*second) sine

-- A Blue Circle
ball : Renderable
ball = 
  {
    element = filled blue <| Collage.circle 20
  , location = loc (10, 10)
  }

-- Creates a time varying renderable based on animation0
-- This animation starts at time 0 and renders the ball
animateBall : Time -> Renderable
animateBall = animation0.animate 0 ball

-- Creates an Animation from (-150, -150) to (150, 150)
-- over an interval of 5 seconds using the sqrt function
-- to ease between the two locations
animation1 : MoveAnimation
animation1 = 
  let start = loc (-150, -150)
      end = loc (150, 150)
  in ease start end (5*second) sqrt
     
-- A Red Square
square : Renderable
square =  
  {
    element = filled red <| Collage.square 50
  , location = loc (-150, -150)
  }

-- Creates a time varying renderable based on animation1
-- This animation starts after 1 second and renders the square
animateSquare : Time -> Renderable
animateSquare = animation1.animate (1*second) square

-- Creates an Animation from (150, -150) to (-100, -100)
-- that eases to the location using t^4 taking 1500 milliseconds
-- to complete the transition
animation2 : MoveAnimation
animation2 = 
  let start = loc (150, -150)
      end = loc (-100, -100)
  in ease start end (1500*millisecond) (\ t -> t*t*t*t)
     
-- A Green Triangle
triangle : Renderable
triangle =
  {
    element = filled green <| Collage.ngon 3 50
  , location = loc (150, -150)
  }

-- Creates a time varying renderable based on animation2
-- This animation starts after 2 seconds and renders the triangle
animateTriangle : Time -> Renderable
animateTriangle = animation2.animate (2*second) triangle          

-- A time varying function that renders each element
-- at the specified time
display : Time -> Element
display t = 
  let ball' = animateBall t
      square' = animateSquare t
      triangle' = animateTriangle t
  in render 500 500 [ball', square', triangle']


main = display <~ foldp (+) 0 (fps 50)  