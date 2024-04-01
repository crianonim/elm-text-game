module Styled exposing (..)

import Html exposing (Attribute, Html, button)
import Html.Attributes exposing (class)


btnSmall : List (Attribute msg) -> List (Html msg) -> Html msg
btnSmall attrs =
    button (class "bg-blue-500 hover:bg-blue-700 text-white py-1 px-2 rounded text-sm" :: attrs)
