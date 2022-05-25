module Game exposing (..)

import Dict exposing (Dict)
import Stack exposing (Stack)


type alias GameState =
    { turn : Int
    , counters : Dict String Int
    , dialogStack : Stack DialogId
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

        Turn ->
            Just gameState.turn


addCounter : String -> Int -> GameState -> GameState
addCounter counter add gameState =
    { gameState | counters = Dict.update counter (\value -> Maybe.map (\v -> v + add) value) gameState.counters }


exampleGameState : GameState
exampleGameState =
    { turn = 1, counters = exampleCounters, dialogStack = Stack.push "start" Stack.initialise }


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
            value == getGameValueWithDefault v gameState

        GT v ->
            value > getGameValueWithDefault v gameState

        LT v ->
            value < getGameValueWithDefault v gameState

        NOT innerTest ->
            not <| testCondition gv innerTest gameState


inventoryType : Dict String String
inventoryType =
    [ ( "money", "Coins" ), ( "wood", "Wood" ) ]
        |> Dict.fromList


type alias GameCheck =
    GameState -> Bool


type alias DialogOption =
    { text : String
    , action : List DialogActionExecution
    }


type DialogActionExecution
    = GoAction DialogId
    | GoBackAction
    | Inc String GameValue
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


executeAction : DialogActionExecution -> GameState -> GameState
executeAction dialogActionExecution gameState =
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


dialogExamples : List Dialog
dialogExamples =
    [ { id = "start"
      , text = Special [ S "You're at start ", GameValueText <| Const 5, S " ", GameValueText <| Counter "killed_dragon", S ". You have ", GameValueText <| Counter "money", S " coins." ]
      , options = [ { text = "Go second", action = [ GoAction "second" ] }, { text = "Spend money", action = [ Inc "money" Turn, Inc "money" (Counter "wood"), GoAction "third" ] } ]
      }
    , { id = "second", text = Normal "You're at second", options = [ { text = "Go start", action = [ GoAction "start" ] }, { text = "Go third", action = [ GoAction "third" ] } ] }
    , { id = "third", text = Normal "You're at third", options = [ { text = "Go start", action = [ GoAction "start" ] } ] }
    ]


badDialog : Dialog
badDialog =
    { id = "bad", text = Normal "BAD Dialog", options = [] }


exampleCounters : Dict String Int
exampleCounters =
    [ ( "raining", 0 ), ( "killed_dragon", 1 ), ( "money", 40 ), ( "wood", 3 ) ]
        |> Dict.fromList
