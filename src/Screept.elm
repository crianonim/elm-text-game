module Screept exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json
import Json.Encode as E
import Parser exposing ((|.), (|=), Parser, spaces, symbol)
import Random


type IntValue
    = Const Int
    | Counter String
    | Addition IntValue IntValue
    | Subtraction IntValue IntValue


type Condition
    = Predicate IntValue PredicateOp IntValue
    | NOT Condition
    | AND (List Condition)
    | OR (List Condition)


type PredicateOp
    = Eq
    | Gt
    | Lt


type TextValue
    = S String
    | Special (List TextValue)
    | Conditional Condition TextValue
    | IntValueText IntValue
    | Label String


type Statement
    = SetCounter TextValue IntValue
    | SetLabel TextValue TextValue
    | Rnd TextValue IntValue IntValue
    | Block (List Statement)
    | If Condition Statement Statement
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
                (if testCondition condition state then
                    success

                 else
                    failure
                )
                state

        None ->
            state


type alias State a =
    { a | counters : Dict String Int, labels : Dict String String, rnd : Random.Seed }


getText : State a -> TextValue -> String
getText gameState text =
    case text of
        S string ->
            string

        Special specialTexts ->
            List.map (getText gameState) specialTexts |> String.concat

        Conditional gameCheck conditionalText ->
            if testCondition gameCheck gameState then
                getText gameState conditionalText

            else
                ""

        IntValueText gameValue ->
            getIntValueWithDefault gameValue gameState |> String.fromInt

        Label label ->
            getLabelWithDefault label gameState


getIntValueWithDefault : IntValue -> State a -> Int
getIntValueWithDefault gameValue gameState =
    getMaybeIntValue gameValue gameState |> Maybe.withDefault 0


getMaybeIntValue : IntValue -> State a -> Maybe Int
getMaybeIntValue gameValue gameState =
    case gameValue of
        Const int ->
            Just int

        Counter counter ->
            Dict.get counter gameState.counters

        Addition mx my ->
            Maybe.map2 (\x y -> x + y) (getMaybeIntValue mx gameState) (getMaybeIntValue my gameState)

        Subtraction mx my ->
            Maybe.map2 (\x y -> x - y) (getMaybeIntValue mx gameState) (getMaybeIntValue my gameState)


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


testCondition : Condition -> State a -> Bool
testCondition condition gameState =
    let
        testPredicate : IntValue -> PredicateOp -> IntValue -> Bool
        testPredicate x predicate y =
            let
                comp =
                    case predicate of
                        Lt ->
                            (<)

                        Eq ->
                            (==)

                        Gt ->
                            (>)
            in
            Maybe.map2 comp (getMaybeIntValue x gameState) (getMaybeIntValue y gameState)
                |> Maybe.withDefault False
    in
    case condition of
        Predicate v1 ops v2 ->
            testPredicate v1 ops v2

        NOT innerTest ->
            not <| testCondition innerTest gameState

        AND conditions ->
            List.foldl (\c acc -> testCondition c gameState && acc) True conditions

        OR conditions ->
            List.foldl (\c acc -> testCondition c gameState || acc) False conditions



-----------
-- CODEC
-----------


encodeIntValue : IntValue -> E.Value
encodeIntValue intValue =
    case intValue of
        Const int ->
            E.int int

        Counter s ->
            E.string s

        Addition x y ->
            E.object
                [ ( "op", E.string "+" )
                , ( "x", encodeIntValue x )
                , ( "y", encodeIntValue y )
                ]

        Subtraction x y ->
            E.object
                [ ( "op", E.string "-" )
                , ( "x", encodeIntValue x )
                , ( "y", encodeIntValue y )
                ]


encodePredicateOp : PredicateOp -> E.Value
encodePredicateOp predicateOp =
    case predicateOp of
        Eq ->
            E.string "="

        Gt ->
            E.string ">"

        Lt ->
            E.string "<"


encodeCondition : Condition -> E.Value
encodeCondition condition =
    case condition of
        Predicate x predicateOp y ->
            E.object [ ( "PredOp", encodePredicateOp predicateOp ), ( "x", encodeIntValue x ), ( "y", encodeIntValue y ) ]

        NOT c ->
            E.object [ ( "NOT", encodeCondition c ) ]

        AND conditions ->
            E.object [ ( "AND", E.list encodeCondition conditions ) ]

        OR conditions ->
            E.object [ ( "OR", E.list encodeCondition conditions ) ]


encodeTextValue : TextValue -> E.Value
encodeTextValue textValue =
    case textValue of
        S s ->
            E.string s

        Special textValues ->
            E.list encodeTextValue textValues

        Conditional condition t ->
            E.object [ ( "condition", encodeCondition condition ), ( "text", encodeTextValue t ) ]

        IntValueText intValue ->
            encodeIntValue intValue

        Label string ->
            E.string ("$" ++ string)


encodeStatement : Statement -> E.Value
encodeStatement statement =
    case statement of
        SetCounter textValue intValue ->
            E.object [ ( "setCounter", encodeTextValue textValue ), ( "value", encodeIntValue intValue ) ]

        SetLabel textValue value ->
            E.object [ ( "setLabel", encodeTextValue textValue ), ( "value", encodeTextValue value ) ]

        Rnd counter min max ->
            E.object [ ( "rnd", E.object [ ( "counter", encodeTextValue counter ), ( "min", encodeIntValue min ), ( "max", encodeIntValue max ) ] ) ]

        Block statements ->
            E.list encodeStatement statements

        If condition success failure ->
            E.object [ ( "if", E.object [ ( "condition", encodeCondition condition ), ( "success", encodeStatement success ), ( "failure", encodeStatement failure ) ] ) ]

        None ->
            E.null



-----------
--- Helpers
-----------


inc : String -> Statement
inc counter =
    SetCounter (S counter) (Addition (Counter counter) (Const 1))


example : Statement
example =
    Block
        [ Rnd (S "rnd_d6_1") (Const 1) (Const 6)
        , Rnd (S "rnd_d6_2") (Const 1) (Const 6)
        , SetCounter (S "rnd_2d6") (Addition (Counter "rnd_d6_1") (Counter "rnd_d6_2"))
        , SetCounter (S "player_attack") (Addition (Counter "rnd_2d6") (Counter "player_combat"))
        , SetCounter (S "player_damage") (Subtraction (Counter "player_attack") (Counter "enemy_defence"))
        , If (Predicate (Counter "player_damage") Gt (Const 0))
            (Block
                [ SetCounter (S "enemy_stamina") (Subtraction (Counter "enemy_stamina") (Counter "player_damage"))
                ]
            )
            None
        , If (Predicate (Counter "enemy_stamina") Gt (Const 0))
            (Block
                [ Rnd (S "rnd_d6_1") (Const 1) (Const 6)
                , Rnd (S "rnd_d6_2") (Const 1) (Const 6)
                , SetCounter (S "rnd_2d6") (Addition (Counter "rnd_d6_1") (Counter "rnd_d6_2"))
                , SetCounter (S "enemy_attack") (Addition (Counter "rnd_2d6") (Counter "enemy_combat"))
                , SetCounter (S "enemy_damage") (Subtraction (Counter "enemy_attack") (Counter "player_defence"))
                , If (Predicate (Counter "enemy_damage") Gt (Const 0))
                    (Block
                        [ SetCounter (S "player_stamina") (Subtraction (Counter "player_stamina") (Counter "enemy_damage"))
                        , If (Predicate (Counter "player_stamina") Lt (Const 1)) (SetCounter (S "fight_lost") (Const 1)) None
                        ]
                    )
                    None
                ]
            )
            (Block
                [ SetCounter (S "enemy_damage") (Const 0)
                , SetCounter (S "fight_won") (Const 1)
                , SetCounter (Label "enemy_marker") (Const 1)
                , SetCounter (Special [ S "test", Label "label", Conditional (Predicate (Counter "enemy_marker") Eq (Const 2)) (S "Success") ]) (Const 5)
                , SetCounter (Special [ S "prefix_", IntValueText (Counter "enemy_marker") ]) (Const 4)
                ]
            )
        ]


toParse : String
toParse =
    "($name_el + (23 - 3))"


toParse2 =
    "NOT (AND (NOT ((22 - 3) < $name_el), 1>0))"


parsedIntValue : Result (List Parser.DeadEnd) IntValue
parsedIntValue =
    Parser.run intValueParser toParse


parsedCondtion =
    Parser.run conditionParser toParse2


toParse3 =
    "[#enemy_marker, \"Janek\", ($enemy_marker==2?\"Success\"), str(12)]"


parsedTextValue =
    Parser.run textValueParser toParse3


parsed =
    parsedTextValue


intValueParser : Parser IntValue
intValueParser =
    Parser.oneOf
        [ Parser.succeed (\x fn y -> fn x y)
            |. Parser.symbol "("
            |= Parser.lazy (\_ -> intValueParser)
            |. Parser.spaces
            |= Parser.oneOf
                [ Parser.succeed Addition
                    |. Parser.symbol "+"
                , Parser.succeed Subtraction
                    |. Parser.symbol "-"
                ]
            |. Parser.spaces
            |= Parser.lazy (\_ -> intValueParser)
            |. Parser.symbol ")"
        , Parser.succeed Const
            |= Parser.int
        , Parser.succeed Counter
            |. Parser.symbol "$"
            |= Parser.getChompedString
                (Parser.succeed ()
                    |. Parser.chompIf (\c -> Char.isAlpha c || c == '_')
                    |. Parser.chompWhile (\c -> Char.isAlphaNum c || c == '_')
                )
        ]


conditionParser : Parser Condition
conditionParser =
    Parser.oneOf
        [ Parser.succeed Predicate
            |= intValueParser
            |. spaces
            |= Parser.oneOf
                [ Parser.succeed Eq |. Parser.symbol "=="
                , Parser.succeed Gt |. Parser.symbol ">"
                , Parser.succeed Lt |. Parser.symbol "<"
                ]
            |. spaces
            |= intValueParser
        , Parser.succeed NOT
            |. Parser.keyword "NOT"
            |. Parser.spaces
            |. Parser.symbol "("
            |= Parser.lazy (\_ -> conditionParser)
            |. Parser.spaces
            |. Parser.symbol ")"
        , Parser.succeed OR
            |. Parser.keyword "OR"
            |. Parser.spaces
            |= Parser.sequence
                { start = "("
                , separator = ","
                , end = ")"
                , spaces = spaces
                , item = Parser.lazy (\_ -> conditionParser)
                , trailing = Parser.Forbidden
                }
        , Parser.succeed AND
            |. Parser.keyword "AND"
            |. Parser.spaces
            |= Parser.sequence
                { start = "("
                , separator = ","
                , end = ")"
                , spaces = spaces
                , item = Parser.lazy (\_ -> conditionParser)
                , trailing = Parser.Forbidden
                }
        ]


textValueParser : Parser TextValue
textValueParser =
    Parser.oneOf
        [ Parser.succeed S
            |. Parser.symbol "\""
            |= (Parser.chompWhile (\c -> c /= '"') |> Parser.getChompedString)
            |. Parser.symbol "\""
        , Parser.succeed Special
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
            |= conditionParser
            |. Parser.symbol "?"
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
