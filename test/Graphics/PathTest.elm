module Graphics.PathTest(test) where

import open Graphics.Path
import Test as T

test = T.test "Graphics.Path" tests

tests = testLineLength ++ testLocationAt ++ testCompose

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
line1 = line loc1 loc2

path0 = compose line0 line1

testLineLength = [testLineLength0, testLineLength1]

testLineLength0 = 
  testcase "testLineLength0" <|
  assertWithTolerance (sqrt 2) line0.length
  
testLineLength1 =  
  testcase "testLineLength1" <|
  assertEquals 1 line1.length
  
testLocationAt = [testLocationAt0, testLocationAt1, testLocationAt2, testLocationAt3,
                  testLocationAt4, testLocationAt5, testLocationAt6]

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
  
testLocationAt4 =
  testcase "testLocationAt4" <|
  assertWithTolerance 1 (line1.locationAt 0).left

testLocationAt5 =
  testcase "testLocationAt5" <|
  assertWithTolerance 1.5 (line1.locationAt 0.5).top

testLocationAt6 =
  testcase "testLocationAt6" <|
  assertWithTolerance 1 (line1.locationAt 0.5).left
  
testCompose = [testCompose0, testCompose1, testCompose2,
               testCompose3, testCompose4]

testCompose0 =
  testcase "testCompose0" <|
  assertEquals (1 + (sqrt 2)) (compose line0 line1).length
  
testCompose1 =
  testcase "testCompose1" <|
  assertEquals (line0.locationAt 0) (path0.locationAt 0)
  
testCompose2 =
  testcase "testCompose2" <|
  assertEquals (line0.locationAt (sqrt 2)) (path0.locationAt (sqrt 2))
  
testCompose3 =
  testcase "testCompose3" <|
  assertEquals (line1.locationAt 0) (path0.locationAt (sqrt 2))
  
testCompose4 =
  testcase "testCompose4" <|
  assertWithTolerance 2 (path0.locationAt (1 + sqrt 2)).top