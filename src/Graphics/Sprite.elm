module Graphics.Sprite(Image, 
                       Sprite,
                       sprite,
                       animator,
                       process,
                       processMany,
                       draw) where

{-|

  Provides a basic framework for creating and animating sprites made from
  multiple images.

 -}

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

{-|
  Given an extension, baseName, number of frames, a width, and a height,
  creates a Sprite. For example:

```
-- Creates a Sprite containing frames made up of images
-- named explode0.png, explode1.png, explode2.png, explode3.png, and explode4.png
explosion : Sprite
explosion = sprite "png" "explode" 5 32 32
```

  If the provided number of frames is 1 then a number tag is not added
  to the end of each file name. For example:

```
-- Creates a Sprite containing exactly one frame made of the image
-- named ship.jpg
ship : Sprite
ship = sprite "jpg" "ship" 1 16 16
```

 -}
sprite : String -> String -> Int -> Int -> Int -> Sprite
sprite ext baseName parts width height = toSprite <| map (toImage width height) (createList ext baseName parts)

toImage : Int -> Int -> String -> Image
toImage width height src = 
  { 
    image = image width height src,
    width = width,
    height = height
  }

toSprite : [Image] -> Sprite
toSprite imgs = 
  let n = length imgs in
  let assocs = zip [0..n] imgs in
  { 
    length = n,
    frames = Dict.fromList assocs
  }

createList : String -> String -> Int -> [String]
createList ext baseName n = 
  if n > 1 then createList' ext baseName n 0
  else [baseName ++ "." ++ ext]

createList' : String -> String -> Int -> Int -> [String]
createList' ext baseName ct n = 
  case ct of
    0 -> []
    _ -> (baseName ++ (show n) ++ "." ++ ext) :: (createList' ext baseName (ct-1) (n+1))

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