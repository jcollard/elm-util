module Graphics.AnimationTest(tests) where

import open Graphics.Animation
import Time
import Test as T

epsilon = 0.0001

assertEquals = T.assertEquals
assertWithTolerance = T.assertWithTolerance epsilon
test = T.test

origin = loc (0, 0)
loc0 = loc (4, 13)
loc1 = loc (-10, -17.2)

duration = second

-- Move from the (4,13) to (-10, 17.2) in 1 second
moveAnimation : MoveAnimation
moveAnimation = move loc0 loc1 duration

moveable : Moveable
moveable = { location = origin }

startTime = 1*second

-- Create an animation that starts at time 1*second
animation0 = moveAnimation.animate moveable startTime

testBeforeStartLocation0 =
  test "The location should not change before the specified start time" <|
  assertEquals origin (animation0 <| startTime-1).location
  
testBeforeStartLocation1 =
  test "The location should not change before the specified start time" <|
  assertEquals origin (animation0 <| startTime-0.0001).location
  
testStartLocation =
  test "The location should match the start location at the start time" <|
  assertEquals loc0 (animation0 startTime).location
  
testBetweenLocation0 =
  test "The location should be between the start and end location in the middle of the animation." <|
  -- half way
  let time = startTime + (duration/2) 
      expectedLeft = loc0.left + (loc1.left - loc0.left)/2
      actual = animation0 time
  in assertWithTolerance expectedLeft actual.location.left
     
testBetweenLocation1 =     
  test "The location should be between the start and end location in the middle of the animation." <|
  -- half way
  let time = startTime + (duration/2) 
      expectedTop = loc0.top + (loc1.top - loc0.top)/2
      actual = animation0 time
  in assertWithTolerance expectedTop actual.location.top
     
testAtEnd0 =
  test "The location should be the end location when the duration is met." <|
  let time = startTime + duration
      expectedTop = loc1.top
      actual = animation0 time  
  in assertWithTolerance expectedTop actual.location.top

testAtEnd1 =
  test "The location should be the end location when the duration is met." <|
  let time = startTime + duration
      expectedLeft = loc1.left
      actual = animation0 time  
  in assertWithTolerance expectedLeft actual.location.left
     
moveAnimationTests = [testBeforeStartLocation0,
                      testBeforeStartLocation1,
                      testStartLocation,
                      testBetweenLocation0,
                      testBetweenLocation1,
                      testAtEnd0,
                      testAtEnd1]
                     
tests = moveAnimationTests                     
--report = T.report moveAnimationTests