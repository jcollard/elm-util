module Graphics.Animation where

import Util

{-|

  Graphics.Animation provides a framework for building up animations.

 -}

{-|
  An animation is a time based function over some type `a`.
 -}
type Animation a = Time -> a

{-|   
  Given a list of `Animation`s and a `Time`, returns a list of the transformed
  state of each `Animation` at the specified `Time`.
 -}
animateAll : [Animation a] -> Time -> [a]
animateAll anims t =
  case anims of
    [] -> []
    (a::anims) -> a t :: animateAll anims t

{-|
  A Builder is record used to compose and sequence an Animation.

  `duration` - Returns the duration of the `Animation` that this `Builder` creates.
  If this `Builder` loops infinitely, this will return the duration of one cycle.  

  `build` - Given a start `Time` and the initial state to be transformed, 
  builds an `Animation` from this `Builder`

 -}
type Builder a
 = { duration : Time
   , build   : Time -> a -> Animation a
   }

{-|
  Given a transformation function over some state `a` and a duration, create
  a `Builder` that applies the function over the specified duration.

  A transformation function expects a value from [0,1] representing the
  percentage of completion of a transformation and an initial state and returns
  the resulting transformation.
 -}
builder : (Float -> a -> a) -> Time -> Builder a
builder animate duration =
  let build startTime renderable t =
        if t < startTime then renderable
        else animate (min 1 (max 0 ((t - startTime)/duration))) renderable
  in { duration = duration, build = build }

{-|
  Delays an animation by the time specified.
 -}
delay : Time -> Builder a -> Builder a
delay wait animation =
  let duration = animation.duration + wait
      build startTime form t =
        if t < startTime + wait then form
        else animation.build startTime form (t - wait)
  in { duration = duration, build = build }

{-|
  Sequences together two `Builder`s. The final state of the first `Builder`
  is passed in as the starting state for the second `Builder`.
 -}
sequence : Builder a -> Builder a -> Builder a
sequence first second = 
  let duration = first.duration + second.duration
      build startTime form t =
        if t <= startTime + first.duration then first.build startTime form t
        else 
          let lastForm = first.build startTime form (startTime + first.duration) in
          second.build startTime  lastForm (t - first.duration)
  in { duration = duration, build = build }

{-|
  Infix version of `sequence`
 -}
(>>) : Builder a -> Builder a -> Builder a
(>>) = sequence

{-|
  Sequences together a list of `Builder`s from left to right.
 -}
sequenceMany : [Builder a] -> Builder a
sequenceMany = Util.foldl1 sequence

{-|
  Composes two `Builder`s together such that the resulting `Animation`
  is the transformation of the first `Builder` followed by the transformation
  of the second `Builder`.
 -}
compose : Builder a -> Builder a -> Builder a
compose a0 a1 =
  let duration = max a0.duration a1.duration
      build startTime renderable t =
        if t < startTime then renderable
        else 
          let first = a0.build startTime renderable t
              second = a1.build startTime first t
          in second
  in {duration = duration, build = build}

{-|
  Composes together a list of `Builder`s from left to right
 -}
composeMany : [Builder a] -> Builder a
composeMany = Util.foldl1 compose

{-|
  The infix version of `compose`.
 -}
(<*>) : Builder a -> Builder a -> Builder a
(<*>) = compose

{-|
  Composes together two functions from a duration to a `Builder` and results
  in a function that applies a duration to both `Builder`s composed together.
  This can be useful in composing transformations that take the same duration
  to complete.

  For example, if you have a `rotate` and `move` transformation, you might
  do the following:

```
-- Rotates 360 degrees while translating the position by (100, 100) over
-- 2 seconds
animation = rotate 360 <> move (100, 100) <| 2*second
```
 -}
(<>) : (Time -> Builder a ) -> (Time -> Builder a) -> (Time -> Builder a)
(<>) first second t = (first t) <*> (second t)

{-|
  Oscillates the resulting `Animation` indefinitely. The `resulting` animation 
  will play forward and then in reverse.
 -}
oscillate : Builder a -> Builder a
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

{-|
  Loops the resulting `Animation` of a `Builder` the specified number of times.
-}
loopN : Int -> Builder a -> Builder a
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
                                    
{-|   
  Loops the resulting `Animation` indefinitely.
-}
loop : Builder a -> Builder a
loop toLoop =
    let build startTime form t =
        let t' = 
              if t < startTime then t
              else startTime + (toFloat <| ((round (t - startTime)) `mod` (round toLoop.duration)))
        in toLoop.build startTime form t'
  in {toLoop| build <- build}



----------------------
-- Easing Functions --
----------------------

{-|
  Applies an easing function to a `Builder`.  
 -}
ease : (Float -> Float) -> Builder a -> Builder a
ease easing animation =
  let build startTime renderable t =
        let percentage = easing <| min 1 (max ((t - startTime)/animation.duration) 0)
            t' = (t - startTime)*percentage
        in animation.build startTime renderable t'
  in {animation| build <- build}

--  Provided easing Functions by Max Goldsteing

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
