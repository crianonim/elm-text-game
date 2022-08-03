module Shared exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import List.Extra
import Monocle.Compose exposing (optionalWithLens)
import Monocle.Lens exposing (Lens)
import Monocle.Optional exposing (Optional)
import ParsedEditable
import ScreeptV2 exposing (..)


type ManipulatePositionAction
    = MovePosition Int Int
    | DeletePosition Int
    | NewAt Int


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


insertAt : Int -> a -> List a -> List a
insertAt index item items =
    let
        ( start, end ) =
            List.Extra.splitAt index items
    in
    start ++ [ item ] ++ end


viewManipulateButtons : String -> (ManipulatePositionAction -> msg) -> Int -> Html msg
viewManipulateButtons kind msgWrap index =
    div []
        [ button [ onClick <| msgWrap <| MovePosition index -1 ] [ text <| "Move Up " ++ kind ]
        , button [ onClick <| msgWrap <| MovePosition index 1 ] [ text <| "Move Down " ++ kind ]
        , button [ onClick <| msgWrap <| DeletePosition index ] [ text <| "Delete " ++ kind ]
        , button [ onClick <| msgWrap <| NewAt (index + 1) ] [ text <| "New " ++ kind ]
        ]


lens_editedProcedure : Lens { a | editedProcedure : b } b
lens_editedProcedure =
    Lens .editedProcedure (\s m -> { m | editedProcedure = s })


lens_vars : Lens { a | vars : b } b
lens_vars =
    Lens .vars (\s m -> { m | vars = s })


lens_definition : Lens { a | definition : b } b
lens_definition =
    Lens .definition (\s m -> { m | definition = s })


lens_oldValue : Lens { a | oldValue : b } b
lens_oldValue =
    Lens .oldValue (\s m -> { m | oldValue = s })


optional_editedProcedure : Optional { a | editedProcedure : Maybe b } b
optional_editedProcedure =
    Optional .editedProcedure (\s m -> { m | editedProcedure = Just s })


optional_editedVar : Optional { a | editedVar : Maybe b } b
optional_editedVar =
    Optional .editedVar (\s m -> { m | editedVar = Just s })


lens_gameDefinition : Lens { a | gameDefinition : b } b
lens_gameDefinition =
    Lens .gameDefinition (\s m -> { m | gameDefinition = s })


lens_page : Lens { a | page : b } b
lens_page =
    Lens .page (\s m -> { m | page = s })


parsedEditableExpression : Expression -> ParsedEditable.Model Expression
parsedEditableExpression value =
    ParsedEditable.init value parserExpression stringifyExpression


parsedEditableStatement : Statement -> ParsedEditable.Model Statement
parsedEditableStatement value =
    ParsedEditable.init value parserStatement stringifyStatement


updateOldValueWithTransformation : ({ b | oldValue : a } -> a) -> List a -> { b | oldValue : a } -> List a
updateOldValueWithTransformation fn list new =
    List.Extra.setIf (\x -> x == new.oldValue) (fn new) list


startEditing : a -> Optional a { b | oldValue : c } -> c -> (c -> { b | oldValue : c }) -> a
startEditing model optional_editedValue value fnValueToEditedValue =
    if (optional_editedValue |> optionalWithLens lens_oldValue).getOption model == Just value then
        model

    else
        optional_editedValue.set
            (fnValueToEditedValue value)
            model
