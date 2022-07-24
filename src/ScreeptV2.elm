module ScreeptV2 exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json
import Json.Encode as E
import Parser exposing ((|.), (|=), Parser)
import Random
import Result.Extra
import Set


type UnaryOp
    = Not
    | Negate


type BinaryOp
    = Add
    | Sub
    | Mul
    | Div
    | Mod
    | Gt
    | Lt
    | Eq
    | And
    | Or


type TertiaryOp
    = Conditional


type Expression
    = Literal Value
    | Variable Identifier
    | UnaryExpression UnaryOp Expression
    | BinaryExpression Expression BinaryOp Expression
    | TertiaryExpression Expression TertiaryOp Expression Expression
    | FunctionCall Identifier (List Expression)
    | StandardLibrary String (List Expression)


type Statement
    = Bind Identifier Expression
    | Block (List Statement)
    | If Expression Statement Statement
    | Print Expression
    | RunProc String
    | Rnd Identifier Expression Expression


type Identifier
    = LiteralIdentifier String
    | ComputedIdentifier Expression


type alias State =
    { procedures : Dict String Statement
    , vars : Dict String Value
    , rnd : Random.Seed
    }


type ScreeptError
    = TypeError
    | Undefined
    | UnimplementedYet



--| FunctionCall


type Value
    = Number Float
    | Text String
    | Func Expression



--| Function


reservedWords : List String
reservedWords =
    []



--[  "if", "then", "else", "rnd" ] ++ Dict.keys standardLibrary


standardLibrary : Dict String (List Value -> Result ScreeptError Value)
standardLibrary =
    Dict.fromList
        [ ( "CONCAT", \args -> List.map getStringFromValue args |> String.join "" |> Text |> Ok )
        ]


parserIdentifier : Parser Identifier
parserIdentifier =
    Parser.oneOf
        [ Parser.map LiteralIdentifier <|
            Parser.variable
                { start = \c -> Char.isAlphaNum c && Char.isLower c || c == '_' && c /= 'e'
                , inner = \c -> Char.isAlphaNum c || c == '_'
                , reserved = Set.fromList reservedWords
                }
        , Parser.succeed ComputedIdentifier
            |. Parser.symbol "${"
            |= Parser.lazy (\_ -> parserExpression)
            |. Parser.symbol "}"
        ]


parserValue : Parser Value
parserValue =
    Parser.oneOf
        [ Parser.oneOf
            [ Parser.succeed negate
                |. Parser.symbol "-"
                |= Parser.float
            , Parser.float
            ]
            |> Parser.map Number
        , Parser.succeed Text
            |. Parser.symbol "\""
            |= (Parser.chompWhile (\c -> c /= '"') |> Parser.getChompedString)
            |. Parser.symbol "\""
        , Parser.succeed Func
            |. Parser.keyword "FUNC"
            |. Parser.spaces
            |= Parser.lazy (\_ -> parserExpression)
        ]


parserExpression : Parser Expression
parserExpression =
    Parser.oneOf
        [ Parser.succeed UnaryExpression
            |= Parser.oneOf
                [ Parser.succeed Not
                    |. Parser.symbol "!"
                , Parser.succeed Negate
                    |. Parser.symbol "- "
                ]
            |= Parser.lazy (\_ -> parserExpression)
        , Parser.backtrackable <|
            Parser.succeed TertiaryExpression
                |. Parser.symbol "("
                |= Parser.lazy (\_ -> parserExpression)
                |. Parser.spaces
                |= Parser.oneOf
                    [ Parser.succeed Conditional
                        |. Parser.symbol "?"
                    ]
                |. Parser.spaces
                |= Parser.lazy (\_ -> parserExpression)
                |. Parser.spaces
                |. Parser.oneOf
                    [ Parser.symbol ":"
                    ]
                |. Parser.spaces
                |= Parser.lazy (\_ -> parserExpression)
                |. Parser.spaces
                |. Parser.symbol ")"
        , Parser.succeed BinaryExpression
            |. Parser.symbol "("
            |= Parser.lazy (\_ -> parserExpression)
            |. Parser.spaces
            |= parserBinaryOp
            |. Parser.spaces
            |= Parser.lazy (\_ -> parserExpression)
            |. Parser.symbol ")"
        , Parser.map Literal parserValue
        , parserIdentifier
            |> Parser.andThen
                (\v ->
                    Parser.oneOf
                        [ Parser.succeed (FunctionCall v)
                            |= parserArguments
                        , Parser.succeed <| Variable v
                        ]
                )
        , Parser.succeed StandardLibrary
            |= parserStandardLibrary
            |= parserArguments
        ]


parserBinaryOp : Parser BinaryOp
parserBinaryOp =
    Parser.oneOf
        [ Parser.succeed Add
            |. Parser.symbol "+"
        , Parser.succeed Sub
            |. Parser.symbol "-"
        , Parser.succeed Mul
            |. Parser.symbol "*"
        , Parser.succeed Div
            |. Parser.symbol "/"
        , Parser.succeed Mod
            |. Parser.symbol "%%"
        , Parser.succeed Gt
            |. Parser.symbol ">"
        , Parser.succeed Lt
            |. Parser.symbol "<"
        , Parser.succeed Eq
            |. Parser.symbol "=="
        , Parser.succeed And
            |. Parser.symbol "&&"
        , Parser.succeed Or
            |. Parser.symbol "||"
        ]


parserArguments : Parser (List Expression)
parserArguments =
    Parser.sequence
        { start = "("
        , end = ")"
        , item = Parser.lazy (\_ -> parserExpression)
        , spaces = Parser.spaces
        , separator = ","
        , trailing = Parser.Forbidden
        }


parserStandardFunction : String -> Parser String
parserStandardFunction string =
    Parser.keyword string |> Parser.andThen (\_ -> Parser.succeed string)


parserStandardLibrary : Parser String
parserStandardLibrary =
    Dict.keys standardLibrary
        |> List.map parserStandardFunction
        |> Parser.oneOf


parserStatement : Parser Statement
parserStatement =
    Parser.oneOf
        [ Parser.succeed Bind
            |= parserIdentifier
            |. Parser.spaces
            |. Parser.symbol "="
            |. Parser.spaces
            |= parserExpression
        , Parser.map Block
            (Parser.sequence
                { start = "{"
                , separator = ";"
                , end = "}"
                , item = Parser.lazy (\_ -> parserStatement)
                , spaces = Parser.spaces
                , trailing = Parser.Optional
                }
            )
        , Parser.succeed Print
            |. Parser.keyword "PRINT"
            |. Parser.spaces
            |= parserExpression
        , Parser.succeed If
            |. Parser.keyword "IF"
            |. Parser.spaces
            |= parserExpression
            |. Parser.spaces
            |. Parser.keyword "THEN"
            |. Parser.spaces
            |= Parser.lazy (\_ -> parserStatement)
            |. Parser.spaces
            |. Parser.keyword "ELSE"
            |. Parser.spaces
            |= Parser.lazy (\_ -> parserStatement)
        , Parser.succeed RunProc
            |. Parser.keyword "RUN"
            |. Parser.spaces
            |= Parser.variable
                { start = \c -> Char.isAlphaNum c && Char.isLower c || c == '_' && c /= 'e'
                , inner = \c -> Char.isAlphaNum c || c == '_'
                , reserved = Set.fromList reservedWords
                }
        , Parser.succeed Rnd
            |. Parser.keyword "RND"
            |. Parser.spaces
            |= parserIdentifier
            |. Parser.spaces
            |= parserExpression
            |. Parser.spaces
            |= parserExpression
        ]


stringifyIdentifier : Identifier -> String
stringifyIdentifier identifier =
    case identifier of
        LiteralIdentifier string ->
            string

        ComputedIdentifier expression ->
            "${" ++ stringifyExpression expression ++ "}"


stringifyValue : Value -> String
stringifyValue value =
    case value of
        Number float ->
            String.fromFloat float

        Text string ->
            "\"" ++ string ++ "\""

        Func expression ->
            "FUNC " ++ stringifyExpression expression


stringifyExpression : Expression -> String
stringifyExpression expression =
    case expression of
        Literal value ->
            stringifyValue value

        Variable identifier ->
            stringifyIdentifier identifier

        UnaryExpression unaryOp expr ->
            stringifyUnaryOperator unaryOp ++ stringifyExpression expr

        BinaryExpression expr1 binaryOp expr2 ->
            "("
                ++ stringifyExpression expr1
                ++ stringifyBinaryOperator binaryOp
                ++ stringifyExpression expr2
                ++ ")"

        TertiaryExpression expr1 tertiaryOp expr2 expr3 ->
            "("
                ++ stringifyExpression expr1
                ++ (case tertiaryOp of
                        Conditional ->
                            "?"
                   )
                ++ stringifyExpression expr2
                ++ (case tertiaryOp of
                        Conditional ->
                            ":"
                   )
                ++ stringifyExpression expr3
                ++ ")"

        FunctionCall identifier expressions ->
            stringifyIdentifier identifier ++ "(" ++ String.join "," (List.map stringifyExpression expressions) ++ ")"

        StandardLibrary string expressions ->
            string ++ "(" ++ String.join "," (List.map stringifyExpression expressions) ++ ")"


stringifyUnaryOperator : UnaryOp -> String
stringifyUnaryOperator unaryOp =
    case unaryOp of
        Not ->
            "!"

        Negate ->
            "- "


stringifyBinaryOperator : BinaryOp -> String
stringifyBinaryOperator binaryOp =
    case binaryOp of
        Add ->
            "+"

        Sub ->
            "-"

        Mul ->
            "*"

        Div ->
            "/"

        Mod ->
            "%%"

        Gt ->
            ">"

        Lt ->
            "<"

        Eq ->
            "=="

        And ->
            "&&"

        Or ->
            "||"


stringifyStatement : Statement -> String
stringifyStatement statement =
    case statement of
        Bind identifier expression ->
            stringifyIdentifier identifier ++ " = " ++ stringifyExpression expression

        Block statements ->
            "{"
                ++ (List.map stringifyStatement statements |> String.join " ; ")
                ++ "}"

        If expression success failure ->
            "IF "
                ++ stringifyExpression expression
                ++ " THEN "
                ++ stringifyStatement success
                ++ " ELSE "
                ++ stringifyStatement failure

        Print expression ->
            "PRINT " ++ stringifyExpression expression

        RunProc string ->
            "RUN " ++ string

        Rnd identifier from to ->
            "RND " ++ stringifyIdentifier identifier ++ " " ++ stringifyExpression from ++ " " ++ stringifyExpression to


encodeValue : Value -> E.Value
encodeValue value =
    case value of
        Number float ->
            E.float float

        Text string ->
            E.string string

        Func expression ->
            E.object [ ( "func", E.string <| stringifyExpression expression ) ]


decodeValue : Json.Decoder Value
decodeValue =
    let
        stringToValueParser : String -> Json.Decoder Value
        stringToValueParser s =
            case Parser.run parserExpression s of
                Ok expr ->
                    Json.succeed (Func expr)

                Err e ->
                    Json.fail ("error decoding Func '" ++ s ++ "'.")
    in
    Json.oneOf
        [ Json.map Number Json.float
        , Json.map Text Json.string
        , Json.field "func" Json.string |> Json.andThen stringToValueParser
        ]


parserToDecoder : Parser value -> Json.Decoder value
parserToDecoder parser =
    let
        parseResultToDecoder : Result error value -> Json.Decoder value
        parseResultToDecoder v =
            case v of
                Err _ ->
                    Json.fail "fail to decode expression"

                Ok expr ->
                    Json.succeed expr
    in
    Json.string |> Json.andThen (Parser.run parser >> parseResultToDecoder)


decodeExpression : Json.Decoder Expression
decodeExpression =
    parserToDecoder (parserExpression |. Parser.end)


decodeStatement : Json.Decoder Statement
decodeStatement =
    parserToDecoder (parserStatement |. Parser.end)


evaluateExpression : State -> Expression -> Result ScreeptError Value
evaluateExpression state expression =
    case expression of
        Literal valueType ->
            Ok valueType

        Variable var ->
            resolveIdentifierToString state var
                |> Result.andThen (resolveVariable state)

        UnaryExpression unaryOp e ->
            evaluateUnaryExpression state unaryOp e

        BinaryExpression e1 binaryOp e2 ->
            evaluateBinaryExpression state e1 binaryOp e2

        TertiaryExpression e1 tertiaryOp e2 e3 ->
            evaluateTertiaryExpression state tertiaryOp e1 e2 e3

        FunctionCall identifier expressions ->
            resolveIdentifierToString state identifier
                |> Result.andThen (resolveVariable state)
                |> Result.andThen
                    (\var ->
                        case var of
                            Func expr ->
                                let
                                    runTimeState : Result ScreeptError ( State, List String )
                                    runTimeState =
                                        let
                                            varName i =
                                                LiteralIdentifier <| "__" ++ String.fromInt (i + 1)

                                            bindings : Statement
                                            bindings =
                                                Block (List.map (\( i, e ) -> Bind (varName i) e) (List.indexedMap Tuple.pair expressions))
                                        in
                                        executeStatement bindings ( state, [] )
                                in
                                runTimeState
                                    |> Result.andThen
                                        (\( boundState, _ ) -> evaluateExpression boundState expr)

                            _ ->
                                Err TypeError
                    )

        StandardLibrary func expressions ->
            expressions
                |> List.map (evaluateExpression state)
                |> Result.Extra.combine
                |> Result.andThen
                    (\args ->
                        Dict.get func standardLibrary
                            |> Maybe.map (\f -> f args)
                            |> Maybe.withDefault (Err Undefined)
                    )


evaluateUnaryExpression : State -> UnaryOp -> Expression -> Result ScreeptError Value
evaluateUnaryExpression state unaryOp expression =
    let
        expr =
            evaluateExpression state expression
    in
    case unaryOp of
        Not ->
            Result.map
                (\value ->
                    case value of
                        Number n ->
                            Number <|
                                if n == 0 then
                                    1

                                else
                                    0

                        Text t ->
                            Number <|
                                if String.length t > 0 then
                                    1

                                else
                                    0

                        Func _ ->
                            Number <| 0
                )
                expr

        Negate ->
            Result.andThen
                (\v ->
                    case v of
                        Number n ->
                            Ok <| Number -n

                        _ ->
                            Err TypeError
                )
                expr


resolveIdentifierToString : State -> Identifier -> Result ScreeptError String
resolveIdentifierToString state identifier =
    case identifier of
        LiteralIdentifier string ->
            Ok string

        ComputedIdentifier expression ->
            evaluateExpression state expression
                |> Result.map getStringFromValue


evaluateTertiaryExpression : State -> TertiaryOp -> Expression -> Expression -> Expression -> Result ScreeptError Value
evaluateTertiaryExpression state tertiaryOp e1 e2 e3 =
    Result.map3
        (\cond succ fail ->
            if isTruthy cond then
                succ

            else
                fail
        )
        (evaluateExpression state e1)
        (evaluateExpression state e2)
        (evaluateExpression state e3)


evaluateBinaryExpression : State -> Expression -> BinaryOp -> Expression -> Result ScreeptError Value
evaluateBinaryExpression state e1 binaryOp e2 =
    let
        floatOperation : (Float -> Float -> Float) -> Value -> Value -> Result ScreeptError Value
        floatOperation fn expression1 expression2 =
            case ( expression1, expression2 ) of
                ( Number n1, Number n2 ) ->
                    Ok <| Number <| fn n1 n2

                _ ->
                    Err TypeError
    in
    evaluateExpression state e1
        |> Result.andThen
            (\expr1 ->
                evaluateExpression state e2
                    |> Result.andThen
                        (\expr2 ->
                            case binaryOp of
                                Add ->
                                    case ( expr1, expr2 ) of
                                        ( Number n1, Number n2 ) ->
                                            Ok <| Number <| n1 + n2

                                        ( Text t1, Text t2 ) ->
                                            Ok <| Text <| t1 ++ t2

                                        ( v1, v2 ) ->
                                            Ok <| Text <| getStringFromValue v1 ++ getStringFromValue v2

                                Sub ->
                                    floatOperation (-) expr1 expr2

                                Mul ->
                                    floatOperation (*) expr1 expr2

                                Div ->
                                    floatOperation (/) expr1 expr2

                                Mod ->
                                    floatOperation (\x y -> modBy (round y) (round x) |> toFloat) expr1 expr2

                                Gt ->
                                    floatOperation
                                        (\x y ->
                                            if x > y then
                                                1

                                            else
                                                0
                                        )
                                        expr1
                                        expr2

                                Lt ->
                                    floatOperation
                                        (\x y ->
                                            if x < y then
                                                1

                                            else
                                                0
                                        )
                                        expr1
                                        expr2

                                Eq ->
                                    Ok <|
                                        Number
                                            (if expr1 == expr2 then
                                                1

                                             else
                                                0
                                            )

                                And ->
                                    floatOperation
                                        (\x y ->
                                            if x * y == 0 then
                                                0

                                            else
                                                1
                                        )
                                        expr1
                                        expr2

                                Or ->
                                    floatOperation
                                        (\x y ->
                                            if x + y == 0 then
                                                0

                                            else
                                                1
                                        )
                                        expr1
                                        expr2
                        )
            )


resolveVariable : State -> String -> Result ScreeptError Value
resolveVariable state var =
    Dict.get var state.vars
        |> Maybe.map Ok
        |> Maybe.withDefault (Err Undefined)


executeStatement : Statement -> ( State, List String ) -> Result ScreeptError ( State, List String )
executeStatement statement ( state, output ) =
    case statement of
        Bind ident expression ->
            Result.map2 (\v id -> ( setVariable id v state, output )) (evaluateExpression state expression) (resolveIdentifierToString state ident)

        Block statements ->
            List.foldl (\s acc -> Result.andThen (executeStatement s) acc) (Ok ( state, output )) statements

        Print expression ->
            evaluateExpression state expression
                |> Result.map
                    (\v ->
                        let
                            o =
                                case v of
                                    Text t ->
                                        t

                                    Number float ->
                                        String.fromFloat float

                                    Func _ ->
                                        "<FUNC>"
                        in
                        ( state, output ++ [ o ] )
                    )

        If expression success failure ->
            evaluateExpression state expression
                |> Result.andThen
                    (\v ->
                        executeStatement
                            (if isTruthy v then
                                success

                             else
                                failure
                            )
                            ( state, output )
                    )

        RunProc procName ->
            Dict.get procName state.procedures
                |> Maybe.map
                    (\proc ->
                        let
                            _ =
                                Debug.log "EXECUTING " proc
                        in
                        executeStatement proc ( state, output )
                    )
                |> Maybe.withDefault (Err Undefined)

        Rnd identifier from to ->
            resolveIdentifierToString state identifier
                |> Result.andThen
                    (\id ->
                        evaluateExpression state from
                            |> Result.andThen
                                (\f ->
                                    evaluateExpression state to
                                        |> Result.andThen
                                            (\t ->
                                                case ( f, t ) of
                                                    ( Number x, Number y ) ->
                                                        let
                                                            ( result, newSeed ) =
                                                                Random.step (Random.int (round x) (round y)) state.rnd

                                                            newState =
                                                                { state | rnd = newSeed }
                                                        in
                                                        Ok ( setVariable id (Number <| toFloat result) newState, output )

                                                    _ ->
                                                        Err TypeError
                                            )
                                )
                    )


executeStringStatement : String -> State -> ( State, List String )
executeStringStatement statementString state =
    case Parser.run (parserStatement |. Parser.end) statementString of
        Ok statement ->
            executeStatement statement ( state, [] )
                |> Result.withDefault ( state, [] )

        Err _ ->
            ( state, [] )


setVariable : String -> Value -> State -> State
setVariable varName v state =
    let
        vars =
            Dict.insert varName v state.vars
    in
    { state | vars = vars }


isTruthy : Value -> Bool
isTruthy value =
    case value of
        Number n ->
            n /= 0

        Text t ->
            t /= ""

        Func _ ->
            True


getStringFromValue : Value -> String
getStringFromValue value =
    case value of
        Number float ->
            String.fromFloat float

        Text string ->
            string

        Func expression ->
            stringifyExpression expression


resolveExpressionToString : State -> Expression -> String
resolveExpressionToString state expression =
    evaluateExpression state expression
        |> Result.map getStringFromValue
        |> Result.withDefault ""


evaluateExpressionToString : State -> Expression -> String
evaluateExpressionToString state expr =
    evaluateExpression state expr
        |> Result.map getStringFromValue
        |> Result.withDefault ""



-- helper
-- example


newScreeptParseExample : Result (List Parser.DeadEnd) Expression
newScreeptParseExample =
    --"(!((\"Jan\"+t1)+t2)+5)"
    "(int1 + 3)"
        |> Parser.run (parserExpression |. Parser.end)


parseStatementExample : Result (List Parser.DeadEnd) Statement
parseStatementExample =
    "{ RND b 100 101; PRINT CONCAT(add2,t1,t2); if = 12; IF 0 THEN PRINT \"Y\" ELSE PRINT f1(); PRINT (\"\"?3:b) }"
        |> Parser.run (parserStatement |. Parser.end)


exampleStatement : Statement
exampleStatement =
    Block
        [ Print <| Literal <| Text "Janek"
        , Bind (LiteralIdentifier "test2") (BinaryExpression (Variable (LiteralIdentifier "int1")) Add (Literal (Number 3)))
        , Print <| StandardLibrary "CONCAT" [ Literal <| Text "Janek", Literal <| Text "Dznanek", Literal <| Text "Janek" ]
        , If (Variable (LiteralIdentifier "int1")) (Print <| Literal <| Text "Yes") (Print <| Literal <| Text "No")
        , Print <| FunctionCall (LiteralIdentifier "add2") [ Literal <| Number 5, Literal <| Number 6 ]
        ]


runExample : Result ScreeptError ( State, List String )
runExample =
    executeStatement exampleStatement ( exampleScreeptState, [] )


exampleScreeptState : State
exampleScreeptState =
    { procedures = Dict.empty
    , vars =
        Dict.fromList
            [ ( "int1", Number -12 )
            , ( "float1", Number 3.14 )
            , ( "zero", Number 0 )
            , ( "t1", Text "Jan" )
            , ( "t2", Text "add2" )
            , ( "f1", Func <| Literal <| Text "Wokred" )
            , ( "add2", Func (BinaryExpression (Variable <| LiteralIdentifier "__1") Add (Variable (LiteralIdentifier "__2"))) )
            ]
    , rnd = Random.initialSeed 1
    }
