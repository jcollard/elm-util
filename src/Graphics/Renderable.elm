module Graphics.Renderable(Renderable, 
                  defaultRenderable,
                  render) where

import Graphics.Location as Location
import Graphics.Collage as Collage

type Location = Location.Location 

type Renderable
 = { form : Form
   , location : Location
   , orientation : Float
   , scale : Float
   }
   
north : Float
north = 360   
   
defaultRenderable : Renderable
defaultRenderable =
  { form = group []
  , location = Location.loc (0, 0)
  , orientation = north
  , scale = 1.0
  }
   
render : Int -> Int -> [Renderable] -> Element
render width height rs =
  let translate r = Collage.move (r.location.left, r.location.top) r.form
      rotate r = {r | form <- Collage.rotate (degrees r.orientation) r.form}
      scale r = {r | form <- Collage.scale r.scale r.form}
      transformed = map (translate . rotate . scale) rs
      frame = Collage.collage width height transformed
  in frame
