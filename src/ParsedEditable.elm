module ParsedEditable exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Monocle.Compose exposing (optionalWithLens)
import Monocle.Lens exposing (Lens)
import Monocle.Optional as Optional exposing (Optional)
import Parser exposing ((|.))


type alias Model a =
    { text : String
    , old : a
    , new : Result (List Parser.DeadEnd) a
    , parser : Parser.Parser a
    , formatter : a -> String
    }


type Msg
    = FormatClick
    | TextEdit String
    | Revert


init : a -> Parser.Parser a -> (a -> String) -> Model a
init item parser formatter =
    { text = formatter item
    , old = item
    , new = Ok item
    , parser = parser |. Parser.end
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
            { model | new = parsed, text = text }

        TextEdit v ->
            { model | text = v, new = Parser.run model.parser v }

        Revert ->
            revert model


revert : Model a -> Model a
revert model =
    { model | new = Ok model.old, text = model.formatter model.old }


isChanged : Model a -> Bool
isChanged model =
    case model.new of
        Ok new ->
            model.old /= new

        _ ->
            False


model_new : Optional (Model a) a
model_new =
    { getOption = \m -> Result.toMaybe m.new
    , set = \s m -> { m | new = Ok s }
    }


model_old : Lens (Model a) a
model_old =
    Lens .old (\s m -> { m | old = s })


view : Model a -> Html Msg
view model =
    div []
        [ textarea [ value model.text, onInput TextEdit, style "width" "100%", style "height" "10em", style "font-family" "monospace" ] []
        , button [ onClick FormatClick ] [ text "Format" ]
        , button [ onClick Revert ] [ text "Revert" ]
        , case model.new of
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
