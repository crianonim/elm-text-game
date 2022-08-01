module DialogGame exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Json.Decode as Json
import Json.Encode as E
import Random
import ScreeptV2 exposing (Expression(..), Identifier(..), Statement, Value(..))
import Stack exposing (Stack)


type alias GameState =
    { dialogStack : Stack DialogId
    , messages : List String
    , screeptEnv : ScreeptV2.Environment
    }


type alias Model =
    { gameState : GameState
    , dialogs : Dialogs
    }


type alias DialogOption =
    { text : ScreeptV2.Expression
    , condition : Maybe ScreeptV2.Expression
    , actions : List DialogAction
    }


type Msg
    = ClickDialog (List DialogAction)


type alias GameDefinition =
    { title : String
    , dialogs : List Dialog
    , startDialogId : String
    , procedures : List ( String, Statement )
    , vars : Dict String Value
    }


init : GameState -> Dialogs -> Model
init gs dialogs =
    { gameState = gs, dialogs = dialogs }


initSimple : Dialogs -> Model
initSimple dialogs =
    init emptyGameState dialogs


emptyGameState : GameState
emptyGameState =
    { messages = []
    , dialogStack = Stack.initialise |> Stack.push "start"
    , screeptEnv = { vars = Dict.empty, procedures = Dict.empty, rnd = Random.initialSeed 666 }
    }


type DialogAction
    = GoAction DialogId
    | GoBackAction
    | Message Expression
    | Screept Statement
    | ConditionalAction Expression DialogAction DialogAction
    | ActionBlock (List DialogAction)
    | Exit String


type alias DialogId =
    String


type alias Dialog =
    { id : DialogId
    , text : Expression
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
            ( { gameState | messages = ScreeptV2.resolveExpressionToString gameState.screeptEnv msg :: gameState.messages }, Nothing )

        Screept statement ->
            let
                newScreeptEnv =
                    case ScreeptV2.executeStatement statement ( gameState.screeptEnv, [] ) of
                        -- TODO: rejecting the output
                        Ok ( s, _ ) ->
                            s

                        Err e ->
                            let
                                _ =
                                    Debug.log "SCREEPT_STATEMENT_ERROR" e
                            in
                            gameState.screeptEnv
            in
            ( { gameState
                | screeptEnv = newScreeptEnv
              }
            , Nothing
            )

        ConditionalAction condition success failure ->
            let
                isConditionMet =
                    ScreeptV2.evaluateExpression gameState.screeptEnv condition
                        |> Result.map ScreeptV2.isTruthy
                        |> Result.withDefault False
            in
            executeAction
                (if isConditionMet then
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
    let
        screeptEnv =
            gameState.screeptEnv
    in
    { model | gameState = { gameState | screeptEnv = { screeptEnv | rnd = seed } } }


badDialog : Dialog
badDialog =
    { id = "bad", text = Literal <| Text "BAD Dialog", options = [] }


goBackOption : DialogOption
goBackOption =
    { text = Literal <| Text "Go back", condition = Nothing, actions = [ GoBackAction ] }


encodeDialogAction : DialogAction -> E.Value
encodeDialogAction dialogAction =
    case dialogAction of
        GoAction dialogId ->
            E.object [ ( "go_dialog", E.string dialogId ) ]

        GoBackAction ->
            E.string "go_back"

        Message expression ->
            E.object [ ( "msg", E.string <| ScreeptV2.stringifyExpression expression ) ]

        Screept statement ->
            E.object [ ( "screept", E.string <| ScreeptV2.stringifyStatement statement ) ]

        ConditionalAction condition success failure ->
            E.object
                [ ( "if", E.string <| ScreeptV2.stringifyExpression condition )
                , ( "then", encodeDialogAction success )
                , ( "else", encodeDialogAction failure )
                ]

        ActionBlock dialogActions ->
            E.list encodeDialogAction dialogActions

        Exit s ->
            E.object [ ( "exit", E.string s ) ]


encodeDialogOption : DialogOption -> E.Value
encodeDialogOption { text, condition, actions } =
    E.object
        ([ ( "text", E.string <| ScreeptV2.stringifyExpression text )
         , ( "action", E.list encodeDialogAction actions )
         ]
            ++ (case condition of
                    Just a ->
                        [ ( "condition", E.string <| ScreeptV2.stringifyExpression a ) ]

                    Nothing ->
                        []
               )
        )


encodeDialog : Dialog -> E.Value
encodeDialog { id, text, options } =
    E.object
        [ ( "id", E.string id )
        , ( "text", E.string <| ScreeptV2.stringifyExpression text )
        , ( "options", E.list encodeDialogOption options )
        ]


encodeState : GameState -> E.Value
encodeState { dialogStack, messages, screeptEnv } =
    E.object
        [ ( "dialogStack", Stack.toList dialogStack |> E.list E.string )
        , ( "messages", E.list E.string messages )
        , ( "screeptEnv", ScreeptV2.encodeEnvironment screeptEnv )
        ]


decodeState : Json.Decoder GameState
decodeState =
    Json.map3 GameState
        (Json.succeed Stack.initialise)
        (Json.field "messages" <| Json.list Json.string)
        (Json.field "screeptEnv" ScreeptV2.decodeEnvironment)


encodeGameDefinition : GameDefinition -> E.Value
encodeGameDefinition { title, dialogs, startDialogId, vars, procedures } =
    E.object
        [ ( "name", E.string title )
        , ( "dialogs", E.list encodeDialog dialogs )
        , ( "startDialogId", E.string startDialogId )
        , ( "procedures", E.dict identity (ScreeptV2.stringifyStatement >> E.string) (Dict.fromList procedures) )
        , ( "vars", E.dict identity ScreeptV2.encodeValue vars )
        ]


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
        , Json.map Message (Json.field "msg" ScreeptV2.decodeExpression)
        , Json.map Screept (Json.field "screept" ScreeptV2.decodeStatement)
        , Json.map3 ConditionalAction
            (Json.field "if" ScreeptV2.decodeExpression)
            (Json.field "then" (Json.lazy (\_ -> decodeAction)))
            (Json.field "else" (Json.lazy (\_ -> decodeAction)))
        , Json.map ActionBlock <| Json.list (Json.lazy (\_ -> decodeAction))
        ]


decodeOption : Json.Decoder DialogOption
decodeOption =
    Json.map3 DialogOption
        (Json.field "text" ScreeptV2.decodeExpression)
        (Json.maybe <| Json.field "condition" ScreeptV2.decodeExpression)
        (Json.field "action" <| Json.list decodeAction)


decodeDialog : Json.Decoder Dialog
decodeDialog =
    Json.map3 Dialog
        (Json.field "id" Json.string)
        (Json.field "text" ScreeptV2.decodeExpression)
        (Json.field "options" <| Json.list decodeOption)


decodeDialogs : Json.Decoder (List Dialog)
decodeDialogs =
    Json.list decodeDialog


decodeGameDefinition : Json.Decoder GameDefinition
decodeGameDefinition =
    Json.map5 GameDefinition
        (Json.field "name" Json.string)
        (Json.field "dialogs" decodeDialogs)
        (Json.field "startDialogId" Json.string)
        (Json.field "procedures" <| Json.map Dict.toList <| Json.dict ScreeptV2.decodeStatement)
        (Json.field "vars" <| Json.dict ScreeptV2.decodeValue)


stringifyGameDefinition : GameDefinition -> String
stringifyGameDefinition gd =
    E.encode 2 (encodeGameDefinition gd)


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
view { gameState, dialogs } =
    let
        dialog =
            getDialog (Stack.top gameState.dialogStack |> Maybe.withDefault "bad") dialogs
    in
    div [ class "container" ]
        [ div [ class "dialog" ]
            [ if Dict.member "__statusLine" gameState.screeptEnv.vars then
                viewDialogText (FunctionCall (LiteralIdentifier "__statusLine") []) gameState

              else
                text ""
            , viewDialogText dialog.text gameState
            , let
                isVisible mCondition =
                    mCondition
                        |> Maybe.map
                            (\condition ->
                                ScreeptV2.evaluateExpression gameState.screeptEnv condition
                                    |> Result.map ScreeptV2.isTruthy
                                    |> Result.withDefault False
                            )
                        |> Maybe.withDefault True
              in
              div [] <|
                List.map (viewOption gameState) (dialog.options |> List.filter (\o -> isVisible o.condition))
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


viewDialogText : Expression -> GameState -> Html msg
viewDialogText expr gameState =
    let
        s =
            ScreeptV2.evaluateExpressionToString gameState.screeptEnv expr
    in
    div []
        (String.split "\n" s |> List.map (\par -> p [] [ text par ]))


viewDebug : GameState -> Html a
viewDebug gameState =
    div [ class "status" ]
        [ text "Debug"
        , div [ style "display" "grid", style "grid-template-columns" "repeat(4,1fr)" ] (Dict.toList gameState.screeptEnv.vars |> List.map (\( k, v ) -> div [] [ text <| k ++ ":" ++ ScreeptV2.stringifyValue v ]))
        ]


viewOption : GameState -> DialogOption -> Html Msg
viewOption gameState dialogOption =
    div [ onClick <| ClickDialog dialogOption.actions, class "option" ] [ text <| ScreeptV2.evaluateExpressionToString gameState.screeptEnv dialogOption.text ]
