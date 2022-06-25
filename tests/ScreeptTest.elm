module ScreeptTest exposing (..)

import Char as Chat
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Parser
import Screept exposing (..)
import Test exposing (..)


intValParseAndStringify : Test
intValParseAndStringify =
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
                Expect.equal (intValueStringify v |> Parser.run intValueParser) (Ok v)
        ]


textValueParseAndStringify : Test
textValueParseAndStringify =
    describe "TextValue parsing and stringify"
        [ fuzz (fuzzTextValue 10) "Round trip" <|
            \v ->
                Expect.equal (Screept.textValueStringify v |> Parser.run textValueParser) (Ok v)
        ]


statementParseAndStringify : Test
statementParseAndStringify =
    describe "Statement parsing and stringify"
        [ fuzz (fuzzStatement 0) "Round trip stringify and parse" <|
            \v ->
                Expect.equal (Screept.statementStringify v |> Parser.run statementParser) (Ok v)
        ]


fuzzStatement : Int -> Fuzzer Statement
fuzzStatement x =
    if x < 0 then
        Fuzz.oneOf
            [ Fuzz.map2 SetCounter (fuzzValidLabel |> Fuzz.map S) (fuzzIntVal -1)
            , Fuzz.map2 SetCounter (fuzzValidLabel |> Fuzz.map S) (fuzzIntVal 1)
            , Fuzz.map2 SetLabel (fuzzValidLabel |> Fuzz.map S) (fuzzTextValue 1)
            , Fuzz.map2 SetFunc (fuzzValidLabel |> Fuzz.map S) (fuzzIntVal 1)
            , Fuzz.map3 Rnd (fuzzValidLabel |> Fuzz.map S) (fuzzIntVal 1) (fuzzIntVal 1)
            , Fuzz.map Procedure fuzzValidLabel
            , Fuzz.map Comment fuzzValidComment
            ]

    else
        Fuzz.oneOf
            [ Fuzz.map Block <| Fuzz.list (fuzzStatement (x - 1))
            , Fuzz.map3 If (fuzzIntVal 1) (fuzzStatement (x - 1)) (fuzzStatement (x - 1))
            ]


fuzzValidComment : Fuzzer String
fuzzValidComment =
    string |> Fuzz.map (String.filter ((/=) '\n'))


fuzzTextValue : Int -> Fuzzer TextValue
fuzzTextValue x =
    if x < 0 then
        fuzzValidTextString |> Fuzz.map S

    else
        Fuzz.oneOf
            [ Fuzz.map S fuzzValidTextString
            , Fuzz.list (fuzzTextValue -1) |> Fuzz.map Concat
            , Fuzz.map3 Conditional (fuzzIntVal 2) (fuzzTextValue (x - 1)) (fuzzTextValue (x - 1))
            , Fuzz.map IntValueText (fuzzIntVal 2)
            , Fuzz.map Label fuzzValidLabel
            ]


fuzzValidTextString : Fuzzer String
fuzzValidTextString =
    Fuzz.map (String.filter (\c -> c /= '"')) string


fuzzValidLabel : Fuzzer String
fuzzValidLabel =
    Fuzz.map
        (\s ->
            String.filter Chat.isAlphaNum s
                |> (\x ->
                        if String.length x < 1 then
                            "_" ++ x

                        else
                            x
                   )
        )
        string


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
        List.map Fuzz.constant [ Add, Sub, Mul, Div, Mod, Gt, Lt, Eq, And, Or ]
