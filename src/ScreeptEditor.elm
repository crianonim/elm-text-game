module ScreeptEditor exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, button, div, pre, span, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Encode as E
import ParsedEditable
import Parser
import Random
import Screept exposing (..)
import Stack


type alias Model =
    { statementEditor : ParsedEditable.Model Statement
    , intValueEditor : ParsedEditable.Model IntValue
    , value : Maybe Int
    }


type Msg
    = StatementEditor ParsedEditable.Msg
    | IntValueEditor ParsedEditable.Msg
    | ClickRun


init : Model
init =
    { statementEditor = ParsedEditable.init "" Screept.statementParser
    , intValueEditor = ParsedEditable.init "" Screept.intValueParser
    , value = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        StatementEditor m ->
            { model | statementEditor = ParsedEditable.update m model.statementEditor }

        IntValueEditor m ->
            { model | intValueEditor = ParsedEditable.update m model.intValueEditor }

        ClickRun ->
            { model | value = Maybe.andThen (\r -> Screept.getMaybeIntValue r gameState) (Maybe.andThen Result.toMaybe model.intValueEditor.parsed) }


view : Model -> Html Msg
view model =
    div []
        [ ParsedEditable.view model.intValueEditor |> Html.map IntValueEditor
        , button [ onClick ClickRun ] [ text "RUN" ]
        , Maybe.map (\x -> text (String.fromInt x)) model.value |> Maybe.withDefault (text "not run")
        ]



--
--viewStatement : Statement -> Html msg
--viewStatement statement =
--    case statement of
--        SetCounter textValue intValue ->
--            pre [] [ text "SET ", viewTextValue textValue, text " = ", viewIntValue intValue ]
--
--        SetLabel label value ->
--            pre [] [ text "LABEL ", viewTextValue label, text " = ", viewTextValue value ]
--
--        Rnd textValue min max ->
--            pre [] [ text "RND ", viewTextValue textValue, text " ", viewIntValue min, text " .. ", viewIntValue max ]
--
--        Block statements ->
--            pre [] ([ pre [] [ text "{" ] ] ++ List.map viewStatement statements ++ [ pre [] [ text "}" ] ])
--
--        If condition success failure ->
--            div []
--                [ span [] [ text "IF ", viewIntValue condition ]
--                , div [ class "screept_condition" ] [ viewStatement success ]
--                , if failure == None then
--                    text ""
--
--                  else
--                    div [] [ text "ELSE ", div [ class "screept_condition" ] [ viewStatement failure ] ]
--                ]
--
--        None ->
--            text "Nop"
--
--        Comment string ->
--            text ("#" ++ string)
--
--        Procedure procedureCall ->
--            -- TODO
--            text "procedurecall"
--
--        SetFunc textValue intValue ->
--            -- TODO
--            text "procedurecall"
--
--
--viewTextValue : TextValue -> Html msg
--viewTextValue textValue =
--    case textValue of
--        S string ->
--            text <| "\"" ++ string ++ "\""
--
--        Concat textValues ->
--            span [] <| List.map (\v -> viewTextValue v) textValues
--
--        Conditional condition value altValue ->
--            span [] [ text "(", viewIntValue condition, text "?", viewTextValue value, text ":", viewTextValue altValue, text ")" ]
--
--        IntValueText intValue ->
--            span [] [ viewIntValue intValue ]
--
--        Label string ->
--            text <| "#" ++ string
--
--
--viewIntValue : IntValue -> Html msg
--viewIntValue intValue =
--    case intValue of
--        Const int ->
--            text <| String.fromInt int
--
--        Counter string ->
--            text <| "$" ++ string
--
--        _ ->
--            text "TODO"
--
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
--
--viewIntValueEditor : IntValueModel -> Html Msg
--viewIntValueEditor intValueModel =


exampleCounters : Dict String Int
exampleCounters =
    [ ( "turn", 1 )
    , ( "rnd", 0 )
    , ( "raining", 0 )
    , ( "killed_dragon", 1 )
    , ( "money", 16 )
    , ( "wood", 10 )
    , ( "stone", 9 )
    , ( "sticks", 0 )
    , ( "axe", 0 )
    , ( "pickaxe", 0 )
    , ( "start_look_around", 0 )
    , ( "start_search_bed", 0 )
    , ( "player_rank", 3 )
    , ( "player_stamina", 3 )
    , ( "player_defence", 7 )
    , ( "player_charisma", 5 )
    , ( "player_combat", 5 )
    , ( "player_magic", 2 )
    , ( "player_sanctity", 3 )
    , ( "player_scouting", 6 )
    , ( "player_thievery", 4 )
    , ( "inv_spear", 1 )
    , ( "inv_leather_jerkin", 1 )
    , ( "defeated_goblin", 0 )
    , ( "taken_goblin_treasure", 0 )
    , ( "defeated_wolf", 0 )
    , ( "codeword_apple", 0 )
    , ( "codeword_aspen", 0 )
    ]
        |> Dict.fromList


exampleLabels : Dict String String
exampleLabels =
    [ ( "player_name", "Liana" )
    , ( "player proffesion", "wayfarer" )
    , ( "enemy_marker", "" )
    , ( "enemy_name", "" )
    ]
        |> Dict.fromList


procedures : Dict String Statement
procedures =
    [ ( "test"
      , Screept.Block
            [ Screept.Rnd (S "d6_1") (Const 1) (Const 6)
            , Screept.Rnd (S "d6_2") (Const 1) (Const 6)
            , Screept.SetCounter (S "2d6") (Binary (Counter "d6_1") Add (Counter "d6_2"))
            , Screept.If (Screept.Binary (Binary (Counter "2d6") Add (Counter "test_score")) Screept.Gt (Counter "test_difficulty"))
                (Screept.SetCounter (S "test_success") (Const 1))
                (Screept.SetCounter (S "test_success") (Const 0))
            ]
      )
    , ( "combat_reset"
      , Screept.Block
            [ Screept.SetCounter (S "fight_won") (Const 0)
            , Screept.SetCounter (S "fight_lost") (Const 0)
            , Screept.SetLabel (S "enemy_name") (S "")
            ]
      )
    , ( "combat"
      , Screept.Block
            [ Screept.Rnd (S "rnd_d6_1") (Const 1) (Const 6)
            , Screept.Rnd (S "rnd_d6_2") (Const 1) (Const 6)
            , Screept.SetCounter (S "rnd_2d6") (Binary (Counter "rnd_d6_1") Add (Counter "rnd_d6_2"))
            , Screept.SetCounter (S "player_attack") (Binary (Counter "rnd_2d6") Add (Counter "player_combat"))
            , Screept.SetCounter (S "player_damage") (Binary (Counter "player_attack") Sub (Counter "enemy_defence"))
            , Screept.If (Binary (Counter "player_damage") Gt (Const 0))
                (Screept.Block
                    [ Screept.SetCounter (S "enemy_stamina") (Binary (Counter "enemy_stamina") Sub (Counter "player_damage"))
                    ]
                )
                (Screept.Block [])
            , Screept.If (Unary Not (Eval "combat_player_success"))
                (Screept.Block
                    [ Screept.Rnd (S "rnd_d6_1") (Const 1) (Const 6)
                    , Screept.Rnd (S "rnd_d6_2") (Const 1) (Const 6)
                    , Screept.SetCounter (S "rnd_2d6") (Binary (Counter "rnd_d6_1") Add (Counter "rnd_d6_2"))
                    , Screept.SetCounter (S "enemy_attack") (Binary (Counter "rnd_2d6") Add (Counter "enemy_combat"))
                    , Screept.SetCounter (S "enemy_damage") (Binary (Counter "enemy_attack") Sub (Counter "player_defence"))
                    , Screept.If (Binary (Counter "enemy_damage") Gt (Const 0))
                        (Screept.Block
                            [ Screept.SetCounter (S "player_stamina") (Binary (Counter "player_stamina") Sub (Counter "enemy_damage"))
                            , Screept.If (Binary (Counter "player_stamina") Lt (Const 1)) (Screept.SetCounter (S "fight_lost") (Const 1)) (Screept.Block [])
                            ]
                        )
                        (Screept.Block [])
                    ]
                )
                (Screept.Block [])
            , Screept.If (Eval "combat_player_success")
                (Screept.Block
                    [ Screept.SetCounter (S "enemy_damage") (Const 0)
                    , Screept.SetCounter (S "fight_won") (Const 1)
                    ]
                )
                (Screept.If (Eval "combat_player_failure")
                    (Screept.Block
                        [ Screept.SetCounter (S "fight_lost") (Const 1)
                        ]
                    )
                    (Screept.Block [])
                )
            ]
      )
    ]
        |> Dict.fromList


gameState =
    { counters = exampleCounters
    , labels = exampleLabels
    , dialogStack = Stack.initialise
    , messages = []
    , procedures = procedures
    , functions = Dict.empty
    , rnd = Random.initialSeed 666
    }
