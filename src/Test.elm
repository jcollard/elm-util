module Test(TestCase,
            testCase,
            Test,
            test,
            TestSuite,
            testSuite,
            success,
            fail,
            assert,
            assertEquals,
            assertWithTolerance,
            Report,
            report,
            pretty) where

import Text

data Result = Success | Fail String

suiteHeader = text . bold . underline . Text.height 16 . toText
testHeader = text . bold . Text.height 14 . toText
caseFont = text . Text.height 14 . toText

type Report =
  {
    testcases : Int
  , failures  : Int
  , report    : Element
  }

report testcases failures r = { testcases = testcases, failures = failures, report = r }

success = Success    
fail msg = Fail msg

assert bool msg = 
  if bool then Success else Fail msg

assertEquals expected actual = 
  assert (expected == actual) ("Expected " ++ (show expected) ++ " but received " ++ (show actual))

assertWithTolerance epsilon expected actual = 
  assert (abs(expected - actual) < epsilon) ("Expected " ++ (show expected) ++ " but received " ++ (show actual))

type TestCase = 
    {
      desc   : String
    , result : Result
    }
    
testCase desc result = { desc = desc, result = result }

fails : [TestCase] -> [TestCase]
fails tests =
    case tests of
      [] -> []      
      (t::ts) ->
        case t.result of
          Success -> fails ts
          Fail _ -> t :: fails ts

prettyCase : TestCase -> Element
prettyCase t =
  case t.result of
    Success -> caseFont <| t.desc ++ ": " ++ "Success"
    Fail error -> caseFont <| t.desc ++ ": Failed with message \"" ++ error ++ "\""

type Test =
  {
    title : String
  , cases : [TestCase]
  }
  
test title cases = { title = title, cases = cases }
    
reportTest : Test -> Report
reportTest test = 
  let testcases = length test.cases
      failed = fails test.cases
      failures = length failed
      prettyCases = map prettyCase failed
      rep = flow down prettyCases
  in report testcases failures rep

prettyTest : Test -> Element
prettyTest t =
  let report = reportTest t
      title = testHeader t.title
      summary = caseFont <| "Test Cases: " ++ show report.testcases ++ " Failures: " ++ show report.failures
      rep = flow right [spacer 20 20, flow down [title, report.report, summary, spacer 20 20]]
  in rep
  

type TestSuite =
  {
    name  : String
  , tests : [Test]
  }

testSuite : String -> [Test] -> TestSuite
testSuite name tests = { name = name, tests = tests }  

prettySuite : TestSuite -> Element
prettySuite s =
  let reports = map reportTest s.tests
      pretty = map prettyTest s.tests
      title = suiteHeader s.name
      testcases = foldr (\r sum -> r.testcases + sum) 0 reports
      failures = foldr (\r sum -> r.failures + sum) 0 reports
      rep = flow down <| [title, spacer 20 20] ++ pretty
      summary = caseFont <| "Total Test Cases: " ++ show testcases ++ " Failures: " ++ show failures
  in flow down [rep, summary]
    
pretty : TestSuite -> Element
pretty = prettySuite     
     

