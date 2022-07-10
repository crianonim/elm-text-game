module DialogGame exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Json.Decode as Json
import Json.Encode as E
import Parser
import Random
import Screept exposing (IntValue(..), State, TextValue(..))
import Stack exposing (Stack)


type alias GameState =
    {  dialogStack : Stack DialogId
    , messages : List String
    , procedures : Dict String Screept.Statement
    , functions : Dict String Screept.IntValue
    , rnd : Random.Seed
    , vars : Dict String Screept.Variable
    }


type alias Model =
    { gameState : GameState
    , statusLine : Maybe Screept.TextValue
    , dialogs : Dialogs
    }


type alias DialogOption =
    { text : TextValue
    , condition : Maybe IntValue
    , action : List DialogAction
    }


type Msg
    = ClickDialog (List DialogAction)


type alias GameDefinition =
    { title : String
    , dialogs : List Dialog
    , statusLine : Maybe Screept.TextValue
    , startDialogId : String

    , procedures : Dict String Screept.Statement
    , functions : Dict String Screept.IntValue
    , vars : Dict String Screept.Variable
    }


init : GameState -> Dialogs -> Maybe Screept.TextValue -> Model
init gs dialogs statusLine =
    { gameState = gs, statusLine = statusLine, dialogs = dialogs }


initSimple : Dialogs -> Model
initSimple dialogs =
    init emptyGameState dialogs Nothing


setStatusLine : Maybe Screept.TextValue -> Model -> Model
setStatusLine maybeTextValue model =
    { model | statusLine = maybeTextValue }


emptyGameState : GameState
emptyGameState =
    {  functions = Dict.empty
    , procedures = Dict.empty
    , messages = []
    , rnd = Random.initialSeed 666
    , dialogStack = Stack.initialise |> Stack.push "start"
    , vars = Dict.empty
    }


type DialogAction
    = GoAction DialogId
    | GoBackAction
    | Message TextValue
    | Screept Screept.Statement
    | ConditionalAction IntValue DialogAction DialogAction
    | ActionBlock (List DialogAction)
    | Exit String


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


executeAction : DialogAction -> GameState -> ( GameState, Maybe String )
executeAction dialogActionExecution gameState =
    case dialogActionExecution of
        GoAction dialogId ->
            ( { gameState | dialogStack = Stack.push dialogId gameState.dialogStack }, Nothing )

        GoBackAction ->
            ( { gameState | dialogStack = Tuple.second (Stack.pop gameState.dialogStack) }, Nothing )

        Message msg ->
            ( { gameState | messages = Screept.getText gameState msg :: gameState.messages }, Nothing )

        Screept statement ->
            ( Screept.runStatement statement gameState, Nothing )

        ConditionalAction condition success failure ->
            executeAction
                (if Screept.isTruthy condition gameState then
                    success

                 else
                    failure
                )
                gameState

        ActionBlock dialogActionExecutions ->
            List.foldl (\a ( state, _ ) -> executeAction a state) ( gameState, Nothing ) dialogActionExecutions

        Exit code ->
            ( gameState, Just code )


setRndSeed : Random.Seed -> Model -> Model
setRndSeed seed ({ gameState } as model) =
    { model | gameState = { gameState | rnd = seed } }


badDialog : Dialog
badDialog =
    { id = "bad", text = S "BAD Dialog", options = [] }


goBackOption : DialogOption
goBackOption =
    { text = S "Go back", condition = Nothing, action = [ GoBackAction ] }


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

        Exit s ->
            E.object [ ( "exit", E.string s ) ]


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
encodeGameDefinition { dialogs, startDialogId,  procedures, functions, statusLine } =
    E.object
        ([ ( "dialogs", E.list encodeDialog dialogs )
         , ( "startDialogId", E.string startDialogId )
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


decodeVariable : Json.Decoder Screept.Variable
decodeVariable =
    Json.oneOf
        [ Json.int |> Json.map (\x -> Screept.VInt <| Screept.Const x)
        , Json.string |> Json.map (\x -> Screept.VText <| Screept.S x)
        ]


decodeGameDefinition : Json.Decoder GameDefinition
decodeGameDefinition =
    Json.map7 GameDefinition
        (Json.field "name" Json.string)
        (Json.field "dialogs" decodeDialogs)
        (Json.field "statusLine" (Json.maybe (Json.string |> Json.map Screept.parseTextValue)))
        (Json.field "startDialogId" Json.string)
        (Json.field "procedures" <| Json.dict (Json.string |> Json.map Screept.parseStatement))
        (Json.field "functions" <| Json.dict (Json.string |> Json.map Screept.parseIntValue))
        (Json.field "vars" <| Json.dict decodeVariable)


update : Msg -> Model -> ( Model, Maybe String )
update msg model =
    case msg of
        ClickDialog actions ->
            let
                ( gs, code ) =
                    List.foldl (\a ( state, _ ) -> executeAction a state) ( model.gameState, Nothing ) actions
            in
            ( { model
                | gameState = gs
              }
            , code
            )


view : Model -> Html Msg
view { gameState, statusLine, dialogs } =
    let
        dialog =
            getDialog (Stack.top gameState.dialogStack |> Maybe.withDefault "bad") dialogs
    in
    div [ class "container" ]
        [ div [ class "dialog" ]
            [ Maybe.map (\t -> viewDialogText t gameState) statusLine |> Maybe.withDefault (text "")
            , viewDialogText dialog.text gameState
            , div [] <|
                List.map (viewOption gameState) (dialog.options |> List.filter (\o -> o.condition |> Maybe.map (\check -> Screept.isTruthy check gameState) |> Maybe.withDefault True))
            ]
        , if List.length gameState.messages > 0 then
            viewMessages gameState.messages

          else
            text ""
        , viewDebug gameState
        ]


viewMessages : List String -> Html msg
viewMessages msgs =
    div [ class "messages" ] <|
        List.map (\m -> p [ class "message" ] [ text m ]) msgs


viewDialog : Model -> Dialog -> Html Msg
viewDialog { gameState, statusLine } dialog =
    div [ class "dialog" ]
        [ Maybe.map (\t -> viewDialogText t gameState) statusLine |> Maybe.withDefault (text "")
        , viewDialogText dialog.text gameState
        , div [] <|
            List.map (viewOption gameState) (dialog.options |> List.filter (\o -> o.condition |> Maybe.map (\check -> Screept.isTruthy check gameState) |> Maybe.withDefault True))
        ]


viewDialogText : Screept.TextValue -> GameState -> Html msg
viewDialogText textValue gameState =
    div []
        (Screept.getText gameState textValue |> String.split "\n" |> List.map (\par -> p [] [ text par ]))


viewDebug : GameState -> Html a
viewDebug gameState =
    div [ class "status" ]
        [ text "Debug"
        , div [ style "display" "grid", style "grid-template-columns" "repeat(4,1fr)" ] (Dict.toList gameState.vars |> List.map (\( k, v ) -> div [] [ text <| k ++ ":" ++ Screept.stringifyVariable v ]))
        ]


viewOption : GameState -> DialogOption -> Html Msg
viewOption gameState dialogOption =
    div [ onClick <| ClickDialog dialogOption.action, class "option" ] [ text <| Screept.getText gameState dialogOption.text ]
