port module Main exposing (main)

import Browser
import DialogGame exposing (..)
import DialogGameEditor
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Json
import Monocle.Compose exposing (lensWithPrism, optionalWithLens, prismWithLens)
import Monocle.Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import Monocle.Prism as Prism exposing (Prism)
import Platform.Cmd exposing (Cmd)
import Random
import ScreeptEditor
import ScreeptV2 exposing (BinaryOp(..), Expression(..), Identifier(..), TertiaryOp(..), Value(..))
import Shared exposing (lens_gameDefinition, lens_page)
import Stack exposing (Stack)
import Task


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { page : Page
    , gameDialog : GameStatus
    , isDebug : Bool

    --, dialogEditor : Maybe DialogGameEditor.Model
    , gameDefinition : Maybe GameDefinition
    , mainMenuDialog : DialogGame.Model
    , urlLoader : Maybe String
    }


type Page
    = MainMenuPage
    | GamePage GameStatus
    | DialogEditorPage DialogGameEditor.Model


type Msg
    = None
    | GameDialog DialogGame.Msg
    | SeedGenerated Random.Seed
    | DialogEditor DialogGameEditor.Msg
    | GotGameDefinition (Result Http.Error GameDefinition)
    | MainMenuDialog DialogGame.Msg
    | StartGame
    | StopGame
    | StartEditor
    | ShowUrlLoader
    | HideUrlLoader
    | EditUrlLoader String
    | ClickUrlLoader
    | SaveGameDefinition


init : () -> ( Model, Cmd Msg )
init _ =
    ( { page = MainMenuPage
      , gameDialog = NotLoaded
      , isDebug = True

      --, dialogEditor = Nothing
      , gameDefinition = Nothing
      , mainMenuDialog =
            DialogGame.initSimple mainMenuDialogs
      , urlLoader = Nothing
      }
    , Cmd.batch
        [ Random.generate SeedGenerated Random.independentSeed

        --, Http.get { url = "games/ts2.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        --, Http.get { url = "games/testsandbox.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        --, Http.get { url = "games/fabled.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        , askforGame ()
        ]
    )


mainMenuDialogs : Dialogs
mainMenuDialogs =
    DialogGame.listDialogToDictDialog
        [ { id = "start"
          , text = StandardLibrary "CONCAT" [ Literal <| Text "Main Menu. ", TertiaryExpression (Variable <| LiteralIdentifier "game_loaded") Conditional (Variable <| LiteralIdentifier "game_title") (Literal <| Text "No game loaded.") ]
          , options =
                [ { text = Literal <| Text "Load Game", condition = Nothing, actions = [ GoAction "load_game_definition" ] }
                , { text = Literal <| Text "Start Game", condition = Just (Variable <| LiteralIdentifier "game_loaded"), actions = [ GoAction "in_game", Exit "start_game" ] }
                , { text = Literal <| Text "Start Editor", condition = Nothing, actions = [ GoAction "editor", Exit "start_editor" ] }
                ]
          }
        , { id = "load_game_definition"
          , text = Literal <| Text "Load game definition"
          , options =
                [ { text = Literal <| Text "Load Sandbox", condition = Nothing, actions = [ Exit "sandbox" ] }
                , { text = Literal <| Text "Load Fabled Lands", condition = Nothing, actions = [ Exit "fabled" ] }
                , { text = Literal <| Text "Load from url", condition = Nothing, actions = [ Exit "load_url" ] }
                , DialogGame.goBackOption
                ]
          }
        , { id = "editor"
          , text = Literal <| Text "Dialog Editor"
          , options =
                [ { text = Literal <| Text "Restart", condition = Nothing, actions = [ Exit "start_game" ] }
                , { text = Literal <| Text "Stop game", condition = Nothing, actions = [ GoAction "start", Exit "stop_game" ] }
                ]
          }
        , { id = "in_game"
          , text = BinaryExpression (Literal <| Text "Playing: ") Add (Variable <| LiteralIdentifier "game_title")
          , options =
                [ { text = Literal <| Text "Restart", condition = Nothing, actions = [ Exit "start_game" ] }
                , { text = Literal <| Text "Stop game", condition = Nothing, actions = [ GoAction "start", Exit "stop_game" ] }
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

                "start_editor" ->
                    ( dialModel, Task.succeed StartEditor |> Task.perform identity )

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

        DialogEditor deMsg ->
            ( { model | page = Prism.modify prism_page_dialogEditorModel (DialogGameEditor.update deMsg) model.page }, Cmd.none )

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
                            ScreeptV2.executeStringStatement ("{ game_loaded = 1;  game_title = \"" ++ value.title ++ "\" }") m.gameState.screeptEnv

                        gameState =
                            m.gameState

                        newGameState =
                            { gameState | screeptEnv = newScreeptState }

                        menuDialog =
                            { m | gameState = newGameState }
                    in
                    ( { model | gameDialog = Loaded value, gameDefinition = Just value, mainMenuDialog = menuDialog, page = Prism.modify prism_page_dialogEditorModel (always <| DialogGameEditor.init value) model.page }
                    , Cmd.none
                    )

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

        SaveGameDefinition ->
            ( model, Maybe.map (stringifyGameDefinition >> saveGame) (model_dialogEditorGameDefinition.getOption model) |> Maybe.withDefault Cmd.none )

        StartEditor ->
            let
                gd =
                    model.gameDefinition |> Maybe.withDefault DialogGameEditor.emptyGameDefinition
            in
            ( { model | page = DialogEditorPage <| DialogGameEditor.init gd }, Cmd.none )


initGameFromGameDefinition : GameDefinition -> DialogGame.Model
initGameFromGameDefinition gameDefinition =
    { gameState =
        { --
          messages = []

        --, rnd = Random.initialSeed 666
        , dialogStack = Stack.initialise |> Stack.push gameDefinition.startDialogId
        , screeptEnv = { vars = gameDefinition.vars |> Dict.fromList, procedures = gameDefinition.procedures |> Dict.fromList, rnd = Random.initialSeed 666 }
        }
    , dialogs = listDialogToDictDialog gameDefinition.dialogs
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    loadGame (\s -> Json.decodeString decodeGameDefinition s |> Result.mapError (always <| Http.BadBody "bad body") |> GotGameDefinition)



-- OPTICS


model_dialogEditorGameDefinition : Optional Model GameDefinition
model_dialogEditorGameDefinition =
    lens_page
        |> lensWithPrism
            prism_page_dialogEditorModel
        |> optionalWithLens
            lens_gameDefinition



--
--model_dialogEditor : Optional Model DialogGameEditor.Model
--model_dialogEditor =
--    Optional .dialogEditor (\s m -> { m | dialogEditor = Just s })
--
--model_de_gameDefinition : Optional Model GameDefinition
--model_de_gameDefinition =
--    model_dialogEditor
--        |> Monocle.Compose.optionalWithLens DialogGameEditor.model_gameDefinition


prism_page_dialogEditorModel : Prism Page DialogGameEditor.Model
prism_page_dialogEditorModel =
    { getOption =
        \page ->
            case page of
                DialogEditorPage m ->
                    Just m

                _ ->
                    Nothing
    , reverseGet = DialogEditorPage
    }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "my-container" ]
        [ DialogGame.view model.mainMenuDialog |> Html.map MainMenuDialog
        , button [ onClick SaveGameDefinition ] [ text "Save to Localstorage" ]

        --, Maybe.map DialogGameEditor.view model.dialogEditor |> Maybe.withDefault (text "") |> Html.map DialogEditor
        , case model.page of
            MainMenuPage ->
                text "Main menu"

            GamePage gameStatus ->
                text "game"

            DialogEditorPage dialogEditorModel ->
                DialogGameEditor.view dialogEditorModel |> Html.map DialogEditor
        , case model.gameDialog of
            Started _ gameDialogMenu ->
                DialogGame.view gameDialogMenu |> Html.map GameDialog

            NotLoaded ->
                div [ class "dialog" ] [ text "No game definition loaded." ]

            Loading ->
                text "Loading..."

            Loaded m ->
                div [ class "dialog" ] [ text <| "Loaded game:  " ++ m.title ++ "." ]
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


port saveGame : String -> Cmd msg


port loadGame : (String -> msg) -> Sub msg


port askforGame : () -> Cmd msg
