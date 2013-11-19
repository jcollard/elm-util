module Graphics.Animation where

import open Util
import Graphics.Path as Path
import Graphics.Location as Location
import Graphics.Collage as Collage
import Graphics.Renderable as Renderable

{-|
  This module provides a framework for creating animations.
 -}

import Graphics.Collage as Collage

{-|

  The animate operation takes in a starting time and an Renderable
  and produces a time varying renderable.

 -}
type Animation 
 = { duration : Time
   , animate  : Time -> Renderable -> (Time -> Renderable) 
   }
   
oscillate : Animation -> Animation
oscillate toRock =
  let duration' = round toRock.duration
      osc n = 
        let n' = n `mod` (duration'*2) 
        in if n' <= duration' then n' else (duration' - (n' `mod` duration'))
      animate startTime form t =   
        let t' =
              if t < startTime then t
              else startTime + (toFloat <| osc (round (t - startTime)))
        in toRock.animate startTime form t'
  in {toRock| animate <- animate}
   
loop : Animation -> Animation
loop toLoop =
    let animate startTime form t =
        let t' = 
              if t < startTime then t
              else startTime + (toFloat <| ((round (t - startTime)) `mod` (round toLoop.duration)))
        in toLoop.animate startTime form t'
  in {toLoop| animate <- animate}

mergeMany : [Animation] -> Animation
mergeMany = foldl1 merge

merge : Animation -> Animation -> Animation
merge a0 a1 =
  let duration = max a0.duration a1.duration
      animate startTime renderable t =
        if t < startTime then renderable
        else 
          let first = a0.animate startTime renderable t
              second = a1.animate startTime first t
          in second
  in {duration = duration, animate = animate}

animateScaleTo: Float -> Time -> Animation
animateScaleTo scaleTo duration =
  let animate startTime renderable t =
        let diff = scaleTo - renderable.scale in
        if t < startTime then renderable
        else
          let percentage = min 1 (max 0 (t - startTime)/duration)
              scale = renderable.scale + diff*percentage
          in { renderable | scale <- scale }
  in {duration = duration, animate = animate}

animateRotate : Float -> Time -> Animation
animateRotate degrees duration =
  let animate startTime renderable t =
        if t < startTime then renderable
        else
          let percentage = min 1 (max 0 (t - startTime)/duration)
              orientation = renderable.orientation + degrees*percentage
          in {renderable | orientation <- orientation}
  in { duration = duration, animate = animate }
   
animatePath : Path -> Time -> Animation   
animatePath path duration = 
  let animate startTime renderable t =
        if t < startTime then renderable
        else
          let percentage = min 1 (max 0 (t - startTime)/duration)
              position = path.length * percentage
              location = path.locationAt position
              newRenderable = {renderable | location <- location}
          in newRenderable
  in { duration = duration, animate = animate }

-- Re-Export Graphics.Location
type Location = Location.Location

loc : (Float, Float) -> Location
loc = Location.loc


-- Re-Export Graphics.Path

type Path = Path.Path
type Renderable = Renderable.Renderable

defaultRenderable : Renderable
defaultRenderable = Renderable.defaultRenderable

render : Int -> Int -> [Renderable] -> Element
render = Renderable.render