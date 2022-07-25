module Main exposing (main)

--import DialogGameEditor
--import Screept

import Browser
import DialogGame exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Http
import Platform.Cmd exposing (Cmd)
import Random
import ScreeptEditor
import ScreeptV2 exposing (BinaryOp(..), Expression(..), Identifier(..), Value(..))
import Stack exposing (Stack)
import Task


main : Program () Model Msg
main =
    let
        _ =
            Debug.log "Stat Exec "
                (ScreeptV2.parseStatementExample
                    |> (\e ->
                            case e of
                                Err _ ->
                                    Err ScreeptV2.UnimplementedYet

                                Ok v ->
                                    ScreeptV2.executeStatement v ( ScreeptV2.exampleScreeptState, [] )
                       )
                )

        _ =
            Debug.log "STAT" ScreeptV2.runExample

        _ =
            Debug.log "Statement Parse" ScreeptV2.parseStatementExample

        _ =
            Debug.log "S2 Parse" ScreeptV2.newScreeptParseExample

        _ =
            Debug.log "S2 Eval "
                (ScreeptV2.newScreeptParseExample
                    |> (\e ->
                            case e of
                                Err _ ->
                                    Err ScreeptV2.UnimplementedYet

                                Ok v ->
                                    ScreeptV2.evaluateExpression ScreeptV2.exampleScreeptState v
                       )
                )
    in
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { gameDialog = NotLoaded

      --DialogGame.init
      --    { counters = Game.counters
      --    , labels = Game.labels
      --    , dialogStack = Stack.push Game.initialDialogId Stack.initialise
      --    , procedures = Game.procedures
      --    , functions = Game.functions
      --    , messages = []
      --    , rnd = Random.initialSeed 666
      --    }
      --    (listDialogToDictDialog Game.dialogs)
      --    (Just Game.statusLine)
      , isDebug = True
      , screeptEditor = ScreeptEditor.init

      --, dialogEditor = DialogGameEditor.init
      , gameDefinition = Nothing
      , mainMenuDialog =
            DialogGame.initSimple mainMenuDialogs

      --|> DialogGame.setStatusLine (Just (Screept.Conditional (Screept.parseIntValue "$game_loaded") (Screept.Concat [ Screept.S "Loaded game: ", Screept.Label "game_title" ]) (Screept.S "No game definition loaded.")))
      , urlLoader = Nothing
      }
    , Cmd.batch
        [ Random.generate SeedGenerated Random.independentSeed

        --, Http.get { url = "games/ts2.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        --, Http.get { url = "games/testsandbox.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        , Http.get { url = "games/fabled.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        ]
    )


mainMenuDialogs : Dialogs
mainMenuDialogs =
    DialogGame.listDialogToDictDialog
        [ { id = "start"
          , text = Literal <| Text "Main Menu"
          , options =
                [ { text = Literal <| Text "Load Game", condition = Nothing, action = [ GoAction "load_game_definition" ] }
                , { text = Literal <| Text "Start Game", condition = Just (Variable <| LiteralIdentifier "game_loaded"), action = [ GoAction "in_game", Exit "start_game" ] }
                ]
          }
        , { id = "load_game_definition"
          , text = Literal <| Text "Load game definition"
          , options =
                [ { text = Literal <| Text "Load Sandbox", condition = Nothing, action = [ Exit "sandbox" ] }
                , { text = Literal <| Text "Load Fabled Lands", condition = Nothing, action = [ Exit "fabled" ] }
                , { text = Literal <| Text "Load from url", condition = Nothing, action = [ Exit "load_url" ] }
                , DialogGame.goBackOption
                ]
          }
        , { id = "in_game"
          , text = BinaryExpression (Literal <| Text "Playing: ") Add (Variable <| LiteralIdentifier "game_title")
          , options =
                [ { text = Literal <| Text "Restart", condition = Nothing, action = [ Exit "start_game" ] }
                , { text = Literal <| Text "Stop game", condition = Nothing, action = [ GoAction "start", Exit "stop_game" ] }
                ]
          }
        ]


mainMenuActions : DialogGame.Model -> Maybe String -> ( DialogGame.Model, Cmd Msg )
mainMenuActions dialModel mcode =
    case mcode of
        Nothing ->
            ( dialModel, Cmd.none )

        Just code ->
            case code of
                "sandbox" ->
                    ( dialModel, Http.get { url = "games/testsandbox.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition } )

                "fabled" ->
                    ( dialModel, Http.get { url = "games/fabled.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition } )

                "start_game" ->
                    ( dialModel, Task.succeed StartGame |> Task.perform identity )

                "stop_game" ->
                    ( dialModel, Task.succeed StopGame |> Task.perform identity )

                "load_url" ->
                    ( dialModel, Task.succeed ShowUrlLoader |> Task.perform identity )

                _ ->
                    ( dialModel, Cmd.none )


type GameStatus
    = NotLoaded
    | Loading
    | Loaded GameDefinition
    | Started GameDefinition DialogGame.Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        GameDialog gdm ->
            case model.gameDialog of
                Started gamedef gameDialogModel ->
                    let
                        ( gdModel, exitCode ) =
                            DialogGame.update gdm gameDialogModel
                    in
                    ( { model | gameDialog = Started gamedef gdModel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        SeedGenerated seed ->
            case model.gameDialog of
                Started gamedef gameDialogModel ->
                    ( { model | gameDialog = Started gamedef <| DialogGame.setRndSeed seed gameDialogModel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ScreeptEditor seMsg ->
            ( { model | screeptEditor = ScreeptEditor.update seMsg model.screeptEditor }, Cmd.none )

        --DialogEditor deMsg ->
        --    ( { model | dialogEditor = DialogGameEditor.update deMsg model.dialogEditor }, Cmd.none )
        GotGameDefinition result ->
            case result of
                Err e ->
                    let
                        _ =
                            Debug.log "Error" e
                    in
                    ( model, Cmd.none )

                Ok value ->
                    let
                        _ =
                            Debug.log "Success decode" value.dialogs

                        m =
                            model.mainMenuDialog

                        ( newScreeptState, _ ) =
                            ScreeptV2.executeStringStatement ("{ game_loaded = 1;  game_title = \"" ++ value.title ++ "\" }") m.gameState.screeptState

                        gameState =
                            m.gameState

                        newGameState =
                            { gameState | screeptState = newScreeptState }

                        menuDialog =
                            { m | gameState = newGameState }
                    in
                    ( { model | gameDialog = Loaded value, mainMenuDialog = menuDialog }, Cmd.none )

        MainMenuDialog menuMsg ->
            let
                ( menuModel, exitCode ) =
                    DialogGame.update menuMsg model.mainMenuDialog

                ( newMenuModel, cmd ) =
                    mainMenuActions menuModel exitCode
            in
            ( { model | mainMenuDialog = newMenuModel }, cmd )

        StartGame ->
            let
                gameDialog gameDefinition =
                    let
                        m =
                            initGameFromGameDefinition gameDefinition
                    in
                    Started gameDefinition m
            in
            case model.gameDialog of
                NotLoaded ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                Loaded gameDefinition ->
                    ( { model
                        | gameDialog = gameDialog gameDefinition
                      }
                    , Random.generate SeedGenerated Random.independentSeed
                    )

                Started gameDefinition _ ->
                    ( { model | gameDialog = gameDialog gameDefinition }, Random.generate SeedGenerated Random.independentSeed )

        StopGame ->
            case model.gameDialog of
                Started gd m ->
                    ( { model | gameDialog = Loaded gd }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ShowUrlLoader ->
            ( { model | urlLoader = Just "" }, Cmd.none )

        HideUrlLoader ->
            ( { model | urlLoader = Nothing }, Cmd.none )

        EditUrlLoader v ->
            let
                urlModel =
                    Maybe.map (always v) model.urlLoader
            in
            ( { model | urlLoader = urlModel }, Cmd.none )

        ClickUrlLoader ->
            case model.urlLoader of
                Just urlLoader ->
                    let
                        _ =
                            Debug.log "URL" urlLoader
                    in
                    ( { model | urlLoader = Nothing }, Http.get { url = urlLoader, expect = Http.expectJson GotGameDefinition decodeGameDefinition } )

                Nothing ->
                    ( model, Cmd.none )


type alias Model =
    { gameDialog : GameStatus
    , isDebug : Bool
    , screeptEditor : ScreeptEditor.Model

    --, dialogEditor : DialogGameEditor.Model
    , gameDefinition : Maybe GameDefinition
    , mainMenuDialog : DialogGame.Model
    , urlLoader : Maybe String
    }


type Msg
    = None
    | GameDialog DialogGame.Msg
    | SeedGenerated Random.Seed
    | ScreeptEditor ScreeptEditor.Msg
      --| DialogEditor DialogGameEditor.Msg
    | GotGameDefinition (Result Http.Error GameDefinition)
    | MainMenuDialog DialogGame.Msg
    | StartGame
    | StopGame
    | ShowUrlLoader
    | HideUrlLoader
    | EditUrlLoader String
    | ClickUrlLoader


initGameFromGameDefinition : GameDefinition -> DialogGame.Model
initGameFromGameDefinition gameDefinition =
    { gameState =
        { --
          messages = []

        --, rnd = Random.initialSeed 666
        , dialogStack = Stack.initialise |> Stack.push gameDefinition.startDialogId
        , screeptState = { vars = gameDefinition.vars, procedures = gameDefinition.procedures, rnd = Random.initialSeed 666 }
        }
    , dialogs = listDialogToDictDialog gameDefinition.dialogs
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ --DialogGameEditor.viewDialog model.dialogEditor |> Html.map DialogEditor
          DialogGame.view model.mainMenuDialog |> Html.map MainMenuDialog
        , case model.gameDialog of
            Started _ gameDialogMenu ->
                DialogGame.view gameDialogMenu |> Html.map GameDialog

            NotLoaded ->
                div [ class "dialog" ] [ text "No game definition loaded." ]

            Loading ->
                text "Loading..."

            Loaded m ->
                div [ class "dialog" ] [ text <| "Loaded game:  " ++ m.title ++ "." ]
        , ScreeptEditor.view model.screeptEditor |> Html.map ScreeptEditor

        --, textarea [] [ text <| stringifyGameDefinition (GameDefinition (model.dialogs |> Dict.values) model.statusLine Game.initialDialogId model.gameState.counters model.gameState.labels model.gameState.procedures model.gameState.functions) ]
        --, ScreeptEditor.viewStatement ScreeptEditor.init.screept
        , viewUrlLoader model
        ]


viewUrlLoader : Model -> Html Msg
viewUrlLoader model =
    case model.urlLoader of
        Just urlLoader ->
            div []
                [ input [ value urlLoader, onInput EditUrlLoader ] []
                , button [ onClick ClickUrlLoader ] [ text "Load" ]
                , button [ onClick HideUrlLoader ] [ text "Cancel" ]
                ]

        Nothing ->
            text ""
