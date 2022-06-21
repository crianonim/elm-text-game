module ScreeptEditor exposing (..)

import Html exposing (Html, button, div, pre, span, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Encode as E
import Parser
import Screept exposing (..)


type alias Model =
    { text : String
    , parsed : Maybe (Result (List Parser.DeadEnd) Statement)
    }


type Msg
    = ParseClick
    | TextEdit String


init : Model
init =
    { text = Screept.customCombatString
    , parsed = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ParseClick ->
            { model | parsed = Just <| Parser.run Screept.statementParser model.text }

        TextEdit v ->
            { model | text = v }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick ParseClick ] [ text "Parse" ]
        , textarea [ value model.text, onInput TextEdit, style "width" "100%", style "height" "10em", style "font-family" "monospace" ] []
        , case model.parsed of
            Nothing ->
                text ""

            Just a ->
                case a of
                    Ok _ ->
                        text "Parsed ok"

                    Err errors ->
                        let
                            viewProblem { row, col, problem } =
                                div [] [ text <| "row: " ++ String.fromInt row ++ ", col: " ++ String.fromInt col ++ ", problem: " ++ problemToString problem ]
                        in
                        div [] (List.map viewProblem errors)
        ]


viewStatement : Statement -> Html msg
viewStatement statement =
    case statement of
        SetCounter textValue intValue ->
            pre [] [ text "SET ", viewTextValue textValue, text " = ", viewIntValue intValue ]

        SetLabel label value ->
            pre [] [ text "LABEL ", viewTextValue label, text " = ", viewTextValue value ]

        Rnd textValue min max ->
            pre [] [ text "RND ", viewTextValue textValue, text " ", viewIntValue min, text " .. ", viewIntValue max ]

        Block statements ->
            pre [] ([ pre [] [ text "{" ] ] ++ List.map viewStatement statements ++ [ pre [] [ text "}" ] ])

        If condition success failure ->
            div []
                [ span [] [ text "IF ", viewIntValue condition ]
                , div [ class "screept_condition" ] [ viewStatement success ]
                , if failure == None then
                    text ""

                  else
                    div [] [ text "ELSE ", div [ class "screept_condition" ] [ viewStatement failure ] ]
                ]

        None ->
            text "Nop"

        Comment string ->
            text ("#" ++ string)

        Procedure procedureCall ->
            -- TODO
            text "procedurecall"

        SetFunc textValue intValue ->
            -- TODO
            text "procedurecall"


viewTextValue : TextValue -> Html msg
viewTextValue textValue =
    case textValue of
        S string ->
            text <| "\"" ++ string ++ "\""

        Concat textValues ->
            span [] <| List.map (\v -> viewTextValue v) textValues

        Conditional condition value altValue ->
            span [] [ text "(", viewIntValue condition, text "?", viewTextValue value, text ":", viewTextValue altValue, text ")" ]

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

        _ ->
            text "TODO"



--- TODO
--Addition x y ->
--    span [] [ viewIntValue x, text " + ", viewIntValue y ]
--
--Subtraction x y ->
--    span [] [ viewIntValue x, text " - ", viewIntValue y ]
--
--viewPredicateOp : PredicateOp -> Html msg
--viewPredicateOp predicateOp =
--    case predicateOp of
--        Eq ->
--            text "=="
--
--        Gt ->
--            text ">"
--
--        Lt ->
--            text "<"
--
--viewCondition : Condition -> Html msg
--viewCondition condition =
--    case condition of
--        Predicate x predicateOp y ->
--            span [] [ viewIntValue x, viewPredicateOp predicateOp, viewIntValue y ]
--
--        NOT c ->
--            span [] [ text "NOT", viewCondition c ]
--
--        AND conditions ->
--            span [] [ text "AND", span [] <| List.map viewCondition conditions ]
--
--        OR conditions ->
--            span [] [ text "OR", span [] <| List.map viewCondition conditions ]
--


problemToString : Parser.Problem -> String
problemToString problem =
    case problem of
        Parser.Expecting string ->
            "Expecting " ++ string

        Parser.ExpectingInt ->
            "Expecting Int "

        Parser.ExpectingHex ->
            "ExpectingHex"

        Parser.ExpectingOctal ->
            "ExpectingOctal"

        Parser.ExpectingBinary ->
            "ExpectingBinary"

        Parser.ExpectingFloat ->
            "ExpectingFloat"

        Parser.ExpectingNumber ->
            "ExpectingNumber"

        Parser.ExpectingVariable ->
            "ExpectingVariable"

        Parser.ExpectingSymbol string ->
            "ExpectingSymbol " ++ string

        Parser.ExpectingKeyword string ->
            "ExpectingKeyword " ++ string

        Parser.ExpectingEnd ->
            "ExpectingEnd"

        Parser.UnexpectedChar ->
            "UnexpectedChar"

        Parser.Problem string ->
            "Problem " ++ string

        Parser.BadRepeat ->
            "BadRepeat"
