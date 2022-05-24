module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Game exposing (..)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( {dialogs = listDialogToDictDialog dialogExamples
    , currentDialog = "start"
    }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      None ->
       ( model, Cmd.none )

      GoDialog dialogId ->
         ( {model|currentDialog = dialogId}, Cmd.none )


type alias Model =
    { dialogs : Game.Dialogs
    , currentDialog: Game.DialogId
    }


type Msg
    = None
    | GoDialog DialogId



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        dialog = getDialog model.currentDialog model.dialogs
    in
    div [] [viewDialog dialog]

viewDialog : Game.Dialog -> Html Msg
viewDialog dialog =
    div [] [
        h2 [] [text dialog.text]
        ,div [] <| List.map viewOption dialog.options
    ]
viewOption : Game.DialogOption -> Html Msg
viewOption dialogOption =
    div [onClick <| GoDialog dialogOption.go ] [text dialogOption.text ]
