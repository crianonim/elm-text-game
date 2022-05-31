module Game exposing (..)

import Dict exposing (Dict)
import Random
import Stack exposing (Stack)


type alias GameState =
    { counters : Dict String Int
    , dialogStack : Stack DialogId
    , messages : List String
    , rnd : Random.Seed
    }


type alias GameConfig =
    { turnCallback : Int -> GameState -> GameState
    , showMessages : Bool
    }


type GameValue
    = Const Int
    | Counter String


type Condition
    = Predicate GameValue PredicateOp GameValue
    | NOT Condition
    | AND (List Condition)
    | OR (List Condition)


type PredicateOp
    = EQ
    | GT
    | LT


nonZero : GameValue -> Condition
nonZero gameValue =
    NOT (zero gameValue)


zero : GameValue -> Condition
zero gameValue =
    Predicate gameValue EQ (Const 0)


inc1 : String -> DialogActionExecution
inc1 counter =
    inc counter 1


inc : String -> Int -> DialogActionExecution
inc counter i =
    Inc counter (Const i)


type Text
    = S String
    | Special (List Text)
    | Conditional Condition Text
    | GameValueText GameValue


getText : GameState -> Text -> String
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


getGameValueWithDefault : GameValue -> GameState -> Int
getGameValueWithDefault gameValue gameState =
    getMaybeGameValue gameValue gameState |> Maybe.withDefault 0


getMaybeGameValue : GameValue -> GameState -> Maybe Int
getMaybeGameValue gameValue gameState =
    case gameValue of
        Const int ->
            Just int

        Counter counter ->
            Dict.get counter gameState.counters


addCounter : String -> Int -> GameState -> GameState
addCounter counter add gameState =
    { gameState | counters = Dict.update counter (\value -> Maybe.map (\v -> v + add) value) gameState.counters }


setCounter : String -> Int -> GameState -> GameState
setCounter counter x gameState =
    { gameState | counters = Dict.insert counter x gameState.counters }


testCondition : Condition -> GameState -> Bool
testCondition condition gameState =
    let
        testPredicate : GameValue -> PredicateOp -> GameValue -> Bool
        testPredicate x predicate y =
            let
                comp =
                    case predicate of
                        LT ->
                            (<)

                        EQ ->
                            (==)

                        GT ->
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


type alias DialogOption =
    { text : Text
    , condition : Maybe Condition
    , action : List DialogActionExecution
    }


type DialogActionExecution
    = GoAction DialogId
    | GoBackAction
    | Inc String GameValue
    | Message Text
    | Turn Int
    | Rnd String Int Int
    | DoNothing


type alias DialogId =
    String


type alias Dialog =
    { id : DialogId
    , text : Text
    , options : List DialogOption
    }


type alias Dialogs =
    Dict DialogId Dialog


listDialogToDictDialog : List Dialog -> Dict DialogId Dialog
listDialogToDictDialog dialogs =
    dialogs
        |> List.map (\dial -> ( dial.id, dial ))
        |> Dict.fromList


getDialog : DialogId -> Dialogs -> Dialog
getDialog dialogId dialogs =
    Dict.get dialogId dialogs |> Maybe.withDefault badDialog


executeAction : (Int -> GameState -> GameState) -> DialogActionExecution -> GameState -> GameState
executeAction turnCallback dialogActionExecution gameState =
    case dialogActionExecution of
        GoAction dialogId ->
            { gameState | dialogStack = Stack.push dialogId gameState.dialogStack }

        GoBackAction ->
            { gameState | dialogStack = Tuple.second (Stack.pop gameState.dialogStack) }

        Inc counter gv ->
            getMaybeGameValue gv gameState
                |> Maybe.map (\amount -> addCounter counter amount gameState)
                |> Maybe.withDefault gameState

        DoNothing ->
            gameState

        Message msg ->
            { gameState | messages = getText gameState msg :: gameState.messages }

        Turn t ->
            let
                runTurn : Int -> GameState -> GameState
                runTurn left gs =
                    let
                        currentTurn =
                            getGameValueWithDefault (Counter "turn") gs
                    in
                    if left == 0 then
                        gs

                    else
                        runTurn (left - 1)
                            (turnCallback currentTurn gs
                                |> addCounter "turn" 1
                            )
            in
            runTurn t gameState

        Rnd counter x y ->
            let
                ( result, newSeed ) =
                    Random.step (Random.int x y) gameState.rnd

                newState =
                    { gameState | rnd = newSeed }
            in
            setCounter counter result newState


setRndSeed : Random.Seed -> GameState -> GameState
setRndSeed seed gameState =
    { gameState | rnd = seed }


recipeToDialogOption : ( String, List ( String, Int ) ) -> DialogOption
recipeToDialogOption ( crafted, ingredients ) =
    let
        ingredientToCondition : ( String, Int ) -> Condition
        ingredientToCondition ( item, amount ) =
            NOT <| Predicate (Counter item) LT (Const amount)

        ingredientToAction : ( String, Int ) -> DialogActionExecution
        ingredientToAction ( item, amount ) =
            inc item (0 - amount)

        ingredientToString : ( String, Int ) -> String
        ingredientToString ( item, amount ) =
            item ++ " " ++ String.fromInt amount
    in
    { text = S <| "Craft " ++ crafted ++ " (" ++ String.join ", " (List.map ingredientToString ingredients) ++ ")"
    , condition = Just <| AND (List.map ingredientToCondition ingredients)
    , action = inc crafted 1 :: List.map ingredientToAction ingredients
    }


badDialog : Dialog
badDialog =
    { id = "bad", text = S "BAD Dialog", options = [] }
