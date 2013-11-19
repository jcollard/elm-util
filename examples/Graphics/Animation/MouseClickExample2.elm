module Graphics.Animation.MouseClickExample where

import Graphics.Collage as Collage
import Graphics.Path as Path
import Mouse
import Signal
import open Graphics.Animation

width = 400
height = 400

toLoc (left, top) = 
  let left' = toFloat <| left - (width `div` 2)
      top' = toFloat <| (height `div` 2) - top
  in loc (left', top')

square : Renderable
square = { defaultRenderable |
             form <- filled red <| Collage.square 20
           , location <- loc (0,0)
         }

rotation = loop <| buildRotate 90 (500*millisecond)
scaling = oscillate <| buildScaleTo 2.0 (2*second)

animation state = 
  if state.length < 2 then (merge rotation scaling).build 0 square
  else
    let p = loop <| 
            buildPath 
              (Path.path <| state.positions ++ [head state.positions]) 
              (8*second)
    in (mergeMany [rotation, scaling, p]).build 0 square

stepTime time state = {state | time <- time}
stepClicks (t, coord) state = 
  if not t then state
  else {state | positions <- state.positions ++ [(toLoc coord)]
              , length <- state.length + 1 }


stepState (t, cs) = stepClicks cs . stepTime t

startState = 
  {
    positions = []
  , length = 0
  , time = 0
  }

input = lift2 (,) (every (second/32)) clicks
clicks = lift2 (,) Mouse.isClicked Mouse.position

main = scene <~ foldp stepState startState input

scene state =
  let renderables = animation state state.time
      element = render width height [renderables]
  in element