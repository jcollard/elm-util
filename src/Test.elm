module Test(Test,
            success,
            fail,
            test,
            assert,
            assertEquals,
            assertWithTolerance,
            report,
            fails) where

data Result = Success | Fail String

type Test = 
    {
      desc : String
    , result : Result
    }
    
success = Success    
fail msg = Fail msg
    
test desc result = { desc = desc, result = result }

assert bool msg = 
  if bool then Success else Fail msg

assertEquals expected actual = 
  assert (expected == actual) ("Expected " ++ (show expected) ++ " but received " ++ (show actual))

assertWithTolerance epsilon expected actual = 
  assert (abs(expected - actual) < epsilon) ("Expected " ++ (show expected) ++ " but received " ++ (show actual))

    
fails : [Test] -> [Test]
fails tests =
    case tests of
      [] -> []      
      (t::ts) ->
        case t.result of
          Success -> fails ts
          Fail _ -> t :: fails ts

pretty : Test -> Element
pretty t =
  case t.result of
    Success -> plainText <| t.desc ++ ": " ++ "Success"
    Fail error -> plainText <| t.desc ++ ": Failed with message \"" ++ error ++ "\""
    
report : [Test] -> Element
report tests = 
  let n = length tests
      failures = fails tests
      m = length failures
      report = map pretty failures
  in flow down <| plainText ("Tested " ++ show n ++ ". Failed: " ++ show m)::report
