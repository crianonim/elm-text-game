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
      , gameState = exampleGameState
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        ClickDialog actions ->
            ( { model | gameState = List.foldl executeAction model.gameState actions }, Cmd.none )


type alias Model =
    { dialogs : Game.Dialogs
    , gameState : GameState
    }


type Msg
    = None
    | ClickDialog (List DialogActionExecution)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        dialog =
            getDialog (Stack.top model.gameState.dialogStack |> Maybe.withDefault "bad") model.dialogs

        _ =
            Debug.log "stack" model.gameState.dialogStack

        _ =
            Debug.log "test" <| testCondition (Counter "money") (Game.NOT <| Game.LT (Const 30)) model.gameState
    in
    div [] [ viewDialog model.gameState dialog (Stack.toList model.gameState.dialogStack |> List.length |> (<) 1) ]


viewDialog : GameState -> Game.Dialog -> Bool -> Html Msg
viewDialog gameState dialog showGoBack =
    div []
        [ h3 [] [ introText gameState ]
        , h2 [] [ text <| getText gameState dialog.text ]
        , div [] <|
            List.map (viewOption gameState) dialog.options
                ++ (if showGoBack then
                        [ viewGoBackOption ]

                    else
                        []
                   )
        ]


viewOption : GameState -> Game.DialogOption -> Html Msg
viewOption gameState dialogOption =
    div [ onClick <| ClickDialog dialogOption.action ] [ text <| getText gameState dialogOption.text ]


viewGoBackOption : Html Msg
viewGoBackOption =
    div [ onClick <| ClickDialog [ GoBackAction ] ] [ text "Back" ]
