module Screept exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json
import Json.Encode as E
import Parser exposing ((|.), (|=), Parser, spaces, symbol)
import Random


type IntValue
    = Const Int
    | Unary UnaryOp IntValue
    | Binary IntValue BinaryOp IntValue
    | IntVariable VariableName


type UnaryOp
    = Not


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


type TextValue
    = S String
    | Concat (List TextValue)
    | Conditional IntValue TextValue TextValue
    | IntValueText IntValue
    | TextVariable VariableName


type Statement
    = Rnd VariableName IntValue IntValue
    | Block (List Statement)
    | If IntValue Statement Statement
    | Comment String
    | Procedure String
    | SetVariable VariableName VariableExpression


type VariableName
    = VLit String
    | VComputed TextValue



-- type of the value stored in Store.vars


type Variable
    = VInt Int
    | VText String
    | VLazyInt IntValue
    | VLazyText TextValue


type VariableExpression
    = SVInt IntValue
    | SVText TextValue
    | SVLazyInt IntValue
    | SVLazyText TextValue


runStatement : Statement -> State a -> State a
runStatement statement state =
    let
        _ =
            Debug.log "RUN" statement
    in
    case statement of
        Rnd var mx my ->
            Maybe.map2
                (\x y ->
                    let
                        ( result, newSeed ) =
                            Random.step (Random.int x y) state.rnd

                        newState =
                            { state | rnd = newSeed }
                    in
                    setVar var (VInt result) newState
                )
                (getMaybeIntValue state mx)
                (getMaybeIntValue state my)
                |> Maybe.withDefault state

        Block statements ->
            List.foldl (\s acc -> runStatement s acc) state statements

        If condition success failure ->
            runStatement
                (if isTruthy condition state then
                    success

                 else
                    failure
                )
                state

        Comment _ ->
            state

        Procedure name ->
            let
                proc =
                    Dict.get name state.procedures |> Maybe.withDefault (Block [])
            in
            runStatement proc state

        SetVariable name variable ->
            let
                v =
                    case variable of
                        SVInt intValue ->
                            VInt <| getIntValueWithDefault state intValue

                        SVText textValue ->
                            VText <| getString state textValue

                        SVLazyInt intValue ->
                            VLazyInt intValue

                        SVLazyText textValue ->
                            VLazyText textValue
            in
            setVar name v state


type alias State a =
    { a
        | procedures : Dict String Statement
        , rnd : Random.Seed
        , vars : Dict String Variable
    }


emptyState =
    { procedures = Dict.empty
    , functions = Dict.empty
    , rnd = Random.initialSeed 666
    , vars = Dict.empty
    }


getString : State a -> TextValue -> String
getString state text =
    case text of
        S string ->
            string

        Concat specialTexts ->
            List.map (getString state) specialTexts |> String.concat

        Conditional intValue conditionalText alternativeText ->
            if isTruthy intValue state then
                getString state conditionalText

            else
                getString state alternativeText

        IntValueText gameValue ->
            getIntValueWithDefault state gameValue |> String.fromInt

        TextVariable name ->
            getStringFromVariableNameString (getVariableNameString name state) state


getStringFromVariable : Variable -> State a -> String
getStringFromVariable v state =
    case v of
        VInt i ->
            String.fromInt i

        VText t ->
            t

        VLazyInt i ->
            getIntValueWithDefault state i
                |> String.fromInt

        VLazyText textValue ->
            getString state textValue


getStringFromVariableNameString : String -> State a -> String
getStringFromVariableNameString name state =
    Dict.get name state.vars
        |> Maybe.map (\v -> getStringFromVariable v state)
        |> Maybe.withDefault ""


getIntValueWithDefault : State a -> IntValue -> Int
getIntValueWithDefault state intValue =
    getMaybeIntValue state intValue
        |> Maybe.withDefault 0


unaryOpEval : UnaryOp -> Int -> Int
unaryOpEval op x =
    case op of
        Not ->
            if x == 0 then
                1

            else
                0


binaryOpEval : BinaryOp -> Int -> Int -> Int
binaryOpEval op x y =
    case op of
        Add ->
            x + y

        Sub ->
            x - y

        Mod ->
            modBy y x

        Mul ->
            x * y

        Div ->
            x // y

        Gt ->
            if x > y then
                1

            else
                0

        Lt ->
            if x < y then
                1

            else
                0

        Eq ->
            if x == y then
                1

            else
                0

        And ->
            if x * y == 0 then
                0

            else
                1

        Or ->
            if x + y == 0 then
                0

            else
                1


getVariableNameString : VariableName -> State a -> String
getVariableNameString variableName state =
    case variableName of
        VLit var ->
            var

        VComputed textValue ->
            getString state textValue


stringifyVariableName : VariableName -> String
stringifyVariableName variableName =
    case variableName of
        VLit string ->
            string

        VComputed textValue ->
            "#" ++ textValueStringify textValue


getMaybeIntValue : State a -> IntValue -> Maybe Int
getMaybeIntValue state intValue =
    case intValue of
        Const int ->
            Just int

        Unary op mx ->
            Maybe.map (unaryOpEval op) (getMaybeIntValue state mx)

        Binary mx op my ->
            Maybe.map2 (binaryOpEval op) (getMaybeIntValue state mx) (getMaybeIntValue state my)

        IntVariable varName ->
            getMaybeIntFromVariableName state varName


getMaybeIntFromVariable : State a -> Variable -> Maybe Int
getMaybeIntFromVariable state v =
    case v of
        VText t ->
            if t == "" then
                Just 0

            else
                Just 1

        VInt i ->
            Just i

        VLazyInt i ->
            getMaybeIntValue state i

        VLazyText textValue ->
            if getString state textValue == "" then
                Just 0

            else
                Just 1


getMaybeIntFromVariableName : State a -> VariableName -> Maybe Int
getMaybeIntFromVariableName state varName =
    Dict.get (getVariableNameString varName state) state.vars
        |> Maybe.andThen (getMaybeIntFromVariable state)


setVar : VariableName -> Variable -> State a -> State a
setVar name variable state =
    let
        varname =
            getVariableNameString name state
    in
    { state | vars = Dict.insert varname variable state.vars }


isTruthy : IntValue -> State a -> Bool
isTruthy intValue state =
    if getIntValueWithDefault state intValue == 0 then
        False

    else
        True



-----------
--- Helpers
-----------


intWithPotentialMinus : Parser Int
intWithPotentialMinus =
    Parser.oneOf
        [ Parser.succeed negate
            |. symbol "-"
            |= Parser.int
        , Parser.int
        ]


parseVariableName : Parser VariableName
parseVariableName =
    Parser.oneOf
        [ Parser.succeed VComputed
            |. Parser.symbol "#"
            |= Parser.lazy (\_ -> textValueParser)
        , Parser.succeed VLit
            |= nextWordParser
        ]


unaryOpParser : Parser IntValue
unaryOpParser =
    Parser.oneOf
        [ Parser.succeed Unary
            |= Parser.oneOf
                [ Parser.succeed Not
                    |. Parser.symbol "!"
                ]
            |= Parser.lazy (\_ -> intValueParser)
        ]


binaryOpStringify : BinaryOp -> String
binaryOpStringify binaryOp =
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


unaryOpStringify : UnaryOp -> String
unaryOpStringify unaryOp =
    case unaryOp of
        Not ->
            "!"


intValueStringify : IntValue -> String
intValueStringify intValue =
    case intValue of
        Const int ->
            String.fromInt int

        Unary unaryOp x ->
            unaryOpStringify unaryOp ++ intValueStringify x

        Binary x binaryOp y ->
            "("
                ++ intValueStringify x
                ++ " "
                ++ binaryOpStringify binaryOp
                ++ " "
                ++ intValueStringify y
                ++ ")"

        IntVariable string ->
            stringifyVariableName string


binaryOpParser : Parser IntValue
binaryOpParser =
    Parser.oneOf
        [ Parser.succeed Binary
            |. Parser.symbol "("
            |= Parser.lazy (\_ -> intValueParser)
            |. Parser.spaces
            |= Parser.oneOf
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
            |. Parser.spaces
            |= Parser.lazy (\_ -> intValueParser)
            |. Parser.symbol ")"
        ]


intValueParser : Parser IntValue
intValueParser =
    Parser.oneOf
        [ binaryOpParser
        , unaryOpParser
        , Parser.succeed Const
            |= intWithPotentialMinus
        , Parser.succeed IntVariable
            |= parseVariableName
        ]


textValueStringify : TextValue -> String
textValueStringify textValue =
    case textValue of
        S string ->
            "\"" ++ string ++ "\""

        Concat textValues ->
            "[" ++ String.join ", " (List.map textValueStringify textValues) ++ "]"

        Conditional cond success failure ->
            "(" ++ intValueStringify cond ++ "?" ++ textValueStringify success ++ ":" ++ textValueStringify failure ++ ")"

        IntValueText intValue ->
            "TO_TEXT " ++ intValueStringify intValue

        TextVariable string ->
            stringifyVariableName string


textValueParser : Parser TextValue
textValueParser =
    Parser.oneOf
        [ Parser.succeed S
            |. Parser.symbol "\""
            |= (Parser.chompWhile (\c -> c /= '"') |> Parser.getChompedString)
            |. Parser.symbol "\""
        , Parser.succeed Concat
            |= Parser.sequence
                { start = "["
                , separator = ","
                , end = "]"
                , spaces = spaces
                , item = Parser.lazy (\_ -> textValueParser)
                , trailing = Parser.Forbidden
                }
        , Parser.succeed Conditional
            |. Parser.symbol "("
            |= intValueParser
            |. Parser.symbol "?"
            |= Parser.lazy (\_ -> textValueParser)
            |. Parser.symbol ":"
            |= Parser.lazy (\_ -> textValueParser)
            |. Parser.symbol ")"
        , Parser.succeed IntValueText
            |. Parser.symbol "TO_TEXT "
            |= intValueParser
        , Parser.succeed TextVariable
            |= parseVariableName
        ]


statementStringify : Statement -> String
statementStringify statement =
    case statement of
        Rnd varName i1 i2 ->
            "RND " ++ stringifyVariableName varName ++ " " ++ intValueStringify i1 ++ " .. " ++ intValueStringify i2

        Block statements ->
            "{ " ++ String.join ";\n" (List.map statementStringify statements) ++ " }"

        If intValue success failure ->
            "IF " ++ intValueStringify intValue ++ " THEN " ++ statementStringify success ++ " ELSE " ++ statementStringify failure

        Comment string ->
            "#" ++ string ++ "\n"

        Procedure string ->
            "RUN " ++ string

        SetVariable name variable ->
            case variable of
                SVInt _ ->
                    "INT " ++ stringifyVariableName name ++ " = " ++ stringifySetVariable variable

                SVText _ ->
                    "TEXT " ++ stringifyVariableName name ++ " = " ++ stringifySetVariable variable

                SVLazyInt _ ->
                    "INT " ++ stringifyVariableName name ++ " ~= " ++ stringifySetVariable variable

                SVLazyText _ ->
                    "TEXT " ++ stringifyVariableName name ++ " ~= " ++ stringifySetVariable variable


nextWordParser : Parser String
nextWordParser =
    Parser.getChompedString <|
        Parser.succeed ()
            |. Parser.chompIf (\c -> Char.isAlphaNum c || c == '_')
            |. Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_')


statementParser : Parser Statement
statementParser =
    Parser.oneOf
        [ Parser.succeed Rnd
            |. Parser.keyword "RND"
            |. Parser.spaces
            |= parseVariableName
            |. Parser.spaces
            |= intValueParser
            |. Parser.spaces
            |. Parser.symbol ".."
            |. Parser.spaces
            |= intValueParser
        , Parser.succeed If
            |. Parser.keyword "IF"
            |. Parser.spaces
            |= intValueParser
            |. Parser.spaces
            |. Parser.keyword "THEN"
            |. Parser.spaces
            |= Parser.lazy (\_ -> statementParser)
            |. Parser.spaces
            |. Parser.keyword "ELSE"
            |. Parser.spaces
            |= Parser.lazy (\_ -> statementParser)
        , Parser.succeed Block
            |= Parser.sequence
                { start = "{"
                , separator = ";"
                , end = "}"
                , spaces = spaces
                , item = Parser.lazy (\_ -> statementParser)
                , trailing = Parser.Optional
                }
        , Parser.succeed Procedure
            |. Parser.symbol "RUN"
            |. Parser.spaces
            |= (Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_') |> Parser.getChompedString)
        , Parser.succeed Comment
            |. Parser.symbol "#"
            |= (Parser.chompWhile (\c -> c /= '\n') |> Parser.getChompedString)
        , Parser.succeed SetVariable
            |. Parser.keyword "INT"
            |. Parser.spaces
            |= parseVariableName
            |. Parser.spaces
            |= Parser.oneOf
                [ Parser.succeed identity
                    |. Parser.symbol "="
                    |. Parser.spaces
                    |= (intValueParser |> Parser.map SVInt)
                , Parser.succeed identity
                    |. Parser.symbol "~="
                    |. Parser.spaces
                    |= (intValueParser |> Parser.map SVLazyInt)
                ]
        , Parser.succeed SetVariable
            |. Parser.keyword "TEXT"
            |. Parser.spaces
            |= parseVariableName
            |. Parser.spaces
            |= Parser.oneOf
                [ Parser.succeed identity
                    |. Parser.symbol "="
                    |. Parser.spaces
                    |= (textValueParser |> Parser.map SVText)
                , Parser.succeed identity
                    |. Parser.symbol "~="
                    |. Parser.spaces
                    |= (textValueParser |> Parser.map SVLazyText)
                ]
        ]


parseStatement : String -> Statement
parseStatement statement =
    case Parser.run statementParser statement of
        Ok value ->
            value

        Err error ->
            let
                _ =
                    Debug.log "Error parsing Statement: " statement

                _ =
                    Debug.log "!" error
            in
            Block []


parseIntValue : String -> IntValue
parseIntValue intVal =
    case Parser.run intValueParser intVal of
        Ok value ->
            value

        Err error ->
            let
                _ =
                    Debug.log "Error parsing IntVal: " intVal

                _ =
                    Debug.log "!" error
            in
            Const 0


parseTextValue : String -> TextValue
parseTextValue string =
    case Parser.run textValueParser string of
        Ok value ->
            value

        Err error ->
            let
                _ =
                    Debug.log "Error parsing TextVal: " string

                _ =
                    Debug.log "!" error
            in
            S ""


stringifySetVariable : VariableExpression -> String
stringifySetVariable variable =
    case variable of
        SVInt intValue ->
            intValueStringify intValue

        SVText textValue ->
            textValueStringify textValue

        SVLazyInt intValue ->
            intValueStringify intValue

        SVLazyText textValue ->
            textValueStringify textValue


stringifyVariable : Variable -> String
stringifyVariable variable =
    case variable of
        VInt intValue ->
            String.fromInt intValue

        VText textValue ->
            "\"" ++ textValue ++ "\""

        VLazyInt intValue ->
            intValueStringify intValue

        VLazyText textValue ->
            textValueStringify textValue


run : String -> Statement
run statement =
    case Parser.run statementParser statement of
        Ok value ->
            let
                _ =
                    Debug.log "parsed" value
            in
            value

        Err error ->
            let
                _ =
                    Debug.log "Error parsing : " statement

                _ =
                    Debug.log "!" error
            in
            Block []


exec : String -> State a -> State a
exec statement state =
    runStatement (run statement) state


exampleStatement =
    Block
        [ SetVariable (VLit "a") (SVInt (Const 12))
        , SetVariable (VLit "b") (SVText (S "var_name"))
        , SetVariable (VLit "c") (SVText (S ""))
        , SetVariable (VLit "d") (SVInt (Const 0))
        , If (IntVariable (VLit "a")) (SetVariable (VLit "e") (SVInt (Const 1))) (SetVariable (VLit "e") (SVInt (Const 0)))
        , If (IntVariable (VLit "b")) (SetVariable (VLit "f") (SVInt (Const 1))) (SetVariable (VLit "f") (SVInt (Const 0)))
        , If (IntVariable (VLit "c")) (SetVariable (VLit "g") (SVInt (Const 1))) (SetVariable (VLit "g") (SVInt (Const 0)))
        , If (IntVariable (VLit "d")) (SetVariable (VLit "h") (SVInt (Const 1))) (SetVariable (VLit "h") (SVInt (Const 0)))

        --, VIf (VInt (Const 12)) (SetVariable "success" (VText (S "YES"))) (SetVariable "success" (VText (S "NO")))
        --, VIf (VText (S "With Value")) (SetVariable "success2" (VText (S "YES"))) (SetVariable "success2" (VText (S "NO")))
        --, VIf (VText (S "")) (SetVariable "success3" (VText (S "YES"))) (SetVariable "success3" (VText (S "NO")))
        --, VIf (VInt (Const 0)) (SetVariable "success4" (VText (S "YES"))) (SetVariable "success4" (VText (S "NO")))
        --, SetVariable "e" (VBinary (VText (S "With Value")) And (VText (S "-With Value")))
        --]
        ]


decodeVariable : Json.Decoder Variable
decodeVariable =
    Json.oneOf
        [ Json.int |> Json.map VInt
        , Json.string |> Json.map VText
        , Json.field "lazy_int" Json.string |> Json.map (parseIntValue >> VLazyInt)
        , Json.field "lazy_text" Json.string |> Json.map (parseTextValue >> VLazyText)
        ]


encodeVariable : Variable -> E.Value
encodeVariable variable =
    case variable of
        VInt i ->
            E.int i

        VText t ->
            E.string t

        VLazyInt f ->
            E.object [ ( "lazy_int", intValueStringify f |> E.string ) ]

        VLazyText textValue ->
            E.object [ ( "lazy_text", textValueStringify textValue |> E.string ) ]


getMaybeFuncTextValueFromVariable : Variable -> Maybe TextValue
getMaybeFuncTextValueFromVariable variable =
    case variable of
        VLazyText t ->
            Just t

        _ ->
            Nothing


statementPrettyStringify : Int -> Statement -> String
statementPrettyStringify i statement =
    let
        ident id =
            String.repeat id " "
    in
    ident i
        ++ (case statement of
                Rnd varName i1 i2 ->
                    "RND " ++ stringifyVariableName varName ++ " " ++ intValueStringify i1 ++ " .. " ++ intValueStringify i2

                Block statements ->
                    if List.isEmpty statements then
                        "{}"

                    else
                        "{\n" ++ String.join ";\n" (List.map (statementPrettyStringify (i + 1)) statements) ++ "\n" ++ ident i ++ " }"

                If intValue success failure ->
                    "IF " ++ intValueStringify intValue ++ " THEN\n" ++ statementPrettyStringify (i + 1) success ++ "\n" ++ ident i ++ "ELSE " ++ statementPrettyStringify (i + 1) failure

                Comment string ->
                    "#" ++ string ++ "\n"

                Procedure string ->
                    "RUN " ++ string

                SetVariable name variable ->
                    case variable of
                        SVInt _ ->
                            "INT " ++ stringifyVariableName name ++ " = " ++ stringifySetVariable variable

                        SVText _ ->
                            "TEXT " ++ stringifyVariableName name ++ " = " ++ stringifySetVariable variable

                        SVLazyInt _ ->
                            "INT " ++ stringifyVariableName name ++ " ~= " ++ stringifySetVariable variable

                        SVLazyText _ ->
                            "TEXT " ++ stringifyVariableName name ++ " ~= " ++ stringifySetVariable variable
           )
