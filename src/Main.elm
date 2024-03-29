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
    , isDebug : Bool
    , gameDefinition : Maybe GameDefinition
    , mainMenuDialog : DialogGame.Model
    , urlLoader : Maybe String
    }


type Page
    = MainMenuPage
    | GamePage DialogGame.Model
    | DialogEditorPage DialogGameEditor.Model


type Msg
    = None
    | GameDialog DialogGame.Msg
    | SeedGenerated Random.Seed
    | DialogEditor DialogGameEditor.Msg
    | GotGameDefinition (Result Http.Error GameDefinition)
    | MainMenuDialog DialogGame.Msg
    | StartGame
    | GotoMainMenu
    | StartEditor
    | ShowUrlLoader
    | HideUrlLoader
    | EditUrlLoader String
    | ClickUrlLoader
    | SaveGameDefinition


init : () -> ( Model, Cmd Msg )
init _ =
    ( { page = MainMenuPage
      , isDebug = True
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
        --, askforGame ()
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
                , { text = Literal <| Text "Load from localStorage", condition = Nothing, actions = [ Exit "load_localStorage" ] }
                , DialogGame.goBackOption
                ]
          }
        , { id = "save_game_definition"
          , text = Literal <| Text "Save game definition"
          , options =
                [ { text = Literal <| Text "Save to localStorage", condition = Nothing, actions = [ Exit "save_game_definition_localStorage" ] }
                , DialogGame.goBackOption
                ]
          }
        , { id = "editor"
          , text = Literal <| Text "Dialog Editor"
          , options =
                [ { text = Literal <| Text "Load GameDefinition", condition = Nothing, actions = [ GoAction "load_game_definition" ] }
                , { text = Literal <| Text "Save GameDefinition", condition = Nothing, actions = [ GoAction "save_game_definition" ] }
                , { text = Literal <| Text "New GameDefinition", condition = Nothing, actions = [ Exit "new_game_definition" ] }
                , { text = Literal <| Text "Go back", condition = Nothing, actions = [ GoBackAction, Exit "goto_main" ] }
                ]
          }
        , { id = "in_game"
          , text = BinaryExpression (Literal <| Text "Playing: ") Add (Variable <| LiteralIdentifier "game_title")
          , options =
                [ { text = Literal <| Text "Restart", condition = Nothing, actions = [ Exit "start_game" ] }
                , { text = Literal <| Text "Stop game", condition = Nothing, actions = [ GoAction "start", Exit "goto_main" ] }
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

                "goto_main" ->
                    ( dialModel, Task.succeed GotoMainMenu |> Task.perform identity )

                "load_url" ->
                    ( dialModel, Task.succeed ShowUrlLoader |> Task.perform identity )

                "start_editor" ->
                    ( dialModel, Task.succeed StartEditor |> Task.perform identity )

                "new_game_definition" ->
                    ( dialModel, Task.succeed (GotGameDefinition (Ok DialogGameEditor.emptyGameDefinition)) |> Task.perform identity )

                "load_localStorage" ->
                    ( dialModel, askforGame () )

                "save_game_definition_localStorage" ->
                    ( dialModel, Task.succeed SaveGameDefinition |> Task.perform identity )

                _ ->
                    ( dialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        GameDialog gdm ->
            ( Optional.modify model_gameModel
                (DialogGame.update gdm >> Tuple.first)
                model
            , Cmd.none
            )

        SeedGenerated seed ->
            ( Optional.modify model_gameModel (DialogGame.setRndSeed seed) model, Cmd.none )

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
                    ( loadedGame model value, Cmd.none )

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
                gd =
                    model.gameDefinition |> Maybe.withDefault DialogGameEditor.emptyGameDefinition
            in
            ( { model | page = GamePage (initGameFromGameDefinition gd) }
            , Random.generate SeedGenerated Random.independentSeed
            )

        GotoMainMenu ->
            ( { model | page = MainMenuPage }, Cmd.none )

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

                newModel =
                    case model.gameDefinition of
                        Nothing ->
                            loadedGame model DialogGameEditor.emptyGameDefinition

                        Just _ ->
                            model
            in
            ( { newModel | page = DialogEditorPage <| DialogGameEditor.init gd }, Cmd.none )


initGameFromGameDefinition : GameDefinition -> DialogGame.Model
initGameFromGameDefinition gameDefinition =
    { gameState =
        { --
          messages = []
        , dialogStack = Stack.initialise |> Stack.push gameDefinition.startDialogId
        , screeptEnv = { vars = gameDefinition.vars |> Dict.fromList, procedures = gameDefinition.procedures |> Dict.fromList, rnd = Random.initialSeed 666 }
        }
    , dialogs = listDialogToDictDialog gameDefinition.dialogs
    }


loadedGame : Model -> GameDefinition -> Model
loadedGame model value =
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
    { model | gameDefinition = Just value, mainMenuDialog = menuDialog, page = Prism.modify prism_page_dialogEditorModel (always <| DialogGameEditor.init value) model.page }



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


prism_page_game : Prism Page DialogGame.Model
prism_page_game =
    { getOption =
        \page ->
            case page of
                GamePage m ->
                    Just m

                _ ->
                    Nothing
    , reverseGet = GamePage
    }


model_gameModel : Optional Model DialogGame.Model
model_gameModel =
    lens_page
        |> lensWithPrism prism_page_game



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "my-container" ]
        [ DialogGame.view model.mainMenuDialog |> Html.map MainMenuDialog
        , case model.page of
            MainMenuPage ->
                text ""

            GamePage gameModel ->
                DialogGame.view gameModel |> Html.map GameDialog

            DialogEditorPage dialogEditorModel ->
                DialogGameEditor.view dialogEditorModel |> Html.map DialogEditor
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
