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
    | Eval String
    | IntVariable String


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
    = SetCounter TextValue IntValue
    | SetLabel TextValue TextValue
    | SetFunc VariableName IntValue
    | Rnd VariableName IntValue IntValue
    | Block (List Statement)
    | If IntValue Statement Statement
    | Comment String
    | Procedure String
    | SetVariable VariableName Variable


type VariableName
    = VLit String
    | VRef String


type Variable
    = VInt IntValue
    | VText TextValue


runStatement : Statement -> State a -> State a
runStatement statement state =
    let
        _ =
            Debug.log "RUN" statement
    in
    case statement of
        SetCounter textValue intValue ->
            getMaybeIntValue intValue state
                |> Maybe.map (\v -> setCounter (getText state textValue) v state)
                |> Maybe.withDefault state

        SetLabel label content ->
            setLabel (getText state label) (getText state content) state

        Rnd var mx my ->
            Maybe.map2
                (\x y ->
                    let
                        ( result, newSeed ) =
                            Random.step (Random.int x y) state.rnd

                        newState =
                            { state | rnd = newSeed }
                    in
                    setVar var (VInt (Const result)) newState
                )
                (getMaybeIntValue mx state)
                (getMaybeIntValue my state)
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
                --(if testCondition condition state then
                --    success
                --
                -- else
                --    failure
                --)
                state

        Comment _ ->
            state

        Procedure name ->
            let
                proc =
                    Dict.get name state.procedures |> Maybe.withDefault (Block [])
            in
            runStatement proc state

        SetFunc name fn ->
            setFunction (getVariableNameString  name state) fn state

        SetVariable name variable ->
            let
                v =
                    case variable of
                        VInt intValue ->
                            VInt <| Const (getIntValueWithDefault intValue state)

                        VText textValue ->
                            VText <| S <| getText state textValue
            in
            setVar name v state



--{ state | vars = Dict.insert name v state.vars }


type alias State a =
    { a
        | counters : Dict String Int
        , labels : Dict String String
        , procedures : Dict String Statement
        , functions : Dict String IntValue
        , rnd : Random.Seed
        , vars : Dict String Variable
    }


emptyState =
    { counters = Dict.empty
    , labels = Dict.empty
    , procedures = Dict.empty
    , functions = Dict.empty
    , rnd = Random.initialSeed 666
    }


getText : State a -> TextValue -> String
getText gameState text =
    case text of
        S string ->
            string

        Concat specialTexts ->
            List.map (getText gameState) specialTexts |> String.concat

        Conditional gameCheck conditionalText alternativeText ->
            if isTruthy gameCheck gameState then
                getText gameState conditionalText

            else
                getText gameState alternativeText

        IntValueText gameValue ->
            getIntValueWithDefault gameValue gameState |> String.fromInt



        TextVariable name ->
            getTextValueFromVariable (getVariableNameString name gameState) gameState


getTextValueFromVariable : String -> State a -> String
getTextValueFromVariable name state =
    Dict.get name state.vars
        |> Maybe.map
            (\v ->
                case v of
                    VInt i ->
                        intValueStringify i

                    VText t ->
                        getText state t
            )
        |> Maybe.withDefault ""


getIntValueWithDefault : IntValue -> State a -> Int
getIntValueWithDefault gameValue gameState =
    getMaybeIntValue gameValue gameState |> Maybe.withDefault 0


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

        VRef var ->
            getTextValueFromVariable var state


stringifyVariableName : VariableName -> String
stringifyVariableName variableName =
    case variableName of
        VLit string ->
            string

        VRef textValue ->
            "$" ++ textValue


getMaybeIntValue : IntValue -> State a -> Maybe Int
getMaybeIntValue gameValue gameState =


    case gameValue of
        Const int ->
            Just int



        Unary op mx ->
            Maybe.map (unaryOpEval op) (getMaybeIntValue mx gameState)

        Binary mx op my ->
            Maybe.map2 (binaryOpEval op) (getMaybeIntValue mx gameState) (getMaybeIntValue my gameState)

        Eval func ->
            Dict.get func gameState.functions
                |> Maybe.andThen (\x ->
                let
                    _ =
                        Debug.log "FUNC" (func,x,getMaybeIntValue x gameState)
                in

                getMaybeIntValue x gameState)

        IntVariable name ->
            getMaybeIntFromVariable name gameState


getMaybeIntFromVariable : String -> State a -> Maybe Int
getMaybeIntFromVariable name state =
    let
        var =
            Dict.get name state.vars
    in
    Maybe.andThen
        (\v ->
            case v of
                VText t ->
                    if getText state t == "" then
                        Just 0

                    else
                        Just 1

                VInt i ->
                    getMaybeIntValue i state
        )
        var


getMaybeLabel : String -> State a -> Maybe String
getMaybeLabel label state =
    Dict.get label state.labels


getLabelWithDefault : String -> State a -> String
getLabelWithDefault label state =
    getMaybeLabel label state |> Maybe.withDefault ""


addCounter : String -> Int -> State a -> State a
addCounter counter add gameState =
    { gameState | counters = Dict.update counter (\value -> Maybe.map (\v -> v + add) value) gameState.counters }


setVar : VariableName -> Variable -> State a -> State a
setVar name variable state =
    let
        varname =
            getVariableNameString name state
    in
    { state | vars = Dict.insert varname variable state.vars }


setCounter : String -> Int -> State a -> State a
setCounter counter x gameState =
    { gameState | counters = Dict.insert counter x gameState.counters }


setLabel : String -> String -> State a -> State a
setLabel counter x gameState =
    { gameState | labels = Dict.insert counter x gameState.labels }


setFunction : String -> IntValue -> State a -> State a
setFunction id fn state =
    { state | functions = Dict.insert id fn state.functions }


isTruthy : IntValue -> State a -> Bool
isTruthy intValue state =
    if getIntValueWithDefault intValue state == 0 then
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
        [ Parser.succeed VRef
            |. Parser.symbol "$"
            |= nextWordParser
        , Parser.succeed VLit
            |= nextWordParser
        ]


counterParser : Parser String
counterParser =
    Parser.succeed identity
        |. Parser.symbol "$"
        |= Parser.getChompedString
            (Parser.succeed ()
                |. Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_')
            )


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

        Eval string ->
            "CALL " ++ string

        IntVariable string ->
            string


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
        --, Parser.map Counter
        --    counterParser
        , Parser.succeed Eval
            |. Parser.keyword "CALL"
            |. Parser.spaces
            |= nextWordParser
        , Parser.succeed IntVariable
            |= nextWordParser
        ]


textValueStringify : TextValue -> String
textValueStringify textValue =
    case textValue of
        S string ->
            "\"" ++ string ++ "\""

        Concat textValues ->
            "[ " ++ String.join ", " (List.map textValueStringify textValues) ++ " ]"

        Conditional cond success failure ->
            "(" ++ intValueStringify cond ++ "?" ++ textValueStringify success ++ ":" ++ textValueStringify failure ++ ")"

        IntValueText intValue ->
            "str(" ++ intValueStringify intValue ++ ")"



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
            |. Parser.symbol "str("
            |= intValueParser
            |. Parser.symbol ")"
        , Parser.succeed TextVariable
            |= parseVariableName
         ]


counterStringify : TextValue -> String
counterStringify textValue =
    case textValue of
        S x ->
            "$" ++ x

        x ->
            textValueStringify x


statementStringify : Statement -> String
statementStringify statement =
    case statement of
        SetCounter textValue intValue ->
            "SET " ++ counterStringify textValue ++ " = " ++ intValueStringify intValue

        SetLabel t1 t2 ->
            "LABEL " ++ counterStringify t1 ++ " = " ++ textValueStringify t2

        SetFunc textValue intValue ->
            "DEF_FUNC " ++ stringifyVariableName textValue ++ " = " ++ intValueStringify intValue

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
            "LET " ++ stringifyVariableName name ++ " = " ++ stringifyVariable variable


nextWordParser : Parser String
nextWordParser =
    Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_') |> Parser.getChompedString


statementParser : Parser Statement
statementParser =
    Parser.oneOf
        [ Parser.succeed SetCounter
            |. Parser.keyword "SET"
            |. Parser.spaces
            |= Parser.oneOf [ textValueParser, counterParser |> Parser.map S ]
            |. Parser.spaces
            |. Parser.symbol "="
            |. Parser.spaces
            |= intValueParser
        , Parser.succeed SetLabel
            |. Parser.keyword "LABEL"
            |. Parser.spaces
            |= Parser.oneOf [ textValueParser, counterParser |> Parser.map S ]
            |. Parser.spaces
            |. Parser.symbol "="
            |. Parser.spaces
            |= textValueParser
        , Parser.succeed SetFunc
            |. Parser.keyword "DEF_FUNC"
            |. Parser.spaces
            |= parseVariableName
            |. Parser.spaces
            |. Parser.symbol "="
            |. Parser.spaces
            |= intValueParser
        , Parser.succeed Rnd
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
            |. Parser.symbol "="
            |. Parser.spaces
            |=  (intValueParser |> Parser.map VInt)

         , Parser.succeed SetVariable
                    |. Parser.keyword "TEXT"
                    |. Parser.spaces
                    |= parseVariableName
                    |. Parser.spaces
                    |. Parser.symbol "="
                    |. Parser.spaces
                    |=  (textValueParser |> Parser.map VText)
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


stringifyVariable : Variable -> String
stringifyVariable variable =
    case variable of
        VInt intValue ->
            intValueStringify intValue

        VText textValue ->
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
        [ SetVariable (VLit "a") (VInt (Const 12))
        , SetVariable (VLit "b") (VText (S "var_name"))
        , SetVariable (VLit "c") (VText (S ""))
        , SetVariable (VLit "d") (VInt (Const 0))
        , If (IntVariable "a") (SetVariable (VLit "e") (VInt (Const 1))) (SetVariable (VLit "e") (VInt (Const 0)))
        , If (IntVariable "b") (SetVariable (VLit "f") (VInt (Const 1))) (SetVariable (VLit "f") (VInt (Const 0)))
        , If (IntVariable "c") (SetVariable (VLit "g") (VInt (Const 1))) (SetVariable (VLit "g") (VInt (Const 0)))
        , If (IntVariable "d") (SetVariable (VLit "h") (VInt (Const 1))) (SetVariable (VLit "h") (VInt (Const 0)))

        --, VIf (VInt (Const 12)) (SetVariable "success" (VText (S "YES"))) (SetVariable "success" (VText (S "NO")))
        --, VIf (VText (S "With Value")) (SetVariable "success2" (VText (S "YES"))) (SetVariable "success2" (VText (S "NO")))
        --, VIf (VText (S "")) (SetVariable "success3" (VText (S "YES"))) (SetVariable "success3" (VText (S "NO")))
        --, VIf (VInt (Const 0)) (SetVariable "success4" (VText (S "YES"))) (SetVariable "success4" (VText (S "NO")))
        --, SetVariable "e" (VBinary (VText (S "With Value")) And (VText (S "-With Value")))
        --]
        ]
