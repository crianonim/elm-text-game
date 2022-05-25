module Game exposing (..)

import Dict exposing (Dict)


type alias GameState =
    { turn : Int
    , counters : Dict String Int
    }


type GameValue
    = Const Int
    | Counter String
    | Turn


type GameTest
    = EQ GameValue
    | GT GameValue
    | LT GameValue
    | NOT GameTest


type SpecialText
    = S String
    | GameValueText GameValue


type Text
    = Normal String
    | Special (List SpecialText)


getText : Text -> GameState -> String
getText text gameState =
    case text of
        Normal string ->
            string

        Special specialTexts ->
            List.map (getSpecialText gameState) specialTexts |> String.concat


getSpecialText : GameState -> SpecialText -> String
getSpecialText gameState specialText =
    case specialText of
        S string ->
            string

        GameValueText gameValue ->
            getGameValue gameValue gameState |> String.fromInt


getGameValue : GameValue -> GameState -> Int
getGameValue gameValue gameState =
    case gameValue of
        Const int ->
            int

        Counter counter ->
            Dict.get counter gameState.counters |> Maybe.withDefault 0

        Turn ->
            gameState.turn


exampleGameState : GameState
exampleGameState =
    { turn = 1, counters = exampleCounters }


testCondition : GameValue -> GameTest -> GameState -> Bool
testCondition gv counterTest gameState =
    let
        value =
            case gv of
                Const int ->
                    int

                Counter counter ->
                    Dict.get counter gameState.counters |> Maybe.withDefault 0

                Turn ->
                    gameState.turn
    in
    case counterTest of
        EQ v ->
            value == getGameValue v gameState

        GT v ->
            value > getGameValue v gameState

        LT v ->
            value < getGameValue v gameState

        NOT innerTest ->
            not <| testCondition gv innerTest gameState


exampleCounters : Dict String Int
exampleCounters =
    [ ( "raining", 0 ), ( "killed_dragon", 1 ), ( "money", 40 ), ( "wood", 3 ) ]
        |> Dict.fromList


inventoryType : Dict String String
inventoryType =
    [ ( "money", "Coins" ), ( "wood", "Wood" ) ]
        |> Dict.fromList


type alias GameCheck =
    GameState -> Bool


type alias DialogOption =
    { text : String
    , action : DialogAction
    }


type DialogAction
    = Go DialogId
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


dialogExamples : List Dialog
dialogExamples =
    [ { id = "start"
      , text = Special [ S "You're at start ", GameValueText <| Const 5, S " ", GameValueText <| Counter "killed_dragon", S ". You have ", GameValueText <| Counter "money", S " coins." ]
      , options = [ { text = "Go second", action = Go "second" }, { text = "Spend money", action = DoNothing } ]
      }
    , { id = "second", text = Normal "You're at second", options = [ { text = "Go start", action = Go "start" }, { text = "Go third", action = Go "third" } ] }
    , { id = "third", text = Normal "You're at third", options = [ { text = "Go start", action = Go "start" } ] }
    ]


badDialog : Dialog
badDialog =
    { id = "bad", text = Normal "BAD Dialog", options = [] }
