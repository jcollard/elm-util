module Tests where

import open Test
import Graphics.AnimationTest


animationTests =
    flow down [text . header . toText <| "Animation Tests", report Graphics.AnimationTest.tests]
    
main = flow down 
  [animationTests]
