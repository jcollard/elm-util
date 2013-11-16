module Graphics.Animation where

type Location 
 = { left : Float
   , top : Float
   }
   
loc : (Float, Float) -> Location
loc (left, top) = {left = left, top = top}   
   
type Moveable
 = { 
     location : Location 
   }

type Animation a
 = { animate : a -> Time -> (Time -> a) }

type MoveAnimation   
 = { start : Location
   , end   : Location
   , time  : Time
   , animate : Time -> (Time -> Location)
   }
   
move : Location -> Location -> Time -> MoveAnimation
move start end time = 
  let animateMove startTime =
        let dLeft = end.left - start.left
            dTop = end.top - start.top
        in \ t -> 
             if t < startTime
                then start
                else
                  let percentage = min ((t - startTime)/time) 1.0
                      newLeft = start.left + dLeft*percentage
                      newTop = start.top + dTop*percentage
                  in loc (newLeft, newTop)
  in
  { start = start, end = end, time = time, animate = animateMove }