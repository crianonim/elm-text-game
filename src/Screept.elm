module Screept exposing (..)

import Dict exposing (Dict)
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
    | GameValueText IntValue
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

        GameValueText gameValue ->
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
--- Helpers
-----------


inc : String -> Statement
inc counter =
    SetCounter (S counter) (Addition (Counter counter) (Const 1))
