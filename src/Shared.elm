module Shared exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import List.Extra


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
