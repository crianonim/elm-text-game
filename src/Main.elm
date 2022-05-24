module Main exposing (main)

import Browser
import Game exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Stack exposing (Stack)


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
    ( { dialogs = listDialogToDictDialog dialogExamples
      , dialogStack = Stack.push "start" Stack.initialise
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        GoDialog dialogId ->
            ( { model | dialogStack = Stack.push dialogId model.dialogStack }, Cmd.none )

        GoBack ->
            ( { model | dialogStack = Tuple.second (Stack.pop model.dialogStack) }, Cmd.none )


type alias Model =
    { dialogs : Game.Dialogs
    , dialogStack : Stack Game.DialogId
    }


type Msg
    = None
    | GoDialog DialogId
    | GoBack



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        dialog =
            getDialog (Stack.top model.dialogStack |> Maybe.withDefault "bad") model.dialogs

        _ =
            Debug.log "stack" model.dialogStack
    in
    div [] [ viewDialog dialog (Stack.toList model.dialogStack |> List.length |> (<) 1) ]


viewDialog : Game.Dialog -> Bool -> Html Msg
viewDialog dialog showGoBack =
    div []
        [ h2 [] [ text dialog.text ]
        , div [] <|
            List.map viewOption dialog.options
                ++ (if showGoBack then
                        [ viewGoBackOption ]

                    else
                        []
                   )
        ]


viewOption : Game.DialogOption -> Html Msg
viewOption dialogOption =
    div [ onClick <| GoDialog dialogOption.go ] [ text dialogOption.text ]


viewGoBackOption : Html Msg
viewGoBackOption =
    div [ onClick GoBack ] [ text "Back" ]
