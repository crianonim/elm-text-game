module Main exposing (main)

import Browser
import Dict
import Game exposing (..)
import Games.FirstTestGame as TestGame
import Html exposing (..)
import Html.Attributes exposing (class)
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
    ( { dialogs = listDialogToDictDialog TestGame.dialogs
      , gameState = TestGame.initialGameState
      , config = TestGame.config
      , isDebug = True
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        ClickDialog actions ->
            ( { model
                | gameState = List.foldl (executeAction model.config.turnCallback) model.gameState actions
              }
            , Cmd.none
            )


type alias Model =
    { dialogs : Game.Dialogs
    , gameState : GameState
    , config : GameConfig
    , isDebug : Bool
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
            Debug.log "test" <| testCondition (NOT (Predicate (Counter "money") Game.LT (Const 43))) model.gameState
    in
    div [ class "container" ]
        [ viewDialog model.gameState dialog
        , if model.config.showMessages then
            viewMessages model.gameState.messages

          else
            text ""
        , if model.isDebug then
            viewDebug model.gameState

          else
            text ""
        ]


viewMessages : List String -> Html msg
viewMessages msgs =
    div [ class "messages" ] <|
        List.map (\m -> p [ class "message" ] [ text m ]) msgs


viewDialog : GameState -> Game.Dialog -> Html Msg
viewDialog gameState dialog =
    div [ class "dialog" ]
        [ p [] [ text <| getText gameState dialog.text ]
        , div [] <|
            List.map (viewOption gameState) (dialog.options |> List.filter (\o -> o.condition |> Maybe.map (\check -> testCondition check gameState) |> Maybe.withDefault True))
        ]


viewDebug : GameState -> Html a
viewDebug gameState =
    div [ class "status" ]
        [ p [] (Dict.toList gameState.counters |> List.map (\( k, v ) -> text <| k ++ ":" ++ String.fromInt v ++ ", "))
        ]


viewOption : GameState -> Game.DialogOption -> Html Msg
viewOption gameState dialogOption =
    div [ onClick <| ClickDialog dialogOption.action, class "option" ] [ text <| getText gameState dialogOption.text ]
