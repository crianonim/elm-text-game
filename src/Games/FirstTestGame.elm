module Games.FirstTestGame exposing (..)

import Dict exposing (Dict)
import Game exposing (..)
import Random
import Screept exposing (Condition(..), IntValue(..), PredicateOp(..), TextValue(..))
import Stack


config : GameConfig
config =
    { turnCallback = processTurn
    , showMessages = True
    }


processTurn : Int -> GameState -> GameState
processTurn turn gameState =
    let
        _ =
            Debug.log "Processing turn " turn
    in
    List.foldl
        (\( t, fn ) acc ->
            if modBy t turn == 0 then
                fn acc

            else
                acc
        )
        gameState
        turnActions


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
    , ( "rnd", 0 )
    , ( "raining", 0 )
    , ( "killed_dragon", 1 )
    , ( "money", 40 )
    , ( "wood", 10 )
    , ( "stone", 9 )
    , ( "sticks", 0 )
    , ( "axe", 0 )
    , ( "pickaxe", 0 )
    , ( "start_look_around", 0 )
    , ( "start_search_bed", 0 )
    ]
        |> Dict.fromList


initialGameState : GameState
initialGameState =
    { counters = exampleCounters
    , dialogStack = Stack.push "start" Stack.initialise
    , messages = exampleMessages
    , rnd = Random.initialSeed 666
    }


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


dialogs : List Dialog
dialogs =
    [ { id = "start"
      , text = Special [ S "You're in a dark room. ", Conditional (zero (Counter "start_look_around")) (S "You see nothing. "), Conditional (nonZero (Counter "start_look_around")) (S "You see a straw bed. "), Conditional (nonZero (Counter "start_search_bed")) (S "There is a rusty key among the straw. ") ]
      , options =
            [ { text = S "Go through the exit", condition = Just (nonZero (Counter "start_look_around")), action = [ GoAction "second" ] }
            , { text = S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ Screept <| Screept.inc "start_look_around", Message <| S "You noticed a straw bed", Turn 5, Screept <| Screept.Rnd (S "rrr") (Const 1) (Const 5) ] }
            , { text = S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), nonZero (Counter "start_look_around") ]), action = [ Screept <| Screept.inc "start_search_bed" ] }
            , { text = S "Spend money", condition = Nothing, action = [ Screept <| Screept.Block [ Screept.inc "money", Screept.inc "money" ], GoAction "third" ] }
            , { text = S "Craft", condition = Nothing, action = [ GoAction "craft" ] }
            , { text = S "Forest", condition = Nothing, action = [ GoAction "forest" ] }
            , { text = S "Test Screept"
              , condition = Nothing
              , action =
                    [ Screept <|
                        Screept.Block
                            [ Screept.Rnd (S "rnd_1") (Const 0) (Const 1)
                            , Screept.If (Predicate (Counter "rnd_1") Eq (Const 1)) (Screept.SetCounter (S "rnd_s") (Const 100)) (Screept.SetCounter (S "rnd_s") (Const 200))
                            ]
                    ]
              }
            ]
      }
    , { id = "second"
      , text = S "You're at second"
      , options =
            [ { text = S "Go start", condition = Nothing, action = [ Screept <| Screept.SetCounter (S "turn") (Screept.Addition (Counter "turn") (Const 1)), GoAction "start" ] }
            , { text = S "Go third", condition = Nothing, action = [ GoAction "third" ] }
            , backOption
            ]
      }
    , { id = "third", text = S "You're at third", options = [ { text = S "Go start", condition = Nothing, action = [ GoAction "start" ] } ] }
    , { id = "craft"
      , text = S "You can craft items"
      , options = List.map recipeToDialogOption recipes ++ [ backOption ]
      }
    , { id = "forest"
      , text = S "Has trees"
      , options =
            [ { text = S "Forage"
              , condition = Nothing
              , action =
                    [ --rndInts "rnd_wood" 0 5
                      --, incCounter "wood" (Counter "rnd_wood")
                      --, rndInts "rnd_sticks" 0 5
                      --, incCounter "sticks" (Counter "rnd_sticks")
                      Screept <|
                        Screept.Block
                            [ Screept.Rnd (S "rnd_wood") (Const 0) (Const 5)
                            , Screept.SetCounter (S "wood") (Addition (Counter "wood") (Counter "rnd_wood"))
                            , Screept.Rnd (S "rnd_sticks") (Const 0) (Const 5)
                            , Screept.SetCounter (S "sticks") (Addition (Counter "sticks") (Counter "rnd_sticks"))
                            ]
                    , Turn 4
                    , Message <| Special [ S "You found ", GameValueText (Counter "rnd_wood"), S " of wood and ", GameValueText (Counter "rnd_sticks"), S " of sticks." ]
                    ]
              }
            , backOption
            ]
      }
    ]


backOption : DialogOption
backOption =
    { text = S "Go back", condition = Nothing, action = [ GoBackAction ] }
