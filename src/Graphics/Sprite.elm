module Graphics.Sprite where

import Dict

{-|
  An Image stores an Element and its dimensions
 -}
type Image = 
  { image  : Element
  , width  : Int
  , height : Int
  }

{-|
  A sprite is made up of one or more frames.
 -}
type Sprite =
  { length : Int
  , frames : Dict.Dict Int Image
  }

type Animator =
    { sprite : Sprite
    , current : Int
    , rate : Time
    , last : Time
    }

{-|
  Given a Sprite and a Rate, create an Animator that will cycle
  through the frames when (process this) is applied to a signal
  over Time.
 -}
animator : Sprite -> Time -> Animator
animator sprite rate = 
  { sprite = sprite
  , current = 0
  , rate = rate  , last = 0
  }

{-|
  Given an Animator and a time, return an Animator where the current
  frame is selected based on the difference between the current time
  and the last time specified in the Animator.

  A typical use of this would be to apply a Signal Time over an Animator.
  This would cause the return a Signal Animator that is an animation of
  the frames of the sprite.
 
 -}
process : Animator -> Time -> Animator
process animator t =
    let diff = t - animator.last
        skip = floor <| diff / animator.rate
    in if skip > 0 
      then { animator | 
                        current <- (animator.current + skip) `mod` (animator.sprite.length), 
                        last <- t}
      else animator

{-|
  Maps process over a list of Animator

```
processMany anims t = map (flip process t) anims
```
 -}
processMany : [Animator] -> Time -> [Animator]
processMany anims t = map (flip process t) anims

{-|
  Returns the current frame of the animator if its current frame is within
  the bounds of its internal sprite.
 -}
draw : Animator -> Element
draw animator = 
    let maybeE = Dict.lookup (animator.current) (animator.sprite.frames) in
    case maybeE of
      Just img -> img.image
      Nothing -> asText "Illegal current frame"