module Game exposing (..)

import Dict exposing (Dict)


type alias GameState =
    { turn : Int
    , counters : Dict String Int
    , inventory : Dict String Int
    }

type GameValue =
 Const Int
 | Counter String
 | Item String
 | Turn

type GameTest
    = EQ GameValue
    | GT GameValue
    | LT GameValue
    | NOT GameTest


getGameValue : GameValue -> GameState -> Int
getGameValue gameValue gameState =
    case gameValue of
        Const int ->
            int

        Counter counter ->
            Dict.get counter gameState.counters |> Maybe.withDefault 0

        Item item ->
             Dict.get item gameState.inventory |> Maybe.withDefault 0

        Turn ->
             gameState.turn


exampleGameState : GameState
exampleGameState =
    { turn = 1, counters = exampleCounters, inventory = exampleInventory }


testCondition : GameValue -> GameTest -> GameState -> Bool
testCondition gv counterTest gameState =
    let
        value = case gv of


            Const int ->
                int

            Counter counter ->
                Dict.get counter gameState.counters |> Maybe.withDefault 0

            Item item ->
                      Dict.get item gameState.inventory |> Maybe.withDefault 0


            Turn ->
                gameState.turn
    in
    case counterTest of
        EQ v ->
            value == getGameValue v gameState

        GT v ->
            value > getGameValue v gameState

        LT v ->
            value <getGameValue v gameState

        NOT innerTest ->
            not <| testCondition gv innerTest gameState


exampleCounters : Dict String Int
exampleCounters =
    [ ( "raining", 0 ), ( "killed_dragon", 1 ) ]
        |> Dict.fromList

exampleInventory : Dict String Int
exampleInventory =
    [ ( "money", 40 ), ( "wood", 3 ) ]
        |> Dict.fromList
type alias GameCheck =
    GameState -> Bool


isTurnGT10 : GameCheck
isTurnGT10 =
    .turn >> modBy 2 >> (==) 0


type alias DialogOption =
    { text : String
    , go : DialogId
    }


type alias DialogId =
    String


type alias Dialog =
    { id : DialogId
    , text : String
    , options : List DialogOption
    }


type alias Dialogs =
    Dict DialogId Dialog


dialogExamples : List Dialog
dialogExamples =
    [ { id = "start", text = "You're at start", options = [ { text = "Go second", go = "second" } ] }
    , { id = "second", text = "You're at second", options = [ { text = "Go start", go = "start" }, { text = "Go third", go = "third" } ] }
    , { id = "third", text = "You're at third", options = [ { text = "Go start", go = "start" } ] }
    ]


listDialogToDictDialog : List Dialog -> Dict DialogId Dialog
listDialogToDictDialog dialogs =
    dialogs
        |> List.map (\dial -> ( dial.id, dial ))
        |> Dict.fromList


badDialog : Dialog
badDialog =
    { id = "bad", text = "BAD Dialog", options = [] }


getDialog : DialogId -> Dialogs -> Dialog
getDialog dialogId dialogs =
    Dict.get dialogId dialogs |> Maybe.withDefault badDialog
