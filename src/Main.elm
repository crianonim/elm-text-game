module Main exposing (main)

import Browser
import Game exposing (..)
import Games.FirstTestGame as TestGame
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Stack exposing (Stack)


main : Program () (Model TestGame.FirstActions) (Msg TestGame.FirstActions)
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model TestGame.FirstActions, Cmd (Msg TestGame.FirstActions) )
init _ =
    ( { dialogs = listDialogToDictDialog TestGame.dialogExamples
      , gameState = TestGame.exampleGameState
      }
    , Cmd.none
    )


update : Msg TestGame.FirstActions -> Model TestGame.FirstActions -> ( Model TestGame.FirstActions, Cmd (Msg TestGame.FirstActions) )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        ClickDialog actions ->
            ( { model
                | gameState =
                    List.foldl
                        (\ac acc ->
                            case ac of
                                CustomAction custom ->
                                    TestGame.executeCustomAction custom acc

                                x ->
                                    executeAction x acc
                        )
                        model.gameState
                        actions
              }
            , Cmd.none
            )


type alias Model a =
    { dialogs : Game.Dialogs a
    , gameState : GameState
    }


type Msg a
    = None
    | ClickDialog (List (DialogActionExecution a))



-- SUBSCRIPTIONS


subscriptions : Model a -> Sub (Msg a)
subscriptions model =
    Sub.none



-- VIEW


view : Model a -> Html (Msg a)
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
        , viewMessages model.gameState.messages
        ]


viewMessages : List String -> Html msg
viewMessages msgs =
    div [ class "messages" ] <|
        List.map (\m -> p [ class "message" ] [ text m ]) msgs


viewDialog : GameState -> Game.Dialog a -> Html (Msg a)
viewDialog gameState dialog =
    div [ class "dialog" ]
        [ p [] [ introText gameState ]
        , h2 [] [ text <| getText gameState dialog.text ]
        , div [] <|
            List.map (viewOption gameState) (dialog.options |> List.filter (\o -> o.condition |> Maybe.map (\check -> testCondition check gameState) |> Maybe.withDefault True))
        ]


viewOption : GameState -> Game.DialogOption a -> Html (Msg a)
viewOption gameState dialogOption =
    div [ onClick <| ClickDialog dialogOption.action, class "option" ] [ text <| getText gameState dialogOption.text ]
