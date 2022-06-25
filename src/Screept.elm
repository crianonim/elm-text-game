module Screept exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json
import Json.Encode as E
import Parser exposing ((|.), (|=), Parser, spaces, symbol)
import Random


type IntValue
    = Const Int
    | Counter String
    | Unary UnaryOp IntValue
    | Binary IntValue BinaryOp IntValue
    | Eval String


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
    | Label String


type Statement
    = SetCounter TextValue IntValue
    | SetLabel TextValue TextValue
    | SetFunc TextValue IntValue
    | Rnd TextValue IntValue IntValue
    | Block (List Statement)
    | If IntValue Statement Statement
    | Comment String
    | Procedure String


runStatement : Statement -> State a -> State a
runStatement statement state =
    case statement of
        SetCounter textValue intValue ->
            getMaybeIntValue intValue state
                |> Maybe.map (\v -> setCounter (getText state textValue) v state)
                |> Maybe.withDefault state

        SetLabel label content ->
            setLabel (getText state label) (getText state content) state

        Rnd counter mx my ->
            Maybe.map2
                (\x y ->
                    let
                        ( result, newSeed ) =
                            Random.step (Random.int x y) state.rnd

                        newState =
                            { state | rnd = newSeed }

                        counterName =
                            getText state counter
                    in
                    setCounter counterName result newState
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
            setFunction (getText state name) fn state


type alias State a =
    { a
        | counters : Dict String Int
        , labels : Dict String String
        , procedures : Dict String Statement
        , functions : Dict String IntValue
        , rnd : Random.Seed
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

        Label label ->
            getLabelWithDefault label gameState


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


getMaybeIntValue : IntValue -> State a -> Maybe Int
getMaybeIntValue gameValue gameState =
    case gameValue of
        Const int ->
            Just int

        Counter counter ->
            Dict.get counter gameState.counters

        Unary op mx ->
            Maybe.map (unaryOpEval op) (getMaybeIntValue mx gameState)

        Binary mx op my ->
            Maybe.map2 (binaryOpEval op) (getMaybeIntValue mx gameState) (getMaybeIntValue my gameState)

        Eval func ->
            Dict.get func gameState.functions
                |> Maybe.andThen (\x -> getMaybeIntValue x gameState)


getMaybeLabel : String -> State a -> Maybe String
getMaybeLabel label state =
    Dict.get label state.labels


getLabelWithDefault : String -> State a -> String
getLabelWithDefault label state =
    getMaybeLabel label state |> Maybe.withDefault ""


addCounter : String -> Int -> State a -> State a
addCounter counter add gameState =
    { gameState | counters = Dict.update counter (\value -> Maybe.map (\v -> v + add) value) gameState.counters }


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


inc : String -> Statement
inc counter =
    SetCounter (S counter) (Binary (Counter counter) Add (Const 1))


intWithPotentialMinus : Parser Int
intWithPotentialMinus =
    Parser.oneOf
        [ Parser.succeed negate
            |. symbol "-"
            |= Parser.int
        , Parser.int
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

        Counter string ->
            "$" ++ string

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
        , Parser.map Counter
            counterParser
        , Parser.succeed Eval
            |. Parser.keyword "CALL"
            |. Parser.spaces
            |= (Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_') |> Parser.getChompedString)
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

        Label string ->
            "#" ++ string


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
        , Parser.succeed Label
            |. Parser.symbol "#"
            |= (Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_') |> Parser.getChompedString)
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
            "DEF_FUNC " ++ counterStringify textValue ++ " = " ++ intValueStringify intValue

        Rnd textValue i1 i2 ->
            "RND " ++ counterStringify textValue ++ " " ++ intValueStringify i1 ++ " .. " ++ intValueStringify i2

        Block statements ->
            "{ " ++ String.join ";\n" (List.map statementStringify statements) ++ " }"

        If intValue success failure ->
            "IF " ++ intValueStringify intValue ++ " THEN " ++ statementStringify success ++ " ELSE " ++ statementStringify failure

        Comment string ->
            "#" ++ string ++ "\n"

        Procedure string ->
            "RUN " ++ string


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
            |= Parser.oneOf [ textValueParser, counterParser |> Parser.map S ]
            |. Parser.spaces
            |. Parser.symbol "="
            |. Parser.spaces
            |= intValueParser
        , Parser.succeed Rnd
            |. Parser.keyword "RND"
            |. Parser.spaces
            |= Parser.oneOf [ textValueParser, counterParser |> Parser.map S ]
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
        ]


runIntValue : String -> IntValue
runIntValue intVal =
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


runTextValue : String -> TextValue
runTextValue string =
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


run : String -> Statement
run statement =
    case Parser.run statementParser statement of
        Ok value ->
            value

        Err error ->
            let
                _ =
                    Debug.log "Error parsing : " statement

                _ =
                    Debug.log "!" error
            in
            Block []
