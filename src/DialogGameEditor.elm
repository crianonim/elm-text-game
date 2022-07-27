module DialogGameEditor exposing (..)

import DialogGame exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, disabled, value)
import Html.Events exposing (onClick, onInput)
import Monocle.Compose exposing (optionalWithLens, optionalWithOptional)
import Monocle.Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import ParsedEditable
import ScreeptV2 exposing (..)


type alias Model =
    { editedDialog : Maybe EditableDialog
    , gameDefinition : Maybe GameDefinition
    }


type alias EditableDialog =
    { dialog : DialogGame.Dialog
    , id : String
    , text : ParsedEditable.Model Expression
    }


type Msg
    = Edit DialogGame.Dialog
    | Save
    | Cancel
    | TextEdit ParsedEditable.Msg
    | IdExit String
    | Delete Int
    | Move Int Int


init : Model
init =
    { editedDialog = Nothing
    , gameDefinition = Nothing
    }


optional_gameDefinition : Optional Model GameDefinition
optional_gameDefinition =
    { getOption = \m -> m.gameDefinition
    , set = \s m -> { m | gameDefinition = Just s }
    }


editableDiablogToDialog : EditableDialog -> Dialog
editableDiablogToDialog editableDialog =
    case ParsedEditable.model_new.getOption editableDialog.text of
        Just text ->
            { id = editableDialog.id
            , text = text
            , options = editableDialog.dialog.options
            }

        _ ->
            editableDialog.dialog



--
--exampleDialog =
--    { id = "start"
--    , text = Screept.Special [ Screept.S "You're in a dark room. ", Screept.Conditional (DialogGame.zero (Counter "start_look_around")) (S "You see nothing. "), Conditional (nonZero (Counter "start_look_around")) (S "You see a straw bed. "), Conditional (nonZero (Counter "start_search_bed")) (S "There is a rusty key among the straw. ") ]
--    , options =
--        [ { text = Screept.S "Go through the exit", condition = Just (nonZero (Counter "start_look_around")), action = [ GoAction "second" ] }
--        , { text = Screept.S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ Screept <| Screept.inc "start_look_around", Message <| Screept.S "You noticed a straw bed", Turn 5, Screept <| Screept.Rnd (S "rrr") (Const 1) (Const 5) ] }
--        , { text = Screept.S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), DialogGame.nonZero (Counter "start_look_around") ]), action = [ Screept <| Screept.inc "start_search_bed" ] }
--        ]
--    }


txt : String -> Expression
txt s =
    Literal <| Text s


var : String -> Expression
var s =
    Variable <| LiteralIdentifier s


exampleDialog =
    { id = "start"
    , text = txt "You're in a dark room. "
    , options =
        [ { text = txt "Go through the exit", condition = Just (var "start_look_around"), actions = [ GoAction "second" ] }

        --, { text = Screept.S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ Screept <| Screept.inc "start_look_around", Message <| Screept.S "You noticed a straw bed", Turn 5, Screept <| Screept.Rnd (S "rrr") (Const 1) (Const 5) ] }
        --, { text = Screept.S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), DialogGame.nonZero (Counter "start_look_around") ]), action = [ Screept <| Screept.inc "start_search_bed" ] }
        ]
    }


model_editedDialog : Optional Model EditableDialog
model_editedDialog =
    { getOption = .editedDialog
    , set = \s m -> { m | editedDialog = Just s }
    }


editableDialog_text : Lens EditableDialog (ParsedEditable.Model Expression)
editableDialog_text =
    Lens .text (\s m -> { m | text = s })


editedDialog_dialog : Lens EditableDialog Dialog
editedDialog_dialog =
    Lens .dialog (\s m -> { m | dialog = s })


model_dialogs : Optional Model (List Dialog)
model_dialogs =
    model_gameDefinition
        |> optionalWithLens
            (Lens .dialogs (\s m -> { m | dialogs = s }))


model_Dialog : Optional Model Dialog
model_Dialog =
    model_editedDialog
        |> optionalWithLens editedDialog_dialog


model_text : Optional Model (ParsedEditable.Model Expression)
model_text =
    model_editedDialog
        |> optionalWithLens editableDialog_text


model_id : Optional Model String
model_id =
    model_editedDialog
        |> optionalWithLens (Lens .id (\s m -> { m | id = s }))


model_gameDefinition : Optional Model GameDefinition
model_gameDefinition =
    { getOption = .gameDefinition
    , set = \s m -> { m | gameDefinition = Just s }
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Edit dialog ->
            if model_Dialog.getOption model == Just dialog then
                model

            else
                { model
                    | editedDialog =
                        Just
                            { dialog = dialog
                            , id = dialog.id
                            , text = ParsedEditable.init dialog.text ScreeptV2.parserExpression ScreeptV2.stringifyExpression
                            }
                }

        Save ->
            let
                newDialogs : Maybe (List Dialog)
                newDialogs =
                    Maybe.map2
                        (\ed gd ->
                            List.map
                                (\d ->
                                    if ed.dialog == d then
                                        editableDiablogToDialog ed

                                    else
                                        d
                                )
                                gd.dialogs
                        )
                        (model_editedDialog.getOption model)
                        (model_gameDefinition.getOption model)
            in
            case newDialogs of
                Nothing ->
                    model

                Just nd ->
                    model_dialogs.set nd model

        Cancel ->
            model

        TextEdit tMsg ->
            Optional.modify model_text (\m -> ParsedEditable.update tMsg m) model

        Delete indexToDel ->
            Optional.modify model_gameDefinition
                (\gd ->
                    { gd
                        | dialogs =
                            List.indexedMap Tuple.pair gd.dialogs
                                |> List.filter (\( i, _ ) -> i /= indexToDel)
                                |> List.map Tuple.second
                    }
                )
                model

        Move indexToMove step ->
            Optional.modify model_gameDefinition
                (\gd ->
                    let
                        item : List Dialog
                        item =
                            List.drop indexToMove gd.dialogs
                                |> List.take 1

                        rest : List Dialog
                        rest =
                            List.take indexToMove gd.dialogs
                                ++ List.drop (indexToMove + 1) gd.dialogs
                    in
                    { gd
                        | dialogs =
                            List.take (indexToMove + step) rest
                                ++ item
                                ++ List.drop (indexToMove + step) rest
                    }
                )
                model

        IdExit string ->
            model_id.set string model


view : Model -> Html Msg
view model =
    case model.gameDefinition of
        Just gd ->
            div []
                [ h6 [] [ text "Dialogs:" ]
                , div [] (List.indexedMap (viewDialog model) gd.dialogs)
                , textarea [ value (DialogGame.stringifyGameDefinition gd) ] []
                ]

        Nothing ->
            div [] [ text "No GameDefintion loaded" ]


viewDialog : Model -> Int -> Dialog -> Html Msg
viewDialog model i dialog =
    let
        isEdited =
            model_Dialog.getOption model == Just dialog
    in
    div [ class "de-dialog" ]
        [ div []
            [ text "id: "
            , case ( model.editedDialog, isEdited ) of
                ( Just edModel, True ) ->
                    input [ onInput IdExit, value edModel.id ] []

                _ ->
                    span [ class "de-dialog-id" ] [ text dialog.id ]
            ]
        , div []
            [ text "text: "
            , case ( model.editedDialog, isEdited ) of
                ( Just edModel, True ) ->
                    div []
                        [ ParsedEditable.view edModel.text |> Html.map TextEdit
                        ]

                _ ->
                    viewExpression dialog.text
            ]
        , div []
            [ text "options:"
            , div [] (List.map viewOption dialog.options)
            ]
        , let
            enabled : Bool
            enabled =
                Maybe.map2 (\id t -> ParsedEditable.isChanged t || id /= dialog.id)
                    (model_id.getOption model)
                    (model_text.getOption model)
                    |> Maybe.withDefault False
          in
          button [ disabled <| not enabled, onClick <| Save ] [ text "Save" ]
        , button [ onClick <| Edit dialog ] [ text "EDIT" ]
        , button [ onClick <| Delete i ] [ text "Delete" ]
        , button
            [ onClick <| Move i -1
            , disabled <|
                if i == 0 then
                    True

                else
                    False
            ]
            [ text "Move Up" ]
        , button [ onClick <| Move i 1 ] [ text "Move Down" ]
        ]


elipsisText : String -> String
elipsisText s =
    if String.length s > 100 then
        String.slice 0 100 s ++ "..."

    else
        s


viewOption : DialogOption -> Html msg
viewOption dialogOption =
    div [ class "de-dialog-option" ]
        [ div [] [ text "op_text: ", viewExpression dialogOption.text ]
        , div [] [ text "condition: ", Maybe.map viewExpression dialogOption.condition |> Maybe.withDefault (text "n/a") ]
        , div [] [ text "actions:", div [] (List.map viewAction dialogOption.actions) ]
        ]


viewAction : DialogAction -> Html msg
viewAction dialogAction =
    div []
        [ text <|
            case dialogAction of
                Message expr ->
                    "Message: " ++ stringifyExpression expr

                GoAction dialogId ->
                    "Go: " ++ dialogId

                GoBackAction ->
                    "GoBack"

                Screept statement ->
                    "Screept: " ++ stringifyStatement statement

                ConditionalAction expression success failure ->
                    "IF"

                ActionBlock dialogActions ->
                    "[]"

                Exit string ->
                    "EXIT " ++ string
        ]


viewExpression : Expression -> Html msg
viewExpression expression =
    span [ class "de-dialog-condition" ] [ text <| elipsisText <| ScreeptV2.stringifyExpression expression ]


viewEditDialog : Model -> Html Msg
viewEditDialog model =
    case model.editedDialog of
        Nothing ->
            div []
                [ button [ onClick <| Edit exampleDialog ] [ text "Edit" ]
                ]

        Just d ->
            div []
                [ div [] [ text "id: ", text d.id ]
                ]
