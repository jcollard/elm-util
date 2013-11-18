module Tests where

import Test as T
import Graphics.AnimationTest
import Graphics.LocationTest

animationTest = Graphics.AnimationTest.test
locationTest = Graphics.LocationTest.test

suite = T.testSuite 
        "Elm-Util Test Suite" 
        [animationTest,
         locationTest]

main = T.pretty suite
