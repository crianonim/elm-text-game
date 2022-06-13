module Game exposing (..)

import Dict exposing (Dict)
import Random
import Screept exposing (Condition(..), IntValue(..), PredicateOp(..), State, TextValue(..))
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


nonZero : IntValue -> Condition
nonZero gameValue =
    NOT (zero gameValue)


zero : IntValue -> Condition
zero gameValue =
    Predicate gameValue Eq (Const 0)


inc1 : String -> DialogActionExecution
inc1 counter =
    inc counter 1


inc : String -> Int -> DialogActionExecution
inc counter i =
    incCounter counter (Const i)


type alias DialogOption =
    { text : TextValue
    , condition : Maybe Condition
    , action : List DialogActionExecution
    }


type DialogActionExecution
    = GoAction DialogId
    | GoBackAction
    | Message TextValue
    | Turn Int
    | DoNothing
    | Screept Screept.Statement


type alias DialogId =
    String


type alias Dialog =
    { id : DialogId
    , text : TextValue
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

        DoNothing ->
            gameState

        Message msg ->
            { gameState | messages = Screept.getText gameState msg :: gameState.messages }

        Turn t ->
            let
                runTurn : Int -> GameState -> GameState
                runTurn left gs =
                    let
                        currentTurn =
                            Screept.getGameValueWithDefault (Counter "turn") gs
                    in
                    if left == 0 then
                        gs

                    else
                        runTurn (left - 1)
                            (turnCallback currentTurn gs
                                |> Screept.addCounter "turn" 1
                            )
            in
            runTurn t gameState

        Screept statement ->
            Screept.runStatement statement gameState


setRndSeed : Random.Seed -> GameState -> GameState
setRndSeed seed gameState =
    { gameState | rnd = seed }


recipeToDialogOption : ( String, List ( String, Int ) ) -> DialogOption
recipeToDialogOption ( crafted, ingredients ) =
    let
        ingredientToCondition : ( String, Int ) -> Condition
        ingredientToCondition ( item, amount ) =
            NOT <| Predicate (Counter item) Lt (Const amount)

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


rndInts : String -> Int -> Int -> DialogActionExecution
rndInts counter x y =
    Screept <| Screept.Rnd (S counter) (Const x) (Const y)


incCounter : String -> IntValue -> DialogActionExecution
incCounter counter intValue =
    Screept <| Screept.SetCounter (S counter) intValue
