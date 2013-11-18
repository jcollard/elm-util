module Graphics.PathTest(test) where

import open Graphics.Path
import Test as T

test = T.test "Graphics.Path" tests

tests = testLineLength ++ testLocationAt

epsilon = 0.0001

assertEquals = T.assertEquals
assertWithTolerance = T.assertWithTolerance epsilon
testcase = T.testCase

loc0 = loc (0, 0)
loc1 = loc (1, 1)
loc2 = loc (1, 2)
loc3 = loc (-1, -1)
loc4 = loc (-1, -2)

line0 = line loc0 loc1

testLineLength = [testLineLength0]

testLineLength0 = 
  testcase "testLineLength0" <|
  assertWithTolerance (sqrt 2) line0.length
  
testLocationAt = [testLocationAt0, testLocationAt1, testLocationAt2, testLocationAt3]

testLocationAt0 =
  testcase "testLocationAt0" <|
  assertEquals loc0 (line0.locationAt 0)
  
testLocationAt1 =
  testcase "testLocationAt1" <|
  assertWithTolerance 1 (line0.locationAt line0.length).left
  
testLocationAt2 =
  testcase "testLocationAt2" <|
  assertWithTolerance 1 (line0.locationAt line0.length).top
  
testLocationAt3 =
  testcase "testLocationAt3" <|
  assertWithTolerance (-1) (line0.locationAt -line0.length).top