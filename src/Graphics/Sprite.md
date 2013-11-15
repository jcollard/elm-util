# Graphics.Sprite

  Graphics.Sprite provides a basic framework for creating and animating
  sprites made from multiple images.

#### Types

  * [Image](#image)
  * [Sprite](#sprite)
  * [Animator](#animator)

#### Functions

  * [sprite](#sprite)
  * [animator](#animator)
  * [process](#process)
  * [processMany](#processMany)
  * [draw](#draw)

### Sprites

#### Image

```haskell
{-|
  An Image stores an Element and its dimensions
 -}

type Image = 
  { image  : Element
  , width  : Int
  , height : Int
  }
```

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
sprite : String -> String -> Int -> Int -> Int -> Sprite
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



