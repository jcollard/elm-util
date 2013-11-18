module Graphics.LocationTest(test) where

import open Graphics.Location
import Test as T

test = T.test "Graphics.LocationTest" tests

tests = constructor ++ distanceTest

epsilon = 0.0001

assertEquals = T.assertEquals
assertWithTolerance = T.assertWithTolerance epsilon
testcase = T.testCase

loc0 = loc (1, 2)
loc1 = loc (0, 0)
loc2 = loc (1, 1)
loc3 = loc (-1, -1)
loc4 = loc (-1, -2)

constructor = [testConstructor0, testConstructor1]

testConstructor0 =
  testcase "testConstructor0" <|
  assertEquals 1 (loc (1, 2)).left
  
testConstructor1 =
  testcase "testConstructor1" <|
  assertEquals 2 (loc (1, 2)).top
  
distanceTest = [testDistance0, testDistance1, testDistance2, testDistance3, testDistance4, testDistance5, testDistance6]  
  
testDistance0 =
  testcase "testDistance0" <|
  assertWithTolerance (sqrt 2) (distance loc1 loc2)
  
testDistance1 =  
  testcase "testDistance1" <|
  assertWithTolerance (sqrt 2) (distance loc1 loc3)
  
testDistance2 =
  testcase "testDistance2" <|
  assertWithTolerance 1 (distance loc3 loc4)

testDistance3 =
  testcase "testDistance3" <|
  assertWithTolerance 1 (distance loc0 loc2)
  
testDistance4 =
  testcase "testDistance4" <|
  assertWithTolerance (distance loc0 loc1) (distance loc1 loc0)
  
testDistance5 =
  testcase "testDistance5" <|
  assertWithTolerance (distance loc3 loc1) (distance loc1 loc3)  
  
testDistance6 =
  testcase "testDistance6" <|
  assertWithTolerance (1 + sqrt 2) (totalDistance [loc1, loc2, loc0])