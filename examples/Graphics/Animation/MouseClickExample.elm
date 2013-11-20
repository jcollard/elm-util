module Graphics.Animation.MouseClickExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import Mouse
import Signal
import open Graphics.Animation
import open Graphics.Renderable

width = 400
height = 400

toLoc (left, top) = 
  let left' = toFloat <| left - (width `div` 2)
      top' = toFloat <| (height `div` 2) - top
  in loc (left', top')

square : (Int, Int) -> Renderable
square pos = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- toLoc pos
         }

rotation = loop <| rotate 90 (500*millisecond)
scaling = oscillate <| scale 2.0 (2*second)
animationBuilder = scaling <*> rotation

stepTime time state = {state | time <- time}
stepClicks (t, coord) state = 
  if not t then state
  else 
    let square' = square coord
        animations = animationBuilder.build (state.time) square' :: state.animations
    in {state | animations <- animations}


stepState (t, cs) = stepClicks cs . stepTime t

startState = 
  {
    animations = []
  , time = 0
  }

input = lift2 (,) (every (second/32)) clicks
clicks = lift2 (,) Mouse.isClicked Mouse.position

main = scene <~ foldp stepState startState input

scene state =
  let renderables = animateAll state.animations state.time
      element = render width height renderables
  in element