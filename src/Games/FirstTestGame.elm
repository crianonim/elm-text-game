module Games.FirstTestGame exposing (..)

import Dict exposing (Dict)
import Game exposing (..)
import Stack


type FirstActions
    = Turn Int
    | Other


executeCustomAction : FirstActions -> GameState -> GameState
executeCustomAction dialogActionExecution gameState =
    case dialogActionExecution of
        Turn amount ->
            let
                passTurn : Int -> GameState -> GameState
                passTurn i gs =
                    if i == 0 then
                        gs

                    else
                        let
                            turn =
                                getGameValueWithDefault (Counter "turn") gs

                            _ =
                                Debug.log "turn" turn

                            newGs =
                                List.foldl
                                    (\( t, fn ) acc ->
                                        if modBy t turn == 0 then
                                            fn acc

                                        else
                                            acc
                                    )
                                    gs
                                    turnActions
                                    |> addCounter "turn" 1
                        in
                        passTurn (i - 1) newGs
            in
            passTurn amount gameState

        Other ->
            gameState


turnActions : List ( Int, GameState -> GameState )
turnActions =
    [ ( 1
      , \gs ->
            let
                _ =
                    Debug.log "Turn passed" "1"
            in
            gs
      )
    , ( 2
      , \gs ->
            let
                _ =
                    Debug.log "Even Turn passed" "2"
            in
            gs
      )
    ]


exampleCounters : Dict String Int
exampleCounters =
    [ ( "turn", 1 )
    , ( "raining", 0 )
    , ( "killed_dragon", 1 )
    , ( "money", 40 )
    , ( "wood", 10 )
    , ( "stone", 9 )
    , ( "axe", 0 )
    , ( "pickaxe", 0 )
    , ( "start_look_around", 0 )
    , ( "start_search_bed", 0 )
    ]
        |> Dict.fromList


exampleGameState : GameState
exampleGameState =
    { counters = exampleCounters, dialogStack = Stack.push "start" Stack.initialise, messages = exampleMessages }


exampleMessages : List String
exampleMessages =
    [ "Last one I promise"
    , "Need more messages to see the scrolling"
    , "Third message"
    , "Second message that is a bit longer than the first one so will probably overflow and we need to deal with that, especially that I will repeat it twice. Second message that is a bit longer than the first one so will probably overflow and we need to deal with that, especially that I will repeat it twice."
    , "First message test"
    ]


recipes : List ( String, List ( String, Int ) )
recipes =
    [ ( "axe", [ ( "wood", 2 ), ( "stone", 1 ) ] )
    , ( "pickaxe", [ ( "wood", 2 ), ( "stone", 2 ) ] )
    ]


dialogExamples : List (Dialog FirstActions)
dialogExamples =
    [ { id = "start"
      , text = Special [ S "You're in a dark room. ", Conditional (zero (Counter "start_look_around")) (S "You see nothing. "), Conditional (nonZero (Counter "start_look_around")) (S "You see a straw bed. "), Conditional (nonZero (Counter "start_search_bed")) (S "There is a rusty key among the straw. ") ]
      , options =
            [ { text = S "Go through the exit", condition = Just (nonZero (Counter "start_look_around")), action = [ GoAction "second" ] }
            , { text = S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ inc1 "start_look_around", Message "You noticed a straw bed", CustomAction (Turn 7) ] }
            , { text = S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), nonZero (Counter "start_look_around") ]), action = [ inc1 "start_search_bed" ] }
            , { text = S "Spend money", condition = Nothing, action = [ Inc "money" (Counter "turn"), Inc "money" (Counter "wood"), GoAction "third" ] }
            , { text = S "Craft", condition = Nothing, action = [ GoAction "craft" ] }
            ]
      }
    , { id = "second"
      , text = S "You're at second"
      , options =
            [ { text = S "Go start", condition = Nothing, action = [ Inc "turn" (Const 1), GoAction "start" ] }
            , { text = S "Go third", condition = Nothing, action = [ GoAction "third" ] }
            , backOption
            ]
      }
    , { id = "third", text = S "You're at third", options = [ { text = S "Go start", condition = Nothing, action = [ GoAction "start" ] } ] }
    , { id = "craft"
      , text = S "You can craft items"
      , options = List.map recipeToDialogOption recipes ++ [ backOption ]
      }
    ]


backOption : DialogOption a
backOption =
    { text = S "Go back", condition = Nothing, action = [ GoBackAction ] }
