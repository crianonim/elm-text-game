module ParsedEditable exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Parser


type alias Model a =
    { text : String
    , parsed : Result (List Parser.DeadEnd) a
    , parser : Parser.Parser a
    , formatter : a -> String
    }


type Msg
    = FormatClick
    | TextEdit String


init : String -> Parser.Parser a -> (a -> String) -> Model a
init text parser formatter =
    { text = text
    , parsed = Parser.run parser text
    , parser = parser
    , formatter = formatter
    }


update : Msg -> Model a -> Model a
update msg model =
    case msg of
        FormatClick ->
            let
                parsed =
                    Parser.run model.parser model.text

                text =
                    case parsed of
                        Ok t ->
                            model.formatter t

                        _ ->
                            model.text
            in
            { model | parsed = parsed, text = text }

        TextEdit v ->
            { model | text = v, parsed = Parser.run model.parser v }


view : Model a -> Html Msg
view model =
    div []
        [ textarea [ value model.text, onInput TextEdit, style "width" "100%", style "height" "10em", style "font-family" "monospace" ] []
        , button [ onClick FormatClick ] [ text "Format" ]
        , case model.parsed of
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
