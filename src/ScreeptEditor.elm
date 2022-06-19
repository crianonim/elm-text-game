module ScreeptEditor exposing (..)

import Html exposing (Html, div, pre, span, text)
import Html.Attributes exposing (class)
import Json.Encode as E
import Screept exposing (..)


type alias Model =
    { screept : Statement
    }


init : Model
init =
    { screept = example }


view : Statement -> Html msg
view statement =
    case statement of
        SetCounter textValue intValue ->
            pre [] [ text "set ", viewTextValue textValue, text " = ", viewIntValue intValue ]

        SetLabel label value ->
            pre [] [ text "set ", viewTextValue label, text " = ", viewTextValue value ]

        Rnd textValue min max ->
            pre [] [ text "RND ", viewTextValue textValue, text " ", viewIntValue min, text " .. ", viewIntValue max ]

        Block statements ->
            pre [ class "screept-statement-block" ] (List.map view statements)

        If condition success failure ->
            div []
                [ span [] [ text "IF ", viewCondition condition ]
                , div [ class "screept_condition" ] [ view success ]
                , if failure == None then
                    text ""

                  else
                    div [] [ text "ELSE ", div [ class "screept_condition" ] [ view failure ] ]
                ]

        None ->
            text "Nop"

        Comment string ->
            text ("#" ++ string)


viewTextValue : TextValue -> Html msg
viewTextValue textValue =
    case textValue of
        S string ->
            text <| "\"" ++ string ++ "\""

        Special textValues ->
            span [] <| List.map (\v -> viewTextValue v) textValues

        Conditional condition value ->
            span [] [ text "(", viewCondition condition, text "?", viewTextValue value, text ")" ]

        IntValueText intValue ->
            span [] [ viewIntValue intValue ]

        Label string ->
            text <| "#" ++ string


viewIntValue : IntValue -> Html msg
viewIntValue intValue =
    case intValue of
        Const int ->
            text <| String.fromInt int

        Counter string ->
            text <| "$" ++ string

        Addition x y ->
            span [] [ viewIntValue x, text " + ", viewIntValue y ]

        Subtraction x y ->
            span [] [ viewIntValue x, text " - ", viewIntValue y ]


viewPredicateOp : PredicateOp -> Html msg
viewPredicateOp predicateOp =
    case predicateOp of
        Eq ->
            text "=="

        Gt ->
            text ">"

        Lt ->
            text "<"


viewCondition : Condition -> Html msg
viewCondition condition =
    case condition of
        Predicate x predicateOp y ->
            span [] [ viewIntValue x, viewPredicateOp predicateOp, viewIntValue y ]

        NOT c ->
            span [] [ text "NOT", viewCondition c ]

        AND conditions ->
            span [] [ text "AND", span [] <| List.map viewCondition conditions ]

        OR conditions ->
            span [] [ text "OR", span [] <| List.map viewCondition conditions ]
