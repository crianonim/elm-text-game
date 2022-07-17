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
                Expect.equal (Parser.run intValueParser "test_counter") (Ok (IntVariable (VLit "test_counter")))
        , test "Should parse unary" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "!test_counter") (Ok (Unary Not (IntVariable (VLit "test_counter"))))
        , test "Should parse binary" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "(test_counter > 1)") (Ok <| Binary (IntVariable (VLit "test_counter")) Gt (Const 1))
        , test "should parse CALL" <|
            \_ ->
                Expect.equal (Parser.run intValueParser "CALL test_function") (Ok <| Eval (VLit "test_function"))
        , test "stringify a value" <|
            \_ ->
                Expect.equal (intValueStringify (Const 5)) "5"
        , test "stringify a counter" <|
            \_ ->
                Expect.equal (intValueStringify (IntVariable (VLit "test_counter"))) "test_counter"
        , test "stringify a unary op" <|
            \_ ->
                Expect.equal (intValueStringify (Unary Not <| Const 1)) "!1"
        , test "stringify a binary op" <|
            \_ ->
                Expect.equal (intValueStringify (Binary (IntVariable (VLit "test_counter")) Eq (Const 1))) "(test_counter == 1)"
        , test "stringify a call" <|
            \_ ->
                Expect.equal (intValueStringify (Eval (VLit "test"))) "CALL test"
        , fuzz (Fuzz.intRange 1 10 |> Fuzz.andThen fuzzIntVal) "round stringify and parse" <|
            \v ->
                Expect.equal (intValueStringify v |> Parser.run intValueParser) (Ok v)
        ]


textValueParseAndStringify : Test
textValueParseAndStringify =
    describe "TextValue parsing and stringify"
        [ fuzz (Fuzz.intRange 1 10 |> Fuzz.andThen fuzzTextValue) "Round trip" <|
            \v ->
                Expect.equal (Screept.textValueStringify v |> Parser.run textValueParser) (Ok v)
        ]


statementParseAndStringify : Test
statementParseAndStringify =
    describe "Statement parsing and stringify"
        [ fuzz (Fuzz.intRange 0 1 |> Fuzz.andThen fuzzStatement) "Round trip stringify and parse" <|
            \v ->
                Expect.equal (Screept.statementStringify v |> Parser.run statementParser) (Ok v)
        ]


fuzzStatement : Int -> Fuzzer Statement
fuzzStatement x =
    if x < 0 then
        Fuzz.oneOf
            [ Fuzz.map2 SetVariable fuzzVariableName (fuzzSetVariable -1)
            , Fuzz.map3 Rnd fuzzVariableName (fuzzIntVal 1) (fuzzIntVal 1)
            , Fuzz.map Procedure fuzzValidProcName
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
            , Fuzz.map TextVariable fuzzVariableName
            ]


fuzzValidTextString : Fuzzer String
fuzzValidTextString =
    Fuzz.map (String.filter (\c -> c /= '"')) string


fuzzConst : Fuzzer IntValue
fuzzConst =
    Fuzz.map Const int


fuzzSetVariable : Int -> Fuzzer VariableSetValue
fuzzSetVariable n =
    Fuzz.oneOf
        [ fuzzIntSetVariable n
        , fuzzTextSetVariable n
        , fuzzFuncSetVariable n
        ]


fuzzValidProcName : Fuzzer String
fuzzValidProcName =
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


fuzzIntSetVariable : Int -> Fuzzer VariableSetValue
fuzzIntSetVariable n =
    fuzzIntVal n |> Fuzz.map SVInt


fuzzTextSetVariable : Int -> Fuzzer VariableSetValue
fuzzTextSetVariable n =
    fuzzTextValue n |> Fuzz.map SVText


fuzzFuncSetVariable : Int -> Fuzzer VariableSetValue
fuzzFuncSetVariable n =
    fuzzIntVal n |> Fuzz.map SVFunc


fuzzVariableName : Fuzzer VariableName
fuzzVariableName =
    Fuzz.constant (VLit "test_value")


fuzzIntVal : Int -> Fuzzer IntValue
fuzzIntVal x =
    if x < 0 then
        Fuzz.oneOf [ fuzzConst, fuzzVariableName |> Fuzz.map IntVariable ]

    else
        Fuzz.oneOf
            [ fuzzConst
            , fuzzVariableName |> Fuzz.map IntVariable
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
