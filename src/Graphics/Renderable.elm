module Graphics.Renderable(Renderable, 
                           Location,
                           loc,
                           defaultRenderable,
                           render,
                           path,
                           rotate,
                           scale) where

import open Graphics.Animation
import Graphics.Path as Path
import Graphics.Location as Location
import Graphics.Collage as Collage
type Location = Location.Location 

loc = Location.loc

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

-- Animations
type Path = Path.Path

scale : Float -> Time -> Builder Renderable
scale scale duration =
  let animation percentage renderable =
        let diff = renderable.scale*scale - renderable.scale
            newScale = renderable.scale + diff*percentage
        in { renderable | scale <- newScale }
  in builder animation duration

rotate : Float -> Time -> Builder Renderable
rotate degrees duration =
  let animation percentage renderable =
        let orientation = renderable.orientation + degrees*percentage
        in { renderable | orientation <- orientation }
  in builder animation duration

path : Path -> Time -> Builder Renderable
path path duration =
  let animation percentage renderable =
        let position = path.length * percentage
        in { renderable | location <- path.locationAt position }
  in builder animation duration
