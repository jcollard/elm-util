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
 = { start : a
   , end : a
   , duration : Time
   , animate : Time -> Renderable -> (Time -> Renderable) 
   }

type MoveAnimation = Animation Location

move : Location -> Location -> Time -> MoveAnimation
move start end duration = 
  let animateMove startTime renderable =
        let dLeft = end.left - start.left
            dTop = end.top - start.top
        in \ t -> 
             if t < startTime
                then renderable
                else
                  let percentage = min ((t - startTime)/duration) 1.0
                      newLeft = start.left + dLeft*percentage
                      newTop = start.top + dTop*percentage
                  in {renderable| location <- loc (newLeft, newTop)}
  in
  { start = start, end = end, duration = duration, animate = animateMove }

draw : [Renderable] -> Element
draw rs =
  let translate r = Collage.move (r.location.left, r.location.top) r.element
      moved = map translate rs
      frame = Collage.collage 400 400 moved
  in frame

composeMany : [Animation a] -> Animation a
composeMany (a::anims) = foldl compose a anims
   
compose : Animation a -> Animation a -> Animation a
compose ma0 ma1 =
  let start = ma0.start
      end = ma1.end
      duration = ma0.duration + ma1.duration
      animateMove startTime renderable =
        \t -> if t < startTime
                 then renderable
                 else 
                   let currentTime = t - startTime in
                   if currentTime <= ma0.duration
                     then ma0.animate startTime renderable t
                     else ma1.animate startTime renderable (t - ma0.duration)
  in 
   { start = start
   , end = end
   , duration = duration
   , animate = animateMove}
   
foldl : (a -> b -> a) -> a -> [b] -> a
foldl f z0 xs0 = 
  let lgo z zs =
        case zs of
             [] -> z
             (x::xs) -> lgo (f z x) xs
  in lgo z0 xs0
