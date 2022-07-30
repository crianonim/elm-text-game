module DialogGameEditor exposing (..)

import DialogGame exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, disabled, value)
import Html.Events exposing (onClick, onInput)
import List.Extra
import Monocle.Compose exposing (lensWithLens, lensWithOptional, optionalWithLens, optionalWithOptional)
import Monocle.Lens as Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import ParsedEditable
import ScreeptV2 exposing (..)


type alias Model =
    { editedDialog : Maybe EditedDialog
    , gameDefinition : GameDefinition
    }


type alias EditedDialog =
    { dialog : DialogGame.Dialog
    , id : String
    , text : ParsedEditable.Model Expression
    , options : List DialogOption
    , editedOption : Maybe EditedOption
    }


type alias EditedOption =
    { option : DialogOption
    , text : ParsedEditable.Model Expression
    , condition : Maybe (ParsedEditable.Model Expression)
    , actions : List DialogAction
    }


type Msg
    = StartDialogEdit DialogGame.Dialog
    | Save
    | Cancel
    | DialogsManipulation ManipulatePositionAction
    | OptionsManipulation ManipulatePositionAction
    | DialogEdit DialogsEditAction
    | StartOptionEdit DialogOption
    | OptionEdit OptionEditAction
    | SaveOption


type DialogsEditAction
    = DialogTextEdit ParsedEditable.Msg
    | DialogIdEdit String


type OptionEditAction
    = OptionTextEdit ParsedEditable.Msg
    | OptionConditionEdit ParsedEditable.Msg


type ManipulatePositionAction
    = MovePosition Int Int
    | DeletePosition Int
    | NewAt Int


init : GameDefinition -> Model
init gd =
    { editedDialog = Nothing
    , gameDefinition = gd
    }


editedDialogToDialog : EditedDialog -> Dialog
editedDialogToDialog editableDialog =
    case ParsedEditable.model_new.getOption editableDialog.text of
        Just text ->
            { id = editableDialog.id
            , text = text
            , options = editableDialog.options
            }

        _ ->
            editableDialog.dialog


editedDialogOptionToDialogOption : EditedOption -> DialogOption
editedDialogOptionToDialogOption editableOption =
    case ParsedEditable.model_new.getOption editableOption.text of
        Just text ->
            { text = text
            , condition = Maybe.andThen ParsedEditable.model_new.getOption editableOption.condition
            , actions = editableOption.actions
            }

        _ ->
            editableOption.option


model_editedDialog : Optional Model EditedDialog
model_editedDialog =
    { getOption = .editedDialog
    , set = \s m -> { m | editedDialog = Just s }
    }


lens_text : Lens { a | text : ParsedEditable.Model Expression } (ParsedEditable.Model Expression)
lens_text =
    Lens .text (\s m -> { m | text = s })


editedDialog_dialog : Lens EditedDialog Dialog
editedDialog_dialog =
    Lens .dialog (\s m -> { m | dialog = s })


editedDialog_editedOption : Optional EditedDialog EditedOption
editedDialog_editedOption =
    Optional .editedOption (\s m -> { m | editedOption = Just s })


model_editedOption : Optional Model EditedOption
model_editedOption =
    model_editedDialog
        |> optionalWithOptional editedDialog_editedOption


model_editedOptionOption : Optional Model DialogOption
model_editedOptionOption =
    model_editedOption
        |> optionalWithLens
            (Lens .option (\s m -> { m | option = s }))


editedOption_mCondition : Lens EditedOption (Maybe (ParsedEditable.Model Expression))
editedOption_mCondition =
    Lens .condition (\s m -> { m | condition = s })


editedOption_condition : Optional EditedOption (ParsedEditable.Model Expression)
editedOption_condition =
    Optional .condition (\s m -> { m | condition = Just s })


model_dialogs : Lens Model (List Dialog)
model_dialogs =
    model_gameDefinition
        |> lensWithLens
            (Lens .dialogs (\s m -> { m | dialogs = s }))


model_options : Optional Model (List DialogOption)
model_options =
    model_editedDialog
        |> optionalWithLens
            (Lens .options (\s m -> { m | options = s }))


model_Dialog : Optional Model Dialog
model_Dialog =
    model_editedDialog
        |> optionalWithLens editedDialog_dialog


model_text : Optional Model (ParsedEditable.Model Expression)
model_text =
    model_editedDialog
        |> optionalWithLens lens_text


model_id : Optional Model String
model_id =
    model_editedDialog
        |> optionalWithLens lens_id


lens_id : Lens { a | id : String } String
lens_id =
    Lens .id (\s m -> { m | id = s })


model_gameDefinition : Lens Model GameDefinition
model_gameDefinition =
    { get = .gameDefinition
    , set = \s m -> { m | gameDefinition = s }
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        StartDialogEdit dialog ->
            if model_Dialog.getOption model == Just dialog then
                model

            else
                { model
                    | editedDialog =
                        Just
                            { dialog = dialog
                            , id = dialog.id
                            , text = ParsedEditable.init dialog.text ScreeptV2.parserExpression ScreeptV2.stringifyExpression
                            , options = dialog.options
                            , editedOption = Nothing
                            }
                }

        Save ->
            let
                newDialogs : Maybe (List Dialog)
                newDialogs =
                    Maybe.map
                        (\ed ->
                            List.map
                                (\d ->
                                    if ed.dialog == d then
                                        editedDialogToDialog ed

                                    else
                                        d
                                )
                                model.gameDefinition.dialogs
                        )
                        (model_editedDialog.getOption model)
            in
            case newDialogs of
                Nothing ->
                    model

                Just nd ->
                    model_dialogs.set nd model

        Cancel ->
            model

        DialogsManipulation manipulatePosition ->
            Lens.modify model_dialogs (manipulatePositionUpdate newDialog manipulatePosition) model

        OptionsManipulation manipulatePosition ->
            Optional.modify model_options (manipulatePositionUpdate newOption manipulatePosition) model

        DialogEdit dialogAction ->
            Optional.modify model_editedDialog (updateEditedDialog dialogAction) model

        StartOptionEdit dialogOption ->
            if model_editedOptionOption.getOption model == Just dialogOption then
                model

            else
                model_editedOption.set
                    { option = dialogOption
                    , text = ParsedEditable.init dialogOption.text ScreeptV2.parserExpression ScreeptV2.stringifyExpression
                    , condition = Maybe.map (\condition -> ParsedEditable.init condition ScreeptV2.parserExpression ScreeptV2.stringifyExpression) dialogOption.condition
                    , actions = dialogOption.actions
                    }
                    model

        OptionEdit optionEditAction ->
            Optional.modify model_editedOption (updateEditedOption optionEditAction) model

        SaveOption ->
            let
                newOptions : Maybe (List DialogOption)
                newOptions =
                    Maybe.map2
                        (\eOp ed ->
                            List.map
                                (\d ->
                                    if eOp.option == d then
                                        editedDialogOptionToDialogOption eOp

                                    else
                                        d
                                )
                                ed.options
                        )
                        (model_editedOption.getOption model)
                        (model_editedDialog.getOption model)
            in
            case newOptions of
                Nothing ->
                    model

                Just nd ->
                    model_options.set nd model


updateEditedDialog : DialogsEditAction -> EditedDialog -> EditedDialog
updateEditedDialog dialogEditAction dialog =
    case dialogEditAction of
        DialogTextEdit msg ->
            Lens.modify lens_text (\m -> ParsedEditable.update msg m) dialog

        DialogIdEdit string ->
            lens_id.set string dialog


updateEditedOption : OptionEditAction -> EditedOption -> EditedOption
updateEditedOption optionEditAction editedOption =
    case optionEditAction of
        OptionTextEdit msg ->
            Lens.modify lens_text (ParsedEditable.update msg) editedOption

        OptionConditionEdit msg ->
            Optional.modify editedOption_condition (ParsedEditable.update msg) editedOption


newDialog : Dialog
newDialog =
    { id = ""
    , text = Literal <| Text ""
    , options = []
    }


newOption : DialogOption
newOption =
    { text = Literal <| Text ""
    , condition = Nothing
    , actions = []
    }


manipulatePositionUpdate : a -> ManipulatePositionAction -> List a -> List a
manipulatePositionUpdate newObject msg list =
    case msg of
        MovePosition index step ->
            List.Extra.swapAt index (index + step) list

        DeletePosition i ->
            List.Extra.removeAt i
                list

        NewAt i ->
            insertAt i
                newObject
                list


view : Model -> Html Msg
view model =
    div []
        [ h6 [] [ text "Dialogs:" ]
        , div [] (List.indexedMap (viewDialog model) model.gameDefinition.dialogs)
        , textarea [ value (DialogGame.stringifyGameDefinition model.gameDefinition) ] []
        ]


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
                    input [ onInput (\a -> DialogEdit <| DialogIdEdit a), value edModel.id ] []

                _ ->
                    span [ class "de-dialog-id" ] [ text dialog.id ]
            ]
        , div []
            [ text "text: "
            , case ( model.editedDialog, isEdited ) of
                ( Just edModel, True ) ->
                    div []
                        [ ParsedEditable.view edModel.text |> Html.map (\a -> DialogEdit <| DialogTextEdit a)
                        ]

                _ ->
                    viewExpression dialog.text
            ]
        , div []
            [ text "options:"
            , case ( model.editedDialog, isEdited ) of
                ( Just edModel, True ) ->
                    div []
                        (List.indexedMap (viewOption edModel.editedOption True) edModel.options)

                _ ->
                    div [] (List.indexedMap (viewOption Nothing False) dialog.options)
            ]
        , let
            enabled : Bool
            enabled =
                True

            --Maybe.map2 (\id t -> ParsedEditable.isChanged t || id /= dialog.id)
            --    (model_id.getOption model)
            --    (model_text.getOption model)
            --    |> Maybe.withDefault False
          in
          button [ disabled <| not enabled, onClick <| Save ] [ text "Save" ]
        , button [ onClick <| StartDialogEdit dialog ] [ text "EDIT" ]
        , button [ onClick <| DialogsManipulation <| DeletePosition i ] [ text "Delete" ]
        , button
            [ onClick <| DialogsManipulation <| MovePosition i -1
            , disabled <|
                if i == 0 then
                    True

                else
                    False
            ]
            [ text "Move Up" ]
        , button [ onClick <| DialogsManipulation <| MovePosition i 1 ] [ text "Move Down" ]
        , button [ onClick <| DialogsManipulation <| NewAt (i + 1) ] [ text "+New" ]
        ]


elipsisText : String -> String
elipsisText s =
    if String.length s > 100 then
        String.slice 0 100 s ++ "..."

    else
        s


viewOption : Maybe EditedOption -> Bool -> Int -> DialogOption -> Html Msg
viewOption mEditedOption isDialogEditing optionIndex dialogOption =
    let
        isOptionEdited =
            Maybe.map (\eop -> eop.option == dialogOption) mEditedOption |> Maybe.withDefault False
    in
    case ( mEditedOption, isOptionEdited ) of
        ( Just editedOption, True ) ->
            div [ class "de-dialog-option" ]
                [ div []
                    [ text "text: "
                    , ParsedEditable.view editedOption.text |> Html.map (\a -> OptionEdit <| OptionTextEdit a)
                    ]
                , div [] [ text "condition: ", Maybe.map ParsedEditable.view editedOption.condition |> Maybe.withDefault (text "n/a") |> Html.map (\a -> OptionEdit <| OptionConditionEdit a) ]
                , div [] [ text "actions:", div [] (List.map viewAction dialogOption.actions) ]
                , div []
                    [ button [ onClick SaveOption ] [ text "Save Option" ]
                    ]
                ]

        _ ->
            div [ class "de-dialog-option" ]
                [ div [] [ text "op_text: ", viewExpression dialogOption.text ]
                , div [] [ text "condition: ", Maybe.map viewExpression dialogOption.condition |> Maybe.withDefault (text "n/a") ]
                , div [] [ text "actions:", div [] (List.map viewAction dialogOption.actions) ]
                , if isDialogEditing then
                    div []
                        [ button [ onClick <| OptionsManipulation <| MovePosition optionIndex -1 ] [ text "Move Up" ]
                        , button [ onClick <| OptionsManipulation <| MovePosition optionIndex 1 ] [ text "Move Down" ]
                        , button [ onClick <| OptionsManipulation <| DeletePosition optionIndex ] [ text "Delete" ]
                        , button [ onClick <| OptionsManipulation <| NewAt (optionIndex + 1) ] [ text "New" ]
                        , button [ onClick <| StartOptionEdit dialogOption ] [ text "Edit Option" ]
                        ]

                  else
                    text ""
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


insertAt : Int -> a -> List a -> List a
insertAt index item items =
    let
        ( start, end ) =
            List.Extra.splitAt index items
    in
    start ++ [ item ] ++ end
