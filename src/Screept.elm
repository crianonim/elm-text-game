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



--
--type Condition
--    = Predicate IntValue PredicateOp IntValue
--    | NOT Condition
--    | AND (List Condition)
--    | OR (List Condition)
--
--type PredicateOp
--    = Eq
--    | Gt
--    | Lt


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
    | None


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

        None ->
            state

        Comment _ ->
            state

        Procedure name ->
            let
                proc =
                    Dict.get name state.procedures |> Maybe.withDefault None
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
-- CODEC
-----------
--
--
--encodeIntValue : IntValue -> E.Value
--encodeIntValue intValue =
--    case intValue of
--        Const int ->
--            E.int int
--
--        Counter s ->
--            E.string s
--
--        Addition x y ->
--            E.object
--                [ ( "op", E.string "+" )
--                , ( "x", encodeIntValue x )
--                , ( "y", encodeIntValue y )
--                ]
--
--        Subtraction x y ->
--            E.object
--                [ ( "op", E.string "-" )
--                , ( "x", encodeIntValue x )
--                , ( "y", encodeIntValue y )
--                ]
--
--
--encodePredicateOp : PredicateOp -> E.Value
--encodePredicateOp predicateOp =
--    case predicateOp of
--        Eq ->
--            E.string "="
--
--        Gt ->
--            E.string ">"
--
--        Lt ->
--            E.string "<"
--
--
--encodeCondition : Condition -> E.Value
--encodeCondition condition =
--    case condition of
--        Predicate x predicateOp y ->
--            E.object [ ( "PredOp", encodePredicateOp predicateOp ), ( "x", encodeIntValue x ), ( "y", encodeIntValue y ) ]
--
--        NOT c ->
--            E.object [ ( "NOT", encodeCondition c ) ]
--
--        AND conditions ->
--            E.object [ ( "AND", E.list encodeCondition conditions ) ]
--
--        OR conditions ->
--            E.object [ ( "OR", E.list encodeCondition conditions ) ]
--
--
--encodeTextValue : TextValue -> E.Value
--encodeTextValue textValue =
--    case textValue of
--        S s ->
--            E.string s
--
--        Special textValues ->
--            E.list encodeTextValue textValues
--
--        Conditional condition t ->
--            E.object [ ( "condition", encodeCondition condition ), ( "text", encodeTextValue t ) ]
--
--        IntValueText intValue ->
--            encodeIntValue intValue
--
--        Label string ->
--            E.string ("$" ++ string)
--
--
--encodeStatement : Statement -> E.Value
--encodeStatement statement =
--    case statement of
--        SetCounter textValue intValue ->
--            E.object [ ( "setCounter", encodeTextValue textValue ), ( "value", encodeIntValue intValue ) ]
--
--        SetLabel textValue value ->
--            E.object [ ( "setLabel", encodeTextValue textValue ), ( "value", encodeTextValue value ) ]
--
--        Rnd counter min max ->
--            E.object [ ( "rnd", E.object [ ( "counter", encodeTextValue counter ), ( "min", encodeIntValue min ), ( "max", encodeIntValue max ) ] ) ]
--
--        Block statements ->
--            E.list encodeStatement statements
--
--        If condition success failure ->
--            E.object [ ( "if", E.object [ ( "condition", encodeCondition condition ), ( "success", encodeStatement success ), ( "failure", encodeStatement failure ) ] ) ]
--
--        Comment comment ->
--            E.object [ ( "comment", E.string comment ) ]
--
--        -- TODO
--        Procedure _ ->
--            E.null
--
--        None ->
--            E.null
--
-----------
--- Helpers
-----------


inc : String -> Statement
inc counter =
    SetCounter (S counter) (Binary (Counter counter) Add (Const 1))



--
--example : Statement
--example =
--    Block
--        [ Rnd (S "rnd_d6_1") (Const 1) (Const 6)
--        , Rnd (S "rnd_d6_2") (Const 1) (Const 6)
--        , SetCounter (S "rnd_2d6") (Addition (Counter "rnd_d6_1") (Counter "rnd_d6_2"))
--        , SetCounter (S "player_attack") (Addition (Counter "rnd_2d6") (Counter "player_combat"))
--        , SetCounter (S "player_damage") (Subtraction (Counter "player_attack") (Counter "enemy_defence"))
--        , If (Predicate (Counter "player_damage") Gt (Const 0))
--            (Block
--                [ SetCounter (S "enemy_stamina") (Subtraction (Counter "enemy_stamina") (Counter "player_damage"))
--                ]
--            )
--            None
--        , If (Predicate (Counter "enemy_stamina") Gt (Const 0))
--            (Block
--                [ Rnd (S "rnd_d6_1") (Const 1) (Const 6)
--                , Rnd (S "rnd_d6_2") (Const 1) (Const 6)
--                , SetCounter (S "rnd_2d6") (Addition (Counter "rnd_d6_1") (Counter "rnd_d6_2"))
--                , SetCounter (S "enemy_attack") (Addition (Counter "rnd_2d6") (Counter "enemy_combat"))
--                , SetCounter (S "enemy_damage") (Subtraction (Counter "enemy_attack") (Counter "player_defence"))
--                , If (Predicate (Counter "enemy_damage") Gt (Const 0))
--                    (Block
--                        [ SetCounter (S "player_stamina") (Subtraction (Counter "player_stamina") (Counter "enemy_damage"))
--                        , If (Predicate (Counter "player_stamina") Lt (Const 1)) (SetCounter (S "fight_lost") (Const 1)) None
--                        ]
--                    )
--                    None
--                ]
--            )
--            (Block
--                [ SetCounter (S "enemy_damage") (Const 0)
--                , SetCounter (S "fight_won") (Const 1)
--                , SetCounter (Label "enemy_marker") (Const 1)
--                , SetCounter (Special [ S "test", Label "label", Conditional (Predicate (Counter "enemy_marker") Eq (Const 2)) (S "Success") ]) (Const 5)
--                , SetCounter (Special [ S "prefix_", IntValueText (Counter "enemy_marker") ]) (Const 4)
--                ]
--            )
--        ]


toParse : String
toParse =
    "($name_el + (23 - 3))"


toParse2 =
    "NOT (AND (NOT ((22 - 3) < $name_el), 1>0))"


parsedIntValue : Result (List Parser.DeadEnd) IntValue
parsedIntValue =
    Parser.run intValueParser toParse



--
--parsedCondtion =
--    Parser.run conditionParser toParse2


toParse3 =
    "[#enemy_marker, \"Janek\", ($enemy_marker==2?\"Success\"), str(12)]"


parsedTextValue =
    Parser.run textValueParser toParse3


parsed =
    parsedStatement


counterParser : Parser String
counterParser =
    Parser.succeed identity
        |. Parser.symbol "$"
        |= Parser.getChompedString
            (Parser.succeed ()
                |. Parser.chompIf (\c -> Char.isAlpha c || c == '_')
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
            |. Parser.symbol "("
            |= Parser.lazy (\_ -> intValueParser)
            |. Parser.spaces
            |. Parser.symbol ")"
        ]


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
            |= Parser.int
        , Parser.map Counter
            counterParser
        , Parser.succeed Eval
            |. Parser.keyword "CALL"
            |. Parser.spaces
            |= (Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_') |> Parser.getChompedString)
        ]


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


statementToParse =
    """if 2 > 2 then {
label "avc"=str(4);

label "avc"=str(4);
} else
    """


customCombatString =
    """{
RND $rnd_d6_1 1 .. 6;
RND $rnd_d6_2 1 .. 6;
SET $rnd_2d6 = ($rnd_d6_1 + $rnd_d6_2);
SET $player_attack = ($rnd_2d6 + $player_combat);

# comment
;
LABEL $player_name = "Jan";
IF (($rnd_2d6 > 10) && ($rnd_2d6 > 10)) THEN {SET $rnd_2d6=($rnd_d6_1 + $rnd_d6_2);
SET $player_attack=($rnd_2d6 + $player_combat);} ELSE {}
}"""


parsedStatement : Result (List Parser.DeadEnd) Statement
parsedStatement =
    Parser.run statementParser customCombatString


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
            |= (Parser.lineComment "#" |> Parser.getChompedString)
        , Parser.succeed None
            |. Parser.spaces
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
            None
