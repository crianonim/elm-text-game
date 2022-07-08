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
    ( { gameDialog =
            DialogGame.init
                { counters = Game.counters
                , labels = Game.labels
                , dialogStack = Stack.push Game.initialDialogId Stack.initialise
                , procedures = Game.procedures
                , functions = Game.functions
                , messages = []
                , rnd = Random.initialSeed 666
                }
                (listDialogToDictDialog Game.dialogs)
                (Just Game.statusLine)
      , isDebug = True
      , screeptEditor = ScreeptEditor.init
      , dialogEditor = DialogGameEditor.init
      , gameDefinition = Nothing
      , yesNoDialog = Just <| DialogGame.initSimple yesNoDialogs
      , mainMenuDialog = Just <| DialogGame.initSimple mainMenuDialogs
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
          , text = Screept.Concat [ Screept.S "Game loaded: ", Screept.Label "game_loaded" ]
          , options =
                [ { text = Screept.S "Load Sandbox", condition = Nothing, action = [ Exit "sandbox" ] }
                , { text = Screept.S "Load Fabled", condition = Nothing, action = [ Exit "fabled" ] }
                ]
          }
        ]


mainMenuActions : DialogGame.Model -> Maybe String -> ( DialogGame.Model, Cmd Msg )
mainMenuActions dialModel mcode =
    case mcode of
        Nothing ->
            ( dialModel, Cmd.none )

        Just code ->
            let
                m =
                    { dialModel | gameState = Screept.runStatement (Screept.parseStatement <| "LABEL $game_loaded = \"" ++ code ++ " \"") dialModel.gameState }
            in
            case code of
                "sandbox" ->
                    ( m, Http.get { url = "/games/testsandbox.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition } )

                "fabled" ->
                    ( m, Http.get { url = "/games/fabled.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition } )

                _ ->
                    ( dialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        GameDialog gdm ->
            let
                ( gdModel, exitCode ) =
                    DialogGame.update gdm model.gameDialog
            in
            ( { model | gameDialog = gdModel }, Cmd.none )

        SeedGenerated seed ->
            ( { model | gameDialog = DialogGame.setRndSeed seed model.gameDialog }, Cmd.none )

        ScreeptEditor seMsg ->
            ( { model | screeptEditor = ScreeptEditor.update seMsg model.screeptEditor }, Cmd.none )

        DialogEditor deMsg ->
            ( { model | dialogEditor = DialogGameEditor.update deMsg model.dialogEditor }, Cmd.none )

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
                            Debug.log "Success decode" value
                    in
                    ( { model | gameDialog = initGameFromGameDefinition value }, Cmd.none )

        YesNoDialog ynmsg ->
            case model.yesNoDialog of
                Nothing ->
                    ( model, Cmd.none )

                Just yndm ->
                    let
                        ( yn, exitCode ) =
                            DialogGame.update ynmsg yndm

                        newYND =
                            if exitCode == Just "yes" then
                                Nothing

                            else
                                Just yn
                    in
                    ( { model | yesNoDialog = newYND }, Cmd.none )

        MainMenuDialog menuMsg ->
            case model.mainMenuDialog of
                Nothing ->
                    ( model, Cmd.none )

                Just mainMenuModel ->
                    let
                        ( menuModel, exitCode ) =
                            DialogGame.update menuMsg mainMenuModel

                        ( newMenuModel, cmd ) =
                            mainMenuActions menuModel exitCode
                    in
                    ( { model | mainMenuDialog = Just newMenuModel }, cmd )


type alias Model =
    { gameDialog : DialogGame.Model
    , isDebug : Bool
    , screeptEditor : ScreeptEditor.Model
    , dialogEditor : DialogGameEditor.Model
    , gameDefinition : Maybe GameDefinition
    , yesNoDialog : Maybe DialogGame.Model
    , mainMenuDialog : Maybe DialogGame.Model
    }


type Msg
    = None
    | GameDialog DialogGame.Msg
    | SeedGenerated Random.Seed
    | ScreeptEditor ScreeptEditor.Msg
    | DialogEditor DialogGameEditor.Msg
    | GotGameDefinition (Result Http.Error GameDefinition)
    | YesNoDialog DialogGame.Msg
    | MainMenuDialog DialogGame.Msg


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
        , htmlCond model.mainMenuDialog DialogGame.view |> Html.map MainMenuDialog
        , DialogGame.view model.gameDialog |> Html.map GameDialog
        , ScreeptEditor.view model.screeptEditor |> Html.map ScreeptEditor
        , htmlCond model.yesNoDialog DialogGame.view |> Html.map YesNoDialog

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
