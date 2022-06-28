module DialogGame exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json
import Json.Encode as E
import Parser
import Random
import Screept exposing (IntValue(..), State, TextValue(..))
import Stack exposing (Stack)


type alias GameState =
    { counters : Dict String Int
    , labels : Dict String String
    , dialogStack : Stack DialogId
    , messages : List String
    , procedures : Dict String Screept.Statement
    , functions : Dict String Screept.IntValue
    , rnd : Random.Seed
    }


type alias DialogOption =
    { text : TextValue
    , condition : Maybe IntValue
    , action : List DialogAction
    }


type alias GameDefinition =
    { dialogs : List Dialog
    , statusLine : Maybe Screept.TextValue
    , startDialogId : String
    , counters : Dict String Int
    , labels : Dict String String
    , procedures : Dict String Screept.Statement
    , functions : Dict String Screept.IntValue
    }


type DialogAction
    = GoAction DialogId
    | GoBackAction
    | Message TextValue
    | Screept Screept.Statement
    | ConditionalAction IntValue DialogAction DialogAction
    | ActionBlock (List DialogAction)


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


executeAction : DialogAction -> GameState -> GameState
executeAction dialogActionExecution gameState =
    case dialogActionExecution of
        GoAction dialogId ->
            { gameState | dialogStack = Stack.push dialogId gameState.dialogStack }

        GoBackAction ->
            { gameState | dialogStack = Tuple.second (Stack.pop gameState.dialogStack) }

        Message msg ->
            { gameState | messages = Screept.getText gameState msg :: gameState.messages }

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


badDialog : Dialog
badDialog =
    { id = "bad", text = S "BAD Dialog", options = [] }


runScreept : String -> DialogAction
runScreept s =
    Screept <| Screept.run s


encodeDialogAction : DialogAction -> E.Value
encodeDialogAction dialogAction =
    case dialogAction of
        GoAction dialogId ->
            E.object [ ( "go_dialog", E.string dialogId ) ]

        GoBackAction ->
            E.string "go_back"

        Message textValue ->
            E.object [ ( "msg", E.string <| Screept.textValueStringify textValue ) ]

        Screept statement ->
            E.object [ ( "screept", E.string <| Screept.statementStringify statement ) ]

        ConditionalAction intValue success failure ->
            E.object
                [ ( "if", E.string <| Screept.intValueStringify intValue )
                , ( "then", encodeDialogAction success )
                , ( "else", encodeDialogAction failure )
                ]

        ActionBlock dialogActions ->
            E.list encodeDialogAction dialogActions


encodeDialogOption : DialogOption -> E.Value
encodeDialogOption { text, condition, action } =
    E.object
        ([ ( "text", E.string <| Screept.textValueStringify text )
         , ( "action", E.list encodeDialogAction action )
         ]
            ++ (case condition of
                    Just a ->
                        [ ( "condition", E.string <| Screept.intValueStringify a ) ]

                    Nothing ->
                        []
               )
        )


encodeDialog : Dialog -> E.Value
encodeDialog { id, text, options } =
    E.object
        [ ( "id", E.string id )
        , ( "text", E.string <| Screept.textValueStringify text )
        , ( "options", E.list encodeDialogOption options )
        ]


stringifyGameDefinition : GameDefinition -> String
stringifyGameDefinition gd =
    E.encode 2 (encodeGameDefinition gd)


encodeGameDefinition : GameDefinition -> E.Value
encodeGameDefinition { dialogs, startDialogId, counters, labels, procedures, functions, statusLine } =
    E.object
        ([ ( "dialogs", E.list encodeDialog dialogs )
         , ( "startDialogId", E.string startDialogId )
         , ( "counters", E.dict identity E.int counters )
         , ( "labels", E.dict identity E.string labels )
         , ( "procedures", E.dict identity (Screept.statementStringify >> E.string) procedures )
         , ( "functions", E.dict identity (Screept.intValueStringify >> E.string) functions )
         ]
            ++ (case statusLine of
                    Nothing ->
                        []

                    Just x ->
                        [ ( "statusLine", Screept.textValueStringify x |> E.string ) ]
               )
        )


decodeAction : Json.Decoder DialogAction
decodeAction =
    Json.oneOf
        [ Json.map GoAction (Json.field "go_dialog" Json.string)
        , Json.string
            |> Json.andThen
                (\x ->
                    if x == "go_back" then
                        Json.succeed GoBackAction

                    else
                        Json.fail ""
                )
        , Json.map Message (Json.field "msg" (Json.string |> Json.map Screept.parseTextValue))
        , Json.map Screept (Json.field "screept" (Json.string |> Json.map Screept.parseStatement))
        , Json.map3 ConditionalAction
            (Json.field "if" (Json.string |> Json.map Screept.parseIntValue))
            (Json.field "then" (Json.lazy (\_ -> decodeAction)))
            (Json.field "else" (Json.lazy (\_ -> decodeAction)))
        , Json.map ActionBlock <| Json.list (Json.lazy (\_ -> decodeAction))
        ]


decodeOption : Json.Decoder DialogOption
decodeOption =
    Json.map3 DialogOption
        (Json.field "text" (Json.string |> Json.map Screept.parseTextValue))
        (Json.maybe <| Json.field "condition" (Json.string |> Json.map Screept.parseIntValue))
        (Json.field "action" <| Json.list decodeAction)


decodeDialog : Json.Decoder Dialog
decodeDialog =
    Json.map3 Dialog
        (Json.field "id" Json.string)
        (Json.field "text" (Json.string |> Json.map Screept.parseTextValue))
        (Json.field "options" <| Json.list decodeOption)


decodeDialogs : Json.Decoder (List Dialog)
decodeDialogs =
    Json.list decodeDialog


decodeGameDefinition : Json.Decoder GameDefinition
decodeGameDefinition =
    Json.map7 GameDefinition
        (Json.field "dialogs" decodeDialogs)
        (Json.field "statusLine" (Json.maybe (Json.string |> Json.map Screept.parseTextValue)))
        (Json.field "startDialogId" Json.string)
        (Json.field "counters" <| Json.dict Json.int)
        (Json.field "labels" <| Json.dict Json.string)
        (Json.field "procedures" <| Json.dict (Json.string |> Json.map Screept.parseStatement))
        (Json.field "functions" <| Json.dict (Json.string |> Json.map Screept.parseIntValue))
