module Graphics.Animation where

import Graphics.Collage as Collage

type Location 
 = { left : Float
   , top : Float
   }
   
loc : (Float, Float) -> Location
loc (left, top) = {left = left, top = top}   

type Renderable =
  {
    element : Form
  , location : Location
  }

type Animation a
 = { animate : Time -> (Time -> a) }

type MoveAnimation   
 = { start : Location
   , end   : Location
   , time  : Time
   , animate : Time -> Renderable -> (Time -> Renderable)
   }
   
   
move : Location -> Location -> Time -> MoveAnimation
move start end time = 
  let animateMove startTime renderable =
        let dLeft = end.left - start.left
            dTop = end.top - start.top
        in \ t -> 
             if t < startTime
                then renderable
                else
                  let percentage = min ((t - startTime)/time) 1.0
                      newLeft = start.left + dLeft*percentage
                      newTop = start.top + dTop*percentage
                  in {renderable| location <- loc (newLeft, newTop)}
  in
  { start = start, end = end, time = time, animate = animateMove }

draw : [Renderable] -> Element
draw rs =
  let translate r = Collage.move (r.location.left, r.location.top) r.element
      moved = map translate rs
      frame = Collage.collage 400 400 moved
  in frame
