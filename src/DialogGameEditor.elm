module DialogGameEditor exposing (..)

import DialogGame exposing (..)
import Dict
import Html exposing (..)
import Html.Attributes exposing (class, disabled, selected, value)
import Html.Events exposing (onClick, onInput)
import List.Extra
import Monocle.Compose exposing (lensWithLens, lensWithOptional, optionalWithLens, optionalWithOptional)
import Monocle.Lens as Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import Monocle.Prism as Prism exposing (Prism)
import ParsedEditable
import ScreeptV2 exposing (..)
import Shared exposing (..)


type alias Model =
    { editedDialog : Maybe EditedDialog
    , editedProcedure : Maybe (EditedValue Statement)
    , gameDefinition : GameDefinition
    }


type alias EditedDialog =
    { oldValue : DialogGame.Dialog
    , id : String
    , text : ParsedEditable.Model Expression
    , options : List DialogOption
    , editedOption : Maybe EditedOption
    }


type alias EditedOption =
    { oldValue : DialogOption
    , text : ParsedEditable.Model Expression
    , condition : Maybe (ParsedEditable.Model Expression)
    , actions : List DialogAction
    , editedAction : Maybe EditedAction
    }


type alias EditedAction =
    { oldValue : DialogAction
    , editedActionUI : EditedActionUI
    }


type alias EditedValue a =
    { oldValue : ( String, a )
    , name : String
    , definition : ParsedEditable.Model a
    }


type EditedActionUI
    = EAGoBack
    | EAGo String
    | EAScreept (ParsedEditable.Model Statement)


type ActionType
    = ATGoBack
    | ATGo
    | ATScreept


type Msg
    = StartDialogEdit DialogGame.Dialog
    | Save
    | Cancel
    | DialogsManipulation ManipulatePositionAction
    | DialogEdit DialogsEditAction
    | EditTitle String
    | EditStartDialogId String
    | ProcedureManipulation ManipulatePositionAction
    | StartProcedureEdit ( String, Statement )
    | ProcedureEdit ProcedureEditAction
    | SaveProcedure


type DialogsEditAction
    = DialogTextEdit ParsedEditable.Msg
    | DialogIdEdit String
    | StartOptionEdit DialogOption
    | OptionEdit OptionEditAction
    | OptionsManipulation ManipulatePositionAction
    | SaveOption


type OptionEditAction
    = OptionTextEdit ParsedEditable.Msg
    | OptionConditionEdit ParsedEditable.Msg
    | OptionConditionRemove
    | OptionConditionAdd
    | OptionActionStartEdit DialogAction
    | OptionActionEditAction ActionEditAction
    | ActionEdit ActionEditAction
    | ActionsManipulation ManipulatePositionAction
    | SaveAction


type ActionEditAction
    = SelectActionType ActionType
    | EditGoToText String
    | EditScreept ParsedEditable.Msg


type ProcedureEditAction
    = EditProcName String
    | EditProcDefinition ParsedEditable.Msg


init : GameDefinition -> Model
init gd =
    { editedDialog = Nothing
    , editedProcedure = Nothing
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
            editableDialog.oldValue


editedProcedureToProcedure : EditedValue Statement -> ( String, Statement )
editedProcedureToProcedure editedValue =
    ( editedValue.name, ParsedEditable.current editedValue.definition )


editedDialogOptionToDialogOption : EditedOption -> DialogOption
editedDialogOptionToDialogOption editableOption =
    case ParsedEditable.model_new.getOption editableOption.text of
        Just text ->
            { text = text
            , condition = Maybe.andThen ParsedEditable.model_new.getOption editableOption.condition
            , actions = editableOption.actions
            }

        _ ->
            editableOption.oldValue


editedActionToDialogAction : EditedAction -> DialogAction
editedActionToDialogAction action =
    case action.editedActionUI of
        EAGoBack ->
            GoBackAction

        EAGo string ->
            GoAction string

        EAScreept statement ->
            case ParsedEditable.model_new.getOption statement of
                Just stmt ->
                    Screept stmt

                Nothing ->
                    action.oldValue


dialogActionToEditedAction : DialogAction -> EditedActionUI
dialogActionToEditedAction dialogAction =
    case dialogAction of
        GoAction dialogId ->
            EAGo dialogId

        GoBackAction ->
            EAGoBack

        Message expression ->
            EAGoBack

        Screept statement ->
            EAScreept (ParsedEditable.init statement parserStatement stringifyStatement)

        ConditionalAction expression succes failure ->
            EAGoBack

        ActionBlock dialogActions ->
            EAGoBack

        Exit string ->
            EAGoBack


initEditedAction : ActionType -> EditedActionUI
initEditedAction kind =
    case kind of
        ATGoBack ->
            EAGoBack

        ATGo ->
            EAGo ""

        ATScreept ->
            EAScreept (ParsedEditable.init (Block []) parserStatement stringifyStatement)


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
    Lens .oldValue (\s m -> { m | oldValue = s })


editedDialog_editedOption : Optional EditedDialog EditedOption
editedDialog_editedOption =
    Optional .editedOption (\s m -> { m | editedOption = Just s })


lens_options : Lens { a | options : b } b
lens_options =
    Lens .options (\s m -> { m | options = s })


lens_actions : Lens { a | actions : b } b
lens_actions =
    Lens .actions (\s m -> { m | actions = s })


model_editedOption : Optional Model EditedOption
model_editedOption =
    model_editedDialog
        |> optionalWithOptional editedDialog_editedOption


model_mEditedOption : Optional Model (Maybe EditedOption)
model_mEditedOption =
    model_editedDialog
        |> optionalWithLens (Lens .editedOption (\s m -> { m | editedOption = s }))


lens_editedOption : Lens { a | editedOption : b } b
lens_editedOption =
    Lens .editedOption (\s m -> { m | editedOption = s })


lens_option : Lens { a | option : DialogOption } DialogOption
lens_option =
    Lens .option (\s m -> { m | option = s })


editedOption_mCondition : Lens EditedOption (Maybe (ParsedEditable.Model Expression))
editedOption_mCondition =
    Lens .condition (\s m -> { m | condition = s })


editedOption_condition : Optional EditedOption (ParsedEditable.Model Expression)
editedOption_condition =
    Optional .condition (\s m -> { m | condition = Just s })


editedOption_editedAction : Optional EditedOption EditedAction
editedOption_editedAction =
    Optional .editedAction (\s m -> { m | editedAction = Just s })


editedOption_mEditedAction : Lens EditedOption (Maybe EditedAction)
editedOption_mEditedAction =
    Lens .editedAction (\s m -> { m | editedAction = s })


editedAction_goTo : Prism EditedActionUI String
editedAction_goTo =
    { getOption =
        \ea ->
            case ea of
                EAGo s ->
                    Just s

                _ ->
                    Nothing
    , reverseGet = EAGo
    }


editedAction_screept : Prism EditedActionUI (ParsedEditable.Model Statement)
editedAction_screept =
    { getOption =
        \ea ->
            case ea of
                EAScreept s ->
                    Just s

                _ ->
                    Nothing
    , reverseGet = EAScreept
    }


model_editedAction : Optional Model EditedAction
model_editedAction =
    model_editedOption
        |> optionalWithOptional
            editedOption_editedAction


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
        |> optionalWithLens lens_oldValue


lens_oldValue : Lens { a | oldValue : b } b
lens_oldValue =
    Lens .oldValue (\s m -> { m | oldValue = s })


lens_procedures : Lens { a | procedures : b } b
lens_procedures =
    Lens .procedures (\s m -> { m | procedures = s })


model_editedProcedure : Optional Model (EditedValue Statement)
model_editedProcedure =
    Optional .editedProcedure (\s m -> { m | editedProcedure = Just s })


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


lens_title : Lens { a | title : String } String
lens_title =
    Lens .title (\s m -> { m | title = s })


lens_startDialogId : Lens { a | startDialogId : b } b
lens_startDialogId =
    Lens .startDialogId (\s m -> { m | startDialogId = s })


model_title : Lens Model String
model_title =
    model_gameDefinition
        |> lensWithLens lens_title


model_startDialogId : Lens Model String
model_startDialogId =
    model_gameDefinition
        |> lensWithLens lens_startDialogId


update : Msg -> Model -> Model
update msg model =
    case msg of
        StartDialogEdit dialog ->
            startEditingDialog dialog model

        Save ->
            let
                newDialogs : Maybe (List Dialog)
                newDialogs =
                    Maybe.map
                        (updateOldValueWithTransformation editedDialogToDialog model.gameDefinition.dialogs)
                        (model_editedDialog.getOption model)
            in
            case newDialogs of
                Nothing ->
                    model

                Just nd ->
                    model_dialogs.set nd model
                        |> (\m -> { m | editedDialog = Nothing })

        Cancel ->
            model

        DialogsManipulation manipulatePosition ->
            Lens.modify model_dialogs (manipulatePositionUpdate newDialog manipulatePosition) model

        DialogEdit dialogAction ->
            let
                m =
                    case dialogAction of
                        StartOptionEdit dialogOption ->
                            List.Extra.find
                                (\d -> List.member dialogOption d.options)
                                model.gameDefinition.dialogs
                                |> Maybe.map (\x -> startEditingDialog x model)
                                |> Maybe.withDefault model

                        _ ->
                            model
            in
            Optional.modify model_editedDialog (updateEditedDialog dialogAction) m

        EditTitle string ->
            model_title.set string model

        EditStartDialogId string ->
            model_startDialogId.set string model

        ProcedureManipulation manipulatePositionAction ->
            Lens.modify (model_gameDefinition |> lensWithLens lens_procedures)
                (manipulatePositionUpdate ( "procName    ", Block [] ) manipulatePositionAction)
                model

        StartProcedureEdit ( name, statement ) ->
            if (optional_editedProcedure |> optionalWithLens lens_oldValue).getOption model == Just ( name, statement ) then
                model

            else
                lens_editedProcedure.set
                    (Just
                        { oldValue = ( name, statement )
                        , name = name
                        , definition = parsedEditableStatement statement
                        }
                    )
                    model

        ProcedureEdit procedureEditAction ->
            Optional.modify model_editedProcedure (updateEditedProcedure procedureEditAction) model

        SaveProcedure ->
            let
                newProcedures : Maybe (List ( String, Statement ))
                newProcedures =
                    Maybe.map
                        (updateOldValueWithTransformation editedProcedureToProcedure model.gameDefinition.procedures)
                        (model_editedProcedure.getOption model)
            in
            case newProcedures of
                Nothing ->
                    model

                Just nd ->
                    (model_gameDefinition |> lensWithLens lens_procedures).set nd model
                        |> (\m -> { m | editedProcedure = Nothing })


startEditingDialog : Dialog -> Model -> Model
startEditingDialog dialog model =
    if model_Dialog.getOption model == Just dialog then
        model

    else
        { model
            | editedDialog =
                Just
                    { oldValue = dialog
                    , id = dialog.id
                    , text = ParsedEditable.init dialog.text ScreeptV2.parserExpression ScreeptV2.stringifyExpression
                    , options = dialog.options
                    , editedOption = Nothing
                    }
        }


startEditingOption : DialogOption -> EditedDialog -> EditedDialog
startEditingOption dialogOption dialog =
    if
        (editedDialog_editedOption
            |> optionalWithLens lens_oldValue
        ).getOption
            dialog
            == Just dialogOption
    then
        dialog

    else
        editedDialog_editedOption.set
            { oldValue = dialogOption
            , text = ParsedEditable.init dialogOption.text ScreeptV2.parserExpression ScreeptV2.stringifyExpression
            , condition = Maybe.map (\condition -> ParsedEditable.init condition ScreeptV2.parserExpression ScreeptV2.stringifyExpression) dialogOption.condition
            , actions = dialogOption.actions
            , editedAction = Nothing
            }
            dialog


updateEditedDialog : DialogsEditAction -> EditedDialog -> EditedDialog
updateEditedDialog dialogEditAction dialog =
    case dialogEditAction of
        DialogTextEdit msg ->
            Lens.modify lens_text (\m -> ParsedEditable.update msg m) dialog

        DialogIdEdit string ->
            lens_id.set string dialog

        StartOptionEdit dialogOption ->
            startEditingOption dialogOption dialog

        OptionEdit optionEditAction ->
            let
                d =
                    case optionEditAction of
                        OptionActionStartEdit dialogAction ->
                            List.Extra.find
                                (\o -> List.member dialogAction o.actions)
                                dialog.options
                                |> Maybe.map (\x -> startEditingOption x dialog)
                                |> Maybe.withDefault dialog

                        _ ->
                            dialog
            in
            Optional.modify editedDialog_editedOption (updateEditedOption optionEditAction) d

        OptionsManipulation manipulatePosition ->
            Lens.modify lens_options (manipulatePositionUpdate newOption manipulatePosition) dialog

        SaveOption ->
            let
                newOptions : Maybe (List DialogOption)
                newOptions =
                    Maybe.map
                        (updateOldValueWithTransformation editedDialogOptionToDialogOption dialog.options)
                        (editedDialog_editedOption.getOption dialog)
            in
            case newOptions of
                Nothing ->
                    dialog

                Just nd ->
                    lens_options.set nd dialog
                        |> lens_editedOption.set Nothing


updateEditedOption : OptionEditAction -> EditedOption -> EditedOption
updateEditedOption optionEditAction editedOption =
    case optionEditAction of
        OptionTextEdit msg ->
            let
                _ =
                    Debug.log "OTE" ( msg, optionEditAction, editedOption )
            in
            Lens.modify lens_text (ParsedEditable.update msg) editedOption

        OptionConditionEdit msg ->
            Optional.modify editedOption_condition (ParsedEditable.update msg) editedOption

        OptionConditionRemove ->
            editedOption_mCondition.set Nothing editedOption

        OptionConditionAdd ->
            editedOption_condition.set (ParsedEditable.init (Literal <| Number 1) parserExpression stringifyExpression) editedOption

        OptionActionStartEdit dialogAction ->
            editedOption_editedAction.set
                { oldValue = dialogAction
                , editedActionUI = dialogActionToEditedAction dialogAction
                }
                editedOption

        OptionActionEditAction actionEditAction ->
            Optional.modify editedOption_editedAction (updateEditedAction actionEditAction) editedOption

        SaveAction ->
            let
                newActions =
                    Maybe.map
                        (updateOldValueWithTransformation editedActionToDialogAction editedOption.actions)
                        (editedOption_editedAction.getOption editedOption)
            in
            case newActions of
                Nothing ->
                    editedOption

                Just neo ->
                    { editedOption | actions = neo }
                        |> editedOption_mEditedAction.set Nothing

        ActionEdit actionEditAction ->
            Optional.modify editedOption_editedAction (updateEditedAction actionEditAction) editedOption

        ActionsManipulation manipulatePositionAction ->
            Lens.modify lens_actions (manipulatePositionUpdate newAction manipulatePositionAction) editedOption


updateEditedAction : ActionEditAction -> EditedAction -> EditedAction
updateEditedAction actionEditAction editedAction =
    case actionEditAction of
        SelectActionType kind ->
            { editedAction | editedActionUI = initEditedAction kind }

        EditGoToText string ->
            { editedAction
                | editedActionUI =
                    editedAction_goTo.reverseGet string
            }

        EditScreept msg ->
            { editedAction
                | editedActionUI =
                    Prism.modify editedAction_screept (ParsedEditable.update msg) editedAction.editedActionUI
            }


updateEditedProcedure : ProcedureEditAction -> EditedValue Statement -> EditedValue Statement
updateEditedProcedure procedureEditAction editedValue =
    case procedureEditAction of
        EditProcName string ->
            { editedValue | name = string }

        EditProcDefinition msg ->
            Lens.modify lens_definition (ParsedEditable.update msg) editedValue


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


newAction : DialogAction
newAction =
    GoBackAction


getDialogIds : Model -> List String
getDialogIds model =
    List.map .id model.gameDefinition.dialogs


view : Model -> Html Msg
view model =
    div []
        [ h5 [] [ text "Dialog Editor" ]
        , div []
            [ text "Title: "
            , input
                [ value <| model_title.get model
                , class "focus:ring-2 focus:ring-blue-500 focus:outline-none appearance-none w-full text-sm leading-6 text-slate-900 placeholder-slate-400 rounded-md py-2 pl-10 ring-1 ring-slate-200 shadow-sm"
                , onInput EditTitle
                ]
                []
            ]
        , div []
            [ text "StartDialogId: "
            , select
                [ onInput EditStartDialogId
                ]
                (List.map
                    (\o ->
                        option
                            [ value o
                            , selected (o == model_startDialogId.get model)
                            ]
                            [ text o ]
                    )
                    (getDialogIds model)
                )
            ]
        , h6 [] [ text "Procedures:" ]
        , div [] (List.indexedMap (viewProcedure model) model.gameDefinition.procedures)
        , h6 [] [ text "Dialogs:" ]
        , div [] (List.indexedMap (viewDialog model) model.gameDefinition.dialogs)
        , textarea [ value (DialogGame.stringifyGameDefinition model.gameDefinition) ] []
        ]


viewProcedure : Model -> Int -> ( String, Statement ) -> Html Msg
viewProcedure model i ( name, definition ) =
    let
        isEdited =
            (model_editedProcedure |> optionalWithLens lens_oldValue).getOption model == Just ( name, definition )
    in
    div []
        (case ( model_editedProcedure.getOption model, isEdited ) of
            ( Just eP, True ) ->
                [ input [ value eP.name, onInput (EditProcName >> ProcedureEdit) ] []
                , ParsedEditable.view eP.definition |> Html.map (EditProcDefinition >> ProcedureEdit)
                , button [ onClick SaveProcedure ] [ text "Save Procedure" ]
                ]

            _ ->
                [ div []
                    [ span [] [ text name ]
                    , code [] [ text <| stringifyStatement definition ]
                    , viewManipulateButtons "procedure" ProcedureManipulation i
                    , button [ onClick <| StartProcedureEdit ( name, definition ) ] [ text "EDIT" ]
                    ]
                ]
        )


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
        , button [ onClick <| Save ] [ text "Save" ]
        , button [ onClick <| StartDialogEdit dialog ] [ text "EDIT" ]
        , viewManipulateButtons "dialog" DialogsManipulation i
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
            Maybe.map (\eop -> eop.oldValue == dialogOption) mEditedOption |> Maybe.withDefault False
    in
    case ( mEditedOption, isOptionEdited ) of
        ( Just editedOption, True ) ->
            div [ class "de-dialog-option" ]
                [ div []
                    [ text "text: "
                    , ParsedEditable.view editedOption.text |> Html.map (OptionTextEdit >> OptionEdit >> DialogEdit)
                    ]
                , div []
                    [ text "condition: "
                    , case editedOption.condition of
                        Just condition ->
                            div []
                                [ ParsedEditable.view condition |> Html.map (OptionConditionEdit >> OptionEdit >> DialogEdit)
                                , button [ onClick <| DialogEdit <| OptionEdit OptionConditionRemove ] [ text "Remove condition" ]
                                ]

                        Nothing ->
                            div []
                                [ text "n/a"
                                , button [ onClick <| DialogEdit <| OptionEdit <| OptionConditionAdd ] [ text "Add condition" ]
                                ]
                    ]
                , div []
                    [ text "actions:"
                    , div []
                        (case editedOption.editedAction of
                            Nothing ->
                                List.indexedMap (viewAction True) editedOption.actions

                            Just ea ->
                                List.indexedMap (viewActionEdited ea) editedOption.actions
                        )
                    ]
                , div []
                    [ button [ onClick <| DialogEdit SaveOption ] [ text "Save Option" ]
                    ]
                ]

        _ ->
            div [ class "de-dialog-option" ]
                [ div [] [ text "op_text: ", viewExpression dialogOption.text ]
                , div [] [ text "condition: ", Maybe.map viewExpression dialogOption.condition |> Maybe.withDefault (text "n/a") ]
                , div [] [ text "actions:", div [] (List.indexedMap (viewAction False) dialogOption.actions) ]
                , if isDialogEditing then
                    viewManipulateButtons "option" (DialogEdit << OptionsManipulation) optionIndex

                  else
                    text ""
                , button [ onClick <| DialogEdit <| StartOptionEdit dialogOption ] [ text "Edit Option" ]
                ]


viewActionEdited : EditedAction -> Int -> DialogAction -> Html Msg
viewActionEdited editedAction i da =
    if editedAction.oldValue /= da then
        viewAction True i da

    else
        div []
            [ case editedAction.editedActionUI of
                EAGoBack ->
                    text "Go back"

                _ ->
                    button [ onClick <| DialogEdit <| OptionEdit <| OptionActionEditAction <| SelectActionType ATGoBack ] [ text "Go Back" ]
            , case editedAction.editedActionUI of
                EAGo goTo ->
                    span [] [ text "GoTo", input [ value goTo, onInput (DialogEdit << OptionEdit << OptionActionEditAction << EditGoToText) ] [] ]

                _ ->
                    button [ onClick <| DialogEdit <| OptionEdit <| OptionActionEditAction <| SelectActionType ATGo ] [ text "Go to .." ]
            , case editedAction.editedActionUI of
                EAScreept screept ->
                    ParsedEditable.view screept |> Html.map (EditScreept >> OptionActionEditAction >> OptionEdit >> DialogEdit)

                _ ->
                    button [ onClick <| DialogEdit <| OptionEdit <| OptionActionEditAction <| SelectActionType ATScreept ] [ text "Screept" ]
            , button [ onClick <| DialogEdit <| OptionEdit <| SaveAction ] [ text "Save Action" ]
            ]


viewAction : Bool -> Int -> DialogAction -> Html Msg
viewAction isEdited optionIndex dialogAction =
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
        , if isEdited then
            viewManipulateButtons "action" (DialogEdit << OptionEdit << ActionsManipulation) optionIndex

          else
            text ""
        , button [ onClick <| DialogEdit <| OptionEdit <| OptionActionStartEdit dialogAction ] [ text "Edit Action" ]
        ]


viewExpression : Expression -> Html msg
viewExpression expression =
    span [ class "de-dialog-condition" ] [ text <| elipsisText <| ScreeptV2.stringifyExpression expression ]
