module ScreeptV2Test exposing (..)

import Char
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode as Json
import Json.Encode as E
import Parser
import ScreeptV2 exposing (..)
import Test exposing (..)


testExpression : Test
testExpression =
    describe "Round trip Expression stringify and parse"
        [ fuzz fuzzExpression "round trip" <|
            \v -> Expect.equal (stringifyExpression v |> Parser.run parserExpression) (Ok v)
        ]


testStatement : Test
testStatement =
    describe "Round trip Statement stringify and parse"
        [ fuzz fuzzStatement "round trip" <|
            \v -> Expect.equal (stringifyStatement v |> Parser.run parserStatement) (Ok v)
        ]


testValueCoded : Test
testValueCoded =
    describe "Round trip Value encode and decode"
        [ fuzz fuzzValue "round trip codec" <|
            \v -> Expect.equal (E.encode 0 (encodeValue v) |> Json.decodeString decodeValue) (Ok v)
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
        [ ( 10, Fuzz.map Number <| Fuzz.floatRange -1000 1000 )
        , ( 3, Fuzz.map Text (Fuzz.string |> Fuzz.map (\s -> String.filter (\c -> c /= '"') s)) )
        , ( 1, Fuzz.map Func (Fuzz.lazy (\_ -> fuzzExpression)) )
        ]


fuzzIdentifier : Fuzzer Identifier
fuzzIdentifier =
    Fuzz.oneOf
        [ Fuzz.map LiteralIdentifier
            (Fuzz.oneOf
                [ Fuzz.constant '_'
                , Fuzz.intRange 97 122
                    |> Fuzz.map Char.fromCode
                    |> Fuzz.map
                        (\c ->
                            if c == 'e' then
                                'f'

                            else
                                c
                        )
                ]
                |> Fuzz.andThen (\first -> Fuzz.map (\s -> String.fromChar first ++ s) fuzzAlphaNumString)
            )
        , Fuzz.map ComputedIdentifier (Fuzz.lazy (\_ -> fuzzExpression))
        ]


fuzzAlphaNumString : Fuzzer String
fuzzAlphaNumString =
    Fuzz.asciiString
        |> Fuzz.map
            (\s ->
                String.filter (\c -> c /= 'e' && Char.isAlphaNum c) s
                    |> (\st ->
                            if List.member st ScreeptV2.reservedWords then
                                "_reserved"

                            else
                                st
                       )
            )


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


fuzzStatement : Fuzzer Statement
fuzzStatement =
    Fuzz.frequency
        [ ( 3, Fuzz.map2 Bind fuzzIdentifier fuzzExpression )
        , ( 1, Fuzz.map Block <| Fuzz.listOfLengthBetween 0 5 (Fuzz.lazy (\_ -> fuzzStatement)) )
        , ( 1, Fuzz.map3 If fuzzExpression (Fuzz.lazy (\_ -> fuzzStatement)) (Fuzz.lazy (\_ -> fuzzStatement)) )
        , ( 2, Fuzz.map Print fuzzExpression )
        ]
