module ScreeptTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Parser
import Screept exposing (..)
import Test exposing (..)


intValParsingAndStringify : Test
intValParsingAndStringify =
    describe "Parsing IntVal"
        [ fuzz int "should parse each int to Const" <|
            \x ->
                Expect.equal (Parser.run intValueParser (String.fromInt x)) (Ok (Const x))
        , test "should parse counter to Counter" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "$test_counter") (Ok (Counter "test_counter"))
        , test "Should parse unary" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "!$test_counter") (Ok (Unary Not (Counter "test_counter")))
        , test "Should parse binary" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "($test_counter > 1)") (Ok <| Binary (Counter "test_counter") Gt (Const 1))
        , test "should parse CALL" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "CALL test_function") (Ok <| Eval "test_function")
        , test "stringify a value" <|
            \_ ->
                Expect.equal (intValueStringify (Const 5)) "5"
        , test "stringify a counter" <|
            \_ ->
                Expect.equal (intValueStringify (Counter "test_counter")) "$test_counter"
        , test "stringify a unary op" <|
            \_ ->
                Expect.equal (intValueStringify (Unary Not <| Const 1)) "!1"
        , test "stringify a binary op" <|
            \_ ->
                Expect.equal (intValueStringify (Binary (Counter "test_counter") Eq (Const 1))) "($test_counter == 1)"
        , test "stringify a call" <|
            \_ ->
                Expect.equal (intValueStringify (Eval "test")) "CALL test"
        , fuzz (fuzzIntVal 10) "round stringify and parse" <|
            \v ->
             --let
                 --_  = Debug.log "FUZZ" v

             --in

                Expect.equal (intValueStringify v |> Parser.run intValueParser) (Ok v)
        ]


fuzzConst : Fuzzer IntValue
fuzzConst =
    Fuzz.map Const int


fuzzCounter : Fuzzer IntValue
fuzzCounter =
    Fuzz.constant (Counter "test_value")


fuzzIntVal : Int -> Fuzzer IntValue
fuzzIntVal x =
    if x < 0 then
        Fuzz.oneOf [ fuzzConst, fuzzCounter ]

    else
        Fuzz.oneOf
            [ fuzzConst
            , fuzzCounter
            , Fuzz.map2 Unary fuzzUnaryOp (fuzzIntVal (x - 1))
            , Fuzz.map3 Binary (fuzzIntVal (x - 1)) fuzzBinaryOp (fuzzIntVal (x - 1))
            ]


fuzzUnaryOp : Fuzzer UnaryOp
fuzzUnaryOp =
    Fuzz.oneOf
        [ Fuzz.constant Not
        ]


fuzzBinaryOp : Fuzzer BinaryOp
fuzzBinaryOp =
    Fuzz.oneOf <|
        List.map (Fuzz.constant) [Add, Sub, Mul, Div, Mod, Gt, Lt,Eq,And,Or]
