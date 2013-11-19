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
type AnimationBuilder 
 = { duration : Time
   , build   : Time -> Renderable -> Animation
   }
   
type Animation = Time -> Renderable

animateAll : [Animation] -> Time -> [Renderable]
animateAll anims t =
  case anims of
    [] -> []
    (a::anims) -> a t :: animateAll anims t

ease : (Float -> Float) -> AnimationBuilder -> AnimationBuilder
ease easing animation =
  let build startTime renderable t =
        let percentage = easing <| min 1 (max ((t - startTime)/animation.duration) 0)
            t' = (t - startTime)*percentage
        in animation.build startTime renderable t'
  in {animation| build <- build}

{-| Fade linearly from 0 to 1 to 0 -}
fade : Float -> Float
fade t = if t < 0.5 then 2*t else (1 - t)*2

{-| Start slowly and accelerate. -}
sineIn : Float -> Float
sineIn t = sin ((t-1) * turns 0.25) + 1

{-| Start quickly and deccelerate. -}
sineOut : Float -> Float
sineOut t = sin (t * turns 0.25)

{-| Start slowly, accelerate, and then deccelerate. -}
sineInOut : Float -> Float
sineInOut t = (sin ((2*t-1) * turns 0.25) + 1) / 2

oscillate : AnimationBuilder -> AnimationBuilder
oscillate toRock =
  let duration' = round toRock.duration
      osc n = 
        let n' = n `mod` (duration'*2) 
        in if n' <= duration' then n' else (duration' - (n' `mod` duration'))
      build startTime form t =   
        let t' =
              if t < startTime then t
              else startTime + (toFloat <| osc (round (t - startTime)))
        in toRock.build startTime form t'
  in {toRock| build <- build}
   
loop : AnimationBuilder -> AnimationBuilder
loop toLoop =
    let build startTime form t =
        let t' = 
              if t < startTime then t
              else startTime + (toFloat <| ((round (t - startTime)) `mod` (round toLoop.duration)))
        in toLoop.build startTime form t'
  in {toLoop| build <- build}

mergeMany : [AnimationBuilder] -> AnimationBuilder
mergeMany = foldl1 merge

merge : AnimationBuilder -> AnimationBuilder -> AnimationBuilder
merge a0 a1 =
  let duration = max a0.duration a1.duration
      build startTime renderable t =
        if t < startTime then renderable
        else 
          let first = a0.build startTime renderable t
              second = a1.build startTime first t
          in second
  in {duration = duration, build = build}

buildScaleTo: Float -> Time -> AnimationBuilder
buildScaleTo scaleTo duration =
  let build startTime renderable t =
        let diff = scaleTo - renderable.scale in
        if t < startTime then renderable
        else
          let percentage = min 1 (max 0 (t - startTime)/duration)
              scale = renderable.scale + diff*percentage
          in { renderable | scale <- scale }
  in {duration = duration, build = build}

buildRotate : Float -> Time -> AnimationBuilder
buildRotate degrees duration =
  let build startTime renderable t =
        if t < startTime then renderable
        else
          let percentage = min 1 (max 0 (t - startTime)/duration)
              orientation = renderable.orientation + degrees*percentage
          in {renderable | orientation <- orientation}
  in { duration = duration, build = build }
   
buildPath : Path -> Time -> AnimationBuilder   
buildPath path duration = 
  let build startTime renderable t =
        if t < startTime then renderable
        else
          let percentage = min 1 (max 0 (t - startTime)/duration)
              position = path.length * percentage
              location = path.locationAt position
              newRenderable = {renderable | location <- location}
          in newRenderable
  in { duration = duration, build = build }

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