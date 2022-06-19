module Main exposing (main)

import Browser
import DialogGame exposing (..)
import DialogGameEditor
import Dict
import Games.FirstTestGame as TestGame
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Random
import Screept
import ScreeptEditor
import Stack exposing (Stack)


main : Program () Model Msg
main =
    let
        _ =
            Debug.log "Parsed" Screept.parsed
    in
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
      , isDebug = True
      , screeptEditor = ScreeptEditor.init
      , dialogEditor = DialogGameEditor.init
      }
    , Random.generate SeedGenerated Random.independentSeed
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        ClickDialog actions ->
            ( { model
                | gameState = List.foldl executeAction model.gameState actions
              }
            , Cmd.none
            )

        SeedGenerated seed ->
            ( { model | gameState = setRndSeed seed model.gameState }, Cmd.none )

        ScreeptEditor seMsg ->
            ( { model | screeptEditor = ScreeptEditor.update seMsg model.screeptEditor }, Cmd.none )

        DialogEditor deMsg ->
            ( { model | dialogEditor = DialogGameEditor.update deMsg model.dialogEditor }, Cmd.none )


type alias Model =
    { dialogs : DialogGame.Dialogs
    , gameState : GameState
    , isDebug : Bool
    , screeptEditor : ScreeptEditor.Model
    , dialogEditor : DialogGameEditor.Model
    }


type Msg
    = None
    | ClickDialog (List DialogActionExecution)
    | SeedGenerated Random.Seed
    | ScreeptEditor ScreeptEditor.Msg
    | DialogEditor DialogGameEditor.Msg



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
    in
    div [ class "container" ]
        [ DialogGameEditor.viewDialog model.dialogEditor |> Html.map DialogEditor
        , viewDialog model.gameState dialog
        , if List.length model.gameState.messages > 0 then
            viewMessages model.gameState.messages

          else
            text ""
        , if model.isDebug then
            viewDebug model.gameState

          else
            text ""
        , ScreeptEditor.view model.screeptEditor |> Html.map ScreeptEditor

        --, ScreeptEditor.viewStatement ScreeptEditor.init.screept
        ]


viewMessages : List String -> Html msg
viewMessages msgs =
    div [ class "messages" ] <|
        List.map (\m -> p [ class "message" ] [ text m ]) msgs


viewDialog : GameState -> DialogGame.Dialog -> Html Msg
viewDialog gameState dialog =
    div [ class "dialog" ]
        [ viewDialogText dialog.text gameState
        , div [] <|
            List.map (viewOption gameState) (dialog.options |> List.filter (\o -> o.condition |> Maybe.map (\check -> Screept.testCondition check gameState) |> Maybe.withDefault True))
        ]


viewDialogText : Screept.TextValue -> GameState -> Html msg
viewDialogText textValue gameState =
    div []
        (Screept.getText gameState textValue |> String.split "\n" |> List.map (\par -> p [] [ text par ]))


viewDebug : GameState -> Html a
viewDebug gameState =
    div [ class "status" ]
        [ p [] (Dict.toList gameState.counters |> List.map (\( k, v ) -> text <| k ++ ":" ++ String.fromInt v ++ ", "))
        ]


viewOption : GameState -> DialogGame.DialogOption -> Html Msg
viewOption gameState dialogOption =
    div [ onClick <| ClickDialog dialogOption.action, class "option" ] [ text <| Screept.getText gameState dialogOption.text ]
