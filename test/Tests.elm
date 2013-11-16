module Tests where

import Graphics.AnimationTest


animationTests =
    flow down [text . header . toText <| "Animation Tests", Graphics.AnimationTest.report]
    
main = flow down
  [animationTests]
