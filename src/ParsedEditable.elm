module ParsedEditable exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Parser


type alias Model a =
    { text : String
    , parsed : Maybe (Result (List Parser.DeadEnd) a)
    , parser : Parser.Parser a
    }


type Msg
    = ParseClick
    | TextEdit String


init : String -> Parser.Parser a -> Model a
init text parser =
    { text = text
    , parsed = Nothing
    , parser = parser
    }


update : Msg -> Model a -> Model a
update msg model =
    case msg of
        ParseClick ->
            { model | parsed = Just <| Parser.run model.parser model.text }

        TextEdit v ->
            { model | text = v,  parsed = Just <| Parser.run model.parser v }


view : Model a -> Html Msg
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
