module Main exposing (main)

--import Games.TestSanbox as Game
--import Games.FabledLands as Game

import Browser
import DialogGame exposing (..)
import DialogGameEditor
import Dict
import Games.UnderSeaGame as Game
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Http
import Platform.Cmd exposing (Cmd)
import Random
import Screept
import ScreeptEditor
import Stack exposing (Stack)
import Task


main : Program () Model Msg
main =
    --let
    --    _ =
    --        Debug.log "MAN" (List.map stringifyGameDefinition Game.dialogs)
    --in
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
      , dialogEditor = DialogGameEditor.init
      , gameDefinition = Nothing
      , mainMenuDialog = DialogGame.initSimple mainMenuDialogs
      }
    , Cmd.batch
        [ Random.generate SeedGenerated Random.independentSeed

        --, Http.get { url = "/games/fabled.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        ]
    )


yesNoDialogs : Dialogs
yesNoDialogs =
    DialogGame.listDialogToDictDialog
        [ { id = "start"
          , text = Screept.S "Do you want to quit?"
          , options =
                [ { text = Screept.S "Yes", condition = Nothing, action = [ Exit "yes" ] }
                , { text = Screept.S "No", condition = Nothing, action = [ Message <| Screept.S "you pressed No" ] }
                ]
          }
        ]


mainMenuDialogs : Dialogs
mainMenuDialogs =
    DialogGame.listDialogToDictDialog
        [ { id = "start"
          , text = Screept.S "Main Menu"
          , options =
                [ { text = Screept.S "Load Game", condition = Nothing, action = [ GoAction "load_game_definition" ] }
                , { text = Screept.S "Start Game", condition = Just (Screept.parseIntValue "$game_loaded"), action = [ Exit "start_game" ] }
                ]
          }
        , { id = "load_game_definition"
          , text = Screept.S "Games"
          , options =
                [ { text = Screept.S "Load Sandbox", condition = Nothing, action = [ Exit "sandbox" ] }
                , { text = Screept.S "Load Fabled", condition = Nothing, action = [ Exit "fabled" ] }
                , DialogGame.goBackOption
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
                    ( dialModel, Http.get { url = "/games/testsandbox.json", expect = Http.expectJson (GotGameDefinition "Sandbox") decodeGameDefinition } )

                "fabled" ->
                    ( dialModel, Http.get { url = "/games/fabled.json", expect = Http.expectJson (GotGameDefinition "Fabled") decodeGameDefinition } )

                "start_game" ->
                    ( dialModel, Task.succeed StartGame |> Task.perform identity )

                _ ->
                    ( dialModel, Cmd.none )


type GameStatus
    = NotLoaded
    | Loading
    | Loaded String GameDefinition
    | Started String GameDefinition DialogGame.Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        GameDialog gdm ->
            case model.gameDialog of
                Started title gamedef gameDialogModel ->
                    let
                        ( gdModel, exitCode ) =
                            DialogGame.update gdm gameDialogModel
                    in
                    ( { model | gameDialog = Started title gamedef gdModel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        SeedGenerated seed ->
            case model.gameDialog of
                Started title gamedef gameDialogModel ->
                    ( { model | gameDialog = Started title gamedef <| DialogGame.setRndSeed seed gameDialogModel }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ScreeptEditor seMsg ->
            ( { model | screeptEditor = ScreeptEditor.update seMsg model.screeptEditor }, Cmd.none )

        DialogEditor deMsg ->
            ( { model | dialogEditor = DialogGameEditor.update deMsg model.dialogEditor }, Cmd.none )

        GotGameDefinition title result ->
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
                            Debug.log "Success decode" value

                        m =
                            model.mainMenuDialog

                        menuDialog =
                            { m | gameState = Screept.exec "SET $game_loaded = 1;" m.gameState }
                    in
                    ( { model | gameDialog = Loaded title value, mainMenuDialog = menuDialog }, Cmd.none )

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
                gameDialog title gameDefinition =
                    Started title gameDefinition (initGameFromGameDefinition gameDefinition)
            in
            case model.gameDialog of
                NotLoaded ->
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                Loaded title gameDefinition ->
                    ( { model
                        | gameDialog = gameDialog title gameDefinition
                      }
                    , Cmd.none
                    )

                Started title gameDefinition _ ->
                    ( { model | gameDialog = gameDialog title gameDefinition }, Cmd.none )


type alias Model =
    { gameDialog : GameStatus
    , isDebug : Bool
    , screeptEditor : ScreeptEditor.Model
    , dialogEditor : DialogGameEditor.Model
    , gameDefinition : Maybe GameDefinition
    , mainMenuDialog : DialogGame.Model
    }


type Msg
    = None
    | GameDialog DialogGame.Msg
    | SeedGenerated Random.Seed
    | ScreeptEditor ScreeptEditor.Msg
    | DialogEditor DialogGameEditor.Msg
    | GotGameDefinition String (Result Http.Error GameDefinition)
    | MainMenuDialog DialogGame.Msg
    | StartGame


initGameFromGameDefinition : GameDefinition -> DialogGame.Model
initGameFromGameDefinition gameDefinition =
    { gameState =
        { counters = gameDefinition.counters
        , labels = gameDefinition.labels
        , functions = gameDefinition.functions
        , procedures = gameDefinition.procedures
        , messages = []
        , rnd = Random.initialSeed 666
        , dialogStack = Stack.initialise |> Stack.push gameDefinition.startDialogId
        }
    , statusLine = gameDefinition.statusLine
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
        [ DialogGameEditor.viewDialog model.dialogEditor |> Html.map DialogEditor
        , DialogGame.view model.mainMenuDialog |> Html.map MainMenuDialog
        , case model.gameDialog of
            Started title gameDef gameDialogMenu ->
                DialogGame.view gameDialogMenu |> Html.map GameDialog

            NotLoaded ->
                text ""

            Loading ->
                text "loading"

            Loaded title m ->
                text <| "Loaded game " ++ title
        , ScreeptEditor.view model.screeptEditor |> Html.map ScreeptEditor

        --, textarea [] [ text <| stringifyGameDefinition (GameDefinition (model.dialogs |> Dict.values) model.statusLine Game.initialDialogId model.gameState.counters model.gameState.labels model.gameState.procedures model.gameState.functions) ]
        --, ScreeptEditor.viewStatement ScreeptEditor.init.screept
        ]



-------
--- UTIL
-------


htmlCond : Maybe a -> (a -> Html b) -> Html b
htmlCond maybe viewFn =
    case maybe of
        Nothing ->
            text ""

        Just m ->
            viewFn m
