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

delay : Time -> AnimationBuilder -> AnimationBuilder
delay wait animation =
  let duration = animation.duration + wait
      build startTime form t =
        if t < startTime + wait then form
        else animation.build startTime form (t - wait)
  in { duration = duration, build = build }

sequence : AnimationBuilder -> AnimationBuilder -> AnimationBuilder
sequence first second = 
  let duration = first.duration + second.duration
      build startTime form t =
        if t <= startTime + first.duration then first.build startTime form t
        else 
          let lastForm = first.build startTime form (startTime + first.duration) in
          second.build startTime  lastForm (t - first.duration)
  in { duration = duration, build = build }

(>>) : AnimationBuilder -> AnimationBuilder -> AnimationBuilder
(>>) = sequence

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
  in {toRock| build <- build, duration <- toRock.duration * 2}

loopN : Int -> AnimationBuilder -> AnimationBuilder
loopN n toLoop =
  let duration = toLoop.duration*(toFloat n)
      looping = loop toLoop
      build startTime form t =
        let t' = t - startTime
            loopAnimation = looping.build startTime form
            animation = toLoop.build startTime form
        in if t' < duration then loopAnimation t'
           else animation t'
  in { duration = duration, build = build }
                                    
   
loop : AnimationBuilder -> AnimationBuilder
loop toLoop =
    let build startTime form t =
        let t' = 
              if t < startTime then t
              else startTime + (toFloat <| ((round (t - startTime)) `mod` (round toLoop.duration)))
        in toLoop.build startTime form t'
  in {toLoop| build <- build}

(<>) : (Time -> AnimationBuilder) -> (Time -> AnimationBuilder) -> (Time -> AnimationBuilder)
(<>) first second t = (first t) <*> (second t)

mergeMany : [AnimationBuilder] -> AnimationBuilder
mergeMany = foldl1 merge

(<*>) : AnimationBuilder -> AnimationBuilder -> AnimationBuilder
(<*>) = merge

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

builder : (Float -> Renderable -> Renderable) -> Time -> AnimationBuilder
builder animate duration =
  let build startTime renderable t =
        if t < startTime then renderable
        else animate (min 1 (max 0 ((t - startTime)/duration))) renderable
  in { duration = duration, build = build }

scale : Float -> Time -> AnimationBuilder
scale scale duration =
  let animation percentage renderable =
        let diff = renderable.scale*scale - renderable.scale
            newScale = renderable.scale + diff*percentage
        in { renderable | scale <- newScale }
  in builder animation duration

rotate : Float -> Time -> AnimationBuilder
rotate degrees duration =
  let animation percentage renderable =
        let orientation = renderable.orientation + degrees*percentage
        in { renderable | orientation <- orientation }
  in builder animation duration

path : Path -> Time -> AnimationBuilder
path path duration =
  let animation percentage renderable =
        let position = path.length * percentage
        in { renderable | location <- path.locationAt position }
  in builder animation duration

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