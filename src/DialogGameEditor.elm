module DialogGameEditor exposing (..)

import DialogGame exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)
import Screept exposing (..)


type alias Model =
    { dialog : Maybe DialogGame.Dialog
    , id : String
    , text : String
    }


type Msg
    = Edit DialogGame.Dialog
    | Save
    | Cancel


init : Model
init =
    { dialog = Nothing
    , id = ""
    , text = ""
    }



--
--exampleDialog =
--    { id = "start"
--    , text = Screept.Special [ Screept.S "You're in a dark room. ", Screept.Conditional (DialogGame.zero (Counter "start_look_around")) (S "You see nothing. "), Conditional (nonZero (Counter "start_look_around")) (S "You see a straw bed. "), Conditional (nonZero (Counter "start_search_bed")) (S "There is a rusty key among the straw. ") ]
--    , options =
--        [ { text = Screept.S "Go through the exit", condition = Just (nonZero (Counter "start_look_around")), action = [ GoAction "second" ] }
--        , { text = Screept.S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ Screept <| Screept.inc "start_look_around", Message <| Screept.S "You noticed a straw bed", Turn 5, Screept <| Screept.Rnd (S "rrr") (Const 1) (Const 5) ] }
--        , { text = Screept.S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), DialogGame.nonZero (Counter "start_look_around") ]), action = [ Screept <| Screept.inc "start_search_bed" ] }
--        ]
--    }


exampleDialog =
    { id = "start"
    , text = Screept.Special [ Screept.S "You're in a dark room. " ]
    , options =
        [ { text = Screept.S "Go through the exit", condition = Just (Counter "start_look_around"), action = [ GoAction "second" ] }

        --, { text = Screept.S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ Screept <| Screept.inc "start_look_around", Message <| Screept.S "You noticed a straw bed", Turn 5, Screept <| Screept.Rnd (S "rrr") (Const 1) (Const 5) ] }
        --, { text = Screept.S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), DialogGame.nonZero (Counter "start_look_around") ]), action = [ Screept <| Screept.inc "start_search_bed" ] }
        ]
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Edit dialog ->
            { model | dialog = Just dialog, id = dialog.id, text = "dialog.text" }

        Save ->
            model

        Cancel ->
            model


viewDialog : Model -> Html Msg
viewDialog model =
    case model.dialog of
        Nothing ->
            button [ onClick <| Edit exampleDialog ] [ text "Edit" ]

        Just d ->
            div []
                [ div [] [ text "id: ", text d.id ]
                ]
