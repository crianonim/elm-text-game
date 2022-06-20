module DialogGame exposing (..)

import Dict exposing (Dict)
import Random
import Screept exposing (IntValue(..), State, TextValue(..))
import Stack exposing (Stack)


type alias GameState =
    { counters : Dict String Int
    , labels : Dict String String
    , dialogStack : Stack DialogId
    , messages : List String
    , procedures : Dict String Screept.Statement
    , rnd : Random.Seed
    }


type alias GameConfig =
    { showMessages : Bool
    }



--
--nonZero : IntValue -> Condition
--nonZero gameValue =
--    NOT (zero gameValue)
--
--
--zero : IntValue -> Condition
--zero gameValue =
--    Predicate gameValue Eq (Const 0)


type alias DialogOption =
    { text : TextValue
    , condition : Maybe IntValue
    , action : List DialogActionExecution
    }


type DialogActionExecution
    = GoAction DialogId
    | GoBackAction
    | Message TextValue
    | Turn Int
    | DoNothing
    | Screept Screept.Statement
    | ConditionalAction IntValue DialogActionExecution DialogActionExecution
    | ActionBlock (List DialogActionExecution)


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


executeAction : DialogActionExecution -> GameState -> GameState
executeAction dialogActionExecution gameState =
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
            Screept.addCounter "turn" t gameState

        Screept statement ->
            Screept.runStatement statement gameState

        ConditionalAction condition success failure ->
            executeAction
                (if Screept.isTruthy condition gameState then
                    success

                 else
                    failure
                )
                gameState

        ActionBlock dialogActionExecutions ->
            List.foldl (\a state -> executeAction a state) gameState dialogActionExecutions


setRndSeed : Random.Seed -> GameState -> GameState
setRndSeed seed gameState =
    { gameState | rnd = seed }



--
--recipeToDialogOption : ( String, List ( String, Int ) ) -> DialogOption
--recipeToDialogOption ( crafted, ingredients ) =
--    let
--        ingredientToCondition : ( String, Int ) -> IntValue
--        ingredientToCondition ( item, amount ) =
--           Unary Screept.Not <| Binary (Counter item) Screept.Lt (Const amount)
--
--        ingredientToAction : ( String, Int ) -> DialogActionExecution
--        ingredientToAction ( item, amount ) =
--            Screept (Screept.SetCounter (S item) (Binary (Counter item) Screept.Add (Const -amount)))
--
--        ingredientToString : ( String, Int ) -> String
--        ingredientToString ( item, amount ) =
--            item ++ " " ++ String.fromInt amount
--
--        foldConditions = List.foldl () (True,) ingredients
--    in
--    { text = S <| "Craft " ++ crafted ++ " (" ++ String.join ", " (List.map ingredientToString ingredients) ++ ")"
--    , condition = Just <| Screept.Binary Screept.And (List.map ingredientToCondition ingredients)
--    , action = Screept (Screept.inc crafted) :: List.map ingredientToAction ingredients
--    }


badDialog : Dialog
badDialog =
    { id = "bad", text = S "BAD Dialog", options = [] }


runScreept : String -> DialogActionExecution
runScreept s =
    Screept <| Screept.run s
