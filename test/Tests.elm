module Tests where

import Test as T
import Graphics.AnimationTest
import Graphics.LocationTest
import Graphics.PathTest

animationTest = Graphics.AnimationTest.test
locationTest = Graphics.LocationTest.test
pathTest = Graphics.PathTest.test

suite = T.testSuite 
        "Elm-Util Test Suite" 
        [animationTest,
         locationTest,
         pathTest]

main = T.pretty suite
