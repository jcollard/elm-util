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
   , animate : Moveable -> Time -> (Time -> Moveable)
   }
   
move : Location -> Location -> Time -> MoveAnimation
move start end time = 
  let animateMove moveable startTime =
        let dLeft = end.left - start.left
            dTop = end.top - start.top
        in \ t -> 
             if t < startTime
                then moveable
                else
                  let percentage = min ((t - startTime)/time) 1.0
                      newLeft = start.left + dLeft*percentage
                      newTop = start.top + dTop*percentage
                  in {moveable | location <- loc (newLeft, newTop)}
  in
  { start = start, end = end, time = time, animate = animateMove }