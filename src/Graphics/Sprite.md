# Graphics.Sprite

  Graphics.Sprite provides a basic framework for creating and animating
  sprites made from multiple images.

#### Cropping

  * [Crop](#crop)
  * [crops](#crops)

#### Sprites

  * [Sprite](#sprite)
  * [sprite](#sprite-1)
  * [spriteFromSequence](#spritefromsequence)

#### Animating Sprites
  * [animator](#animator-1)
  * [process](#process)
  * [processMany](#processMany)
  * [draw](#draw)

### Cropping

#### Crop
```haskell

{-|
  Defines a rectangular area to be cropped


A typical use would be:


-- Creates a Crop for Sprites of size 32x32
spriteCrop left top = { left = left, top = top, width = 32, height = 32 }

 -}
type Crop =
  { top    : Int
  , left   : Int
  , width  : Int
  , height : Int
  }
```

#### crops
```haskell
crops : Crop -> (Crop -> Crop) -> Int -> [Crop]
```

  Given the starting Crop, a function that determines the
  next Crop in a sequence, and the number of elements in
  a sequence, returns a list containing those crops.
  
A typical use would be:  
  
```haskell
-- An explosion sprite starts on a sprite sheet at position 0 98
explosionStart = spriteCrop 0 98

-- Creates a list of crops for cropping out the explosion sprite where
-- each frame is laid out left to right with 2 pixels of padding between
-- each frame
explosionCrops = crops explosionStart (right 2) 5
```

Two helper functions exist for selecting sequences of franes going right and down.
These functions take in a padding amount to skip between each frame.

```haskell
--  Returns the Crop that is directly to the right of the one provided.
right : Int -> Crop -> Crop

-- Returns the Crop that is directly beneath the one provided.
down : Int -> Crop -> Crop
```


### Sprites

#### Sprite

```haskell
{-|
  A sprite is made up of one or more frames.
 -}
type Sprite =
  { length : Int
  , frames : Dict.Dict Int Image
  }
```

#### sprite
```haskell
sprite : Element -> [Crop] -> Sprite
```

  Given an element to use as a Sprite Sheet and a list
  of crops to use as frames, creates a Sprite where each
  frame is cropped from the specified Element.

A typical use would be:

```haskell
-- Reads in a sprite sheet
sheet = image 196 224 "galagasheet.png"

-- Create a Explosion sprite containing 5 frames
-- explosionCrops is defined above
explosion = sprite sheet explosionCrops
```

```haskell
spriteFromSequence : String -> String -> Int -> Int -> Int -> Sprite
```

  Given an extension, baseName, number of frames, a width, and a height,
  creates a Sprite. For example:

```haskell
-- Creates a Sprite containing frames made up of images
-- named explode0.png, explode1.png, explode2.png, explode3.png, and explode4.png
explosion : Sprite
explosion = sprite "png" "explode" 5 32 32
```

  If the provided number of frames is 1 then a number tag is not added
  to the end of each file name. For example:

```haskell
-- Creates a Sprite containing exactly one frame made of the image
-- named ship.jpg
ship : Sprite
ship = sprite "jpg" "ship" 1 16 16
```

### Animating Sprites

#### Animator

```haskell
type Animator =
    { sprite : Sprite
    , current : Int
    , rate : Time
    , last : Time
    }
```

#### animator
```haskell
animator : Sprite -> Time -> Animator
```

  Given a Sprite and a Rate, create an Animator that will cycle
  through the frames when (process this) is applied to a signal
  over Time.

#### process

```haskell
process : Animator -> Time -> Animator
```

  Given an Animator and a time, return an Animator where the current
  frame is selected based on the difference between the current time
  and the last time specified in the Animator.

  A typical use of this would be to apply a Signal Time over an Animator.
  This would cause the return a Signal Animator that is an animation of
  the frames of the sprite.

#### processMany
```haskell
processMany : [Animator] -> Time -> [Animator]
processMany anims t = map (flip process t) anims
```
  Maps process over a list of Animator


#### draw
```haskell
draw : Animator -> Element
```

  Returns the current frame of the animator if its current frame is within
  the bounds of its internal sprite.



