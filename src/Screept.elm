module Screept exposing (..)

import Dict exposing (Dict)
import Random


type IntValue
    = Const Int
    | Counter String
    | Addition IntValue IntValue


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
    | GameValueText IntValue


type Statement
    = SetCounter TextValue IntValue
    | Rnd TextValue IntValue IntValue
    | Block (List Statement)
    | If Condition Statement Statement


runStatement : Statement -> State a -> State a
runStatement statement state =
    case statement of
        SetCounter textValue intValue ->
            getMaybeGameValue intValue state
                |> Maybe.map (\v -> setCounter (getText state textValue) v state)
                |> Maybe.withDefault state

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
                (getMaybeGameValue mx state)
                (getMaybeGameValue my state)
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


type alias State a =
    { a | counters : Dict String Int, rnd : Random.Seed }


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

        GameValueText gameValue ->
            getGameValueWithDefault gameValue gameState |> String.fromInt


getGameValueWithDefault : IntValue -> State a -> Int
getGameValueWithDefault gameValue gameState =
    getMaybeGameValue gameValue gameState |> Maybe.withDefault 0


getMaybeGameValue : IntValue -> State a -> Maybe Int
getMaybeGameValue gameValue gameState =
    case gameValue of
        Const int ->
            Just int

        Counter counter ->
            Dict.get counter gameState.counters

        Addition mx my ->
            Maybe.map2 (\x y -> x + y) (getMaybeGameValue mx gameState) (getMaybeGameValue my gameState)


addCounter : String -> Int -> State a -> State a
addCounter counter add gameState =
    { gameState | counters = Dict.update counter (\value -> Maybe.map (\v -> v + add) value) gameState.counters }


setCounter : String -> Int -> State a -> State a
setCounter counter x gameState =
    { gameState | counters = Dict.insert counter x gameState.counters }


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
            Maybe.map2 comp (getMaybeGameValue x gameState) (getMaybeGameValue y gameState)
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
