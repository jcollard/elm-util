module Tests where

import Test as T
import Graphics.AnimationTest


animationTest = Graphics.AnimationTest.test

suite = T.testSuite "Elm-Util Test Suite" [animationTest]

main = T.pretty suite
