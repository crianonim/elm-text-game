module Main exposing (main)

--import Games.UnderSeaGame as Game
--import Games.TestSanbox as Game

import Browser
import DialogGame exposing (..)
import DialogGameEditor
import Dict
import Games.FabledLands as Game
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
      }
    , Cmd.batch
        [ Random.generate SeedGenerated Random.independentSeed
        , Http.get { url = "/games/fabled.json", expect = Http.expectJson GotGameDefinition decodeGameDefinition }
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        GameDialog gdm ->
            ( { model | gameDialog = DialogGame.update gdm model.gameDialog }, Cmd.none )

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
                    ( model, Cmd.none )


type alias Model =
    { gameDialog : DialogGame.Model
    , isDebug : Bool
    , screeptEditor : ScreeptEditor.Model
    , dialogEditor : DialogGameEditor.Model
    , gameDefinition : Maybe GameDefinition
    }


type Msg
    = None
    | GameDialog DialogGame.Msg
    | SeedGenerated Random.Seed
    | ScreeptEditor ScreeptEditor.Msg
    | DialogEditor DialogGameEditor.Msg
    | GotGameDefinition (Result Http.Error GameDefinition)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ DialogGameEditor.viewDialog model.dialogEditor |> Html.map DialogEditor
        , DialogGame.view model.gameDialog |> Html.map GameDialog
        , ScreeptEditor.view model.screeptEditor |> Html.map ScreeptEditor

        --, textarea [] [ text <| stringifyGameDefinition (GameDefinition (model.dialogs |> Dict.values) model.statusLine Game.initialDialogId model.gameState.counters model.gameState.labels model.gameState.procedures model.gameState.functions) ]
        --, ScreeptEditor.viewStatement ScreeptEditor.init.screept
        ]
