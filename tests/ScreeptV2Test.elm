module ScreeptV2Test exposing (..)

import Char
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Parser
import ScreeptV2 exposing (..)
import Test exposing (..)


expressions : Test
expressions =
    Test.only <|
        describe "Round trip expressions stringify and parse"
            [ fuzz fuzzExpression "round trip" <|
                \v -> Expect.equal (stringifyExpression v |> Parser.run parserExpression) (Ok v)
            ]


fuzzExpression : Fuzzer Expression
fuzzExpression =
    Fuzz.frequency
        [ ( 10, Fuzz.map Variable fuzzIdentifier )
        , ( 20, Fuzz.map Literal fuzzValue )
        , ( 1, Fuzz.map2 UnaryExpression fuzzUnaryOp (Fuzz.lazy (\_ -> fuzzExpression)) )
        , ( 1, Fuzz.map3 BinaryExpression (Fuzz.lazy (\_ -> fuzzExpression)) fuzzBinaryOp (Fuzz.lazy (\_ -> fuzzExpression)) )
        , ( 4, Fuzz.map2 FunctionCall fuzzIdentifier (Fuzz.listOfLengthBetween 0 5 (Fuzz.lazy (\_ -> fuzzExpression))) )
        ]


fuzzValue : Fuzzer Value
fuzzValue =
    Fuzz.frequency
        [ ( 10, Fuzz.map Number Fuzz.float )
        , ( 3, Fuzz.map Text Fuzz.string )
        , ( 1, Fuzz.map Func (Fuzz.lazy (\_ -> fuzzExpression)) )
        ]


fuzzIdentifier : Fuzzer Identifier
fuzzIdentifier =
    Fuzz.oneOf
        [ Fuzz.constant '_'
        , Fuzz.intRange 97 122 |> Fuzz.map Char.fromCode
            |> Fuzz.map
                (\c ->
                    if c == 'e' then
                        'f'

                    else
                        c
                )
        ]
        |> Fuzz.andThen (\first -> Fuzz.map (\s -> String.fromChar first ++ s) fuzzAlphaNumString)


fuzzAlphaNumString : Fuzzer String
fuzzAlphaNumString =
    Fuzz.asciiString |> Fuzz.map (\s -> String.filter (\c -> c /= 'e' && Char.isAlphaNum c) s)


fuzzUnaryOp : Fuzzer UnaryOp
fuzzUnaryOp =
    Fuzz.oneOf
        [ Fuzz.constant Not
        , Fuzz.constant Negate
        ]


fuzzBinaryOp : Fuzzer BinaryOp
fuzzBinaryOp =
    Fuzz.oneOf
        [ Fuzz.constant Add
        , Fuzz.constant Sub
        ]
