module Graphics.AnimationTest(tests) where

import open Graphics.Animation
import Graphics.Collage as Collage
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


renderable : Renderable
renderable = { element = group [], location = origin }

startTime = 1*second

-- Create an animation that starts at time 1*second
animation0 = moveAnimation.animate startTime renderable

testBeforeStartLocation0 =
  test "The location should not change before the specified start time" <|
  assertEquals renderable.location (animation0 <| startTime-1).location
  
testBeforeStartLocation1 =
  test "The location should not change before the specified start time" <|
  assertEquals renderable.location (animation0 <| startTime-0.0001).location
  
testStartLocation =
  test "The location should match the start location at the start time" <|
  assertEquals loc0 (animation0 startTime).location
  
testBetweenLocation0 =
  test "The location should be between the start and end location in the middle of the animation." <|
  -- half way
  let time = startTime + (duration/2) 
      expectedLeft = loc0.left + (loc1.left - loc0.left)/2
      actual = (animation0 time).location
  in assertWithTolerance expectedLeft actual.left
     
testBetweenLocation1 =     
  test "The location should be between the start and end location in the middle of the animation." <|
  -- half way
  let time = startTime + (duration/2) 
      expectedTop = loc0.top + (loc1.top - loc0.top)/2
      actual = (animation0 time).location
  in assertWithTolerance expectedTop actual.top
     
testAtEnd0 =
  test "The location should be the end location when the duration is met." <|
  let time = startTime + duration
      expectedTop = loc1.top
      actual = (animation0 time).location
  in assertWithTolerance expectedTop actual.top

testAtEnd1 =
  test "The location should be the end location when the duration is met." <|
  let time = startTime + duration
      expectedLeft = loc1.left
      actual = (animation0 time).location
  in assertWithTolerance expectedLeft actual.left
     
moveAnimationTests = [testBeforeStartLocation0,
                      testBeforeStartLocation1,
                      testStartLocation,
                      testBetweenLocation0,
                      testBetweenLocation1,
                      testAtEnd0,
                      testAtEnd1]
                     
loc2 = loc (50, 50)

duration2 = 2*second
moveAnimation2 = move loc1 loc2 duration2
composedAnimation = moveAnimation `compose` moveAnimation2
animation2 = composedAnimation.animate startTime renderable

testCompositionDuration =
  test "The composition of two animations should have a duration equal to the sum of the two animations durations." <|
  let expectedDuration = duration + duration2
      actualDuration = composedAnimation.duration
  in assertEquals expectedDuration actualDuration
                     
testComposedStart =
  test "The composition of two animations should start with the first animations start." <|
  let expectedStart = loc0
      actualStart = composedAnimation.start
  in assertEquals expectedStart actualStart
     
testComposedEnd =
  test "The composition of two animations should end with the second animations end." <|
  let expectedEnd = loc2
      actualEnd = composedAnimation.end
  in assertEquals expectedEnd actualEnd
  
composeTests = [testCompositionDuration,
                testComposedStart,
                testComposedEnd]     
     
tests = moveAnimationTests ++ composeTests       
