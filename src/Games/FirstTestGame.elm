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
    , ( "player_stamina", 19 )
    , ( "player_defence", 7 )
    , ( "player_combat", 5 )
    , ( "defeated_goblin", 0 )
    , ( "taken_goblin_treasure", 0 )
    , ("defeated_wolf",0)
    ]
        |> Dict.fromList


exampleLabels : Dict String String
exampleLabels =
    [ ( "player_name", "Jan" )
    , ( "enemy_marker", "" )
    , ( "enemy_name", "" )
    ]
        |> Dict.fromList


initialGameState : GameState
initialGameState =
    { counters = exampleCounters
    , labels = exampleLabels
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
            , { text = S "Combat", condition = Nothing, action = [ fightGoblin, GoAction "combat" ] }
            , { text = S "Goblin Cave", condition = Nothing, action = [ GoAction "goblin_cave" ] }
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
              , condition = Just <|nonZero (Counter "defeated_wolf")
              , action =
                    [ Screept <|
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
              , {text = S "Fight Wolf", condition = Just <| zero (Counter "defeated_wolf"), action = [fightWolf, GoAction "combat"]}
            , backOption
            ]
      }
    , { id = "combat"
      , text = Special [ S "Combat. ", S "You are fighting ", Label "enemy_name", S " .You have ", GameValueText (Counter "player_stamina"), S " stamina. ", S "Your enemy ", GameValueText (Counter "enemy_stamina") ]
      , options =
            [ { text = S "Hit enemy"
              , condition = Just <| AND [ Predicate (Counter "fight_won") Lt (Const 1), Predicate (Counter "fight_lost") Lt (Const 1) ]
              , action =
                    [ Screept <|
                        Screept.Block
                            [ Screept.Rnd (S "rnd_d6_1") (Const 1) (Const 6)
                            , Screept.Rnd (S "rnd_d6_2") (Const 1) (Const 6)
                            , Screept.SetCounter (S "rnd_2d6") (Addition (Counter "rnd_d6_1") (Counter "rnd_d6_2"))
                            , Screept.SetCounter (S "player_attack") (Addition (Counter "rnd_2d6") (Counter "player_combat"))
                            , Screept.SetCounter (S "player_damage") (Subtraction (Counter "player_attack") (Counter "enemy_defence"))
                            , Screept.If (Predicate (Counter "player_damage") Gt (Const 0))
                                (Screept.Block
                                    [ Screept.SetCounter (S "enemy_stamina") (Subtraction (Counter "enemy_stamina") (Counter "player_damage"))
                                    ]
                                )
                                Screept.None
                            , Screept.If (Predicate (Counter "enemy_stamina") Gt (Const 0))
                                (Screept.Block
                                    [ Screept.Rnd (S "rnd_d6_1") (Const 1) (Const 6)
                                    , Screept.Rnd (S "rnd_d6_2") (Const 1) (Const 6)
                                    , Screept.SetCounter (S "rnd_2d6") (Addition (Counter "rnd_d6_1") (Counter "rnd_d6_2"))
                                    , Screept.SetCounter (S "enemy_attack") (Addition (Counter "rnd_2d6") (Counter "enemy_combat"))
                                    , Screept.SetCounter (S "enemy_damage") (Subtraction (Counter "enemy_attack") (Counter "player_defence"))
                                    , Screept.If (Predicate (Counter "enemy_damage") Gt (Const 0))
                                        (Screept.Block
                                            [ Screept.SetCounter (S "player_stamina") (Subtraction (Counter "player_stamina") (Counter "enemy_damage"))
                                            , Screept.If (Predicate (Counter "player_stamina") Lt (Const 1)) (Screept.SetCounter (S "fight_lost") (Const 1)) Screept.None
                                            ]
                                        )
                                        Screept.None
                                    ]
                                )
                                (Screept.Block
                                    [ Screept.SetCounter (S "enemy_damage") (Const 0)
                                    , Screept.SetCounter (S "fight_won") (Const 1)
                                    , Screept.SetCounter (Label "enemy_marker") (Const 1)
                                    ]
                                )
                            ]
                    , Message <| Conditional (Predicate (Counter "player_damage") Gt (Const 0)) (Special [ S "You dealt ", GameValueText (Counter "player_damage"), S " damage" ])
                    , Message <| Conditional (Predicate (Counter "enemy_damage") Gt (Const 0)) (Special [ S "You were dealt ", GameValueText (Counter "enemy_damage"), S " damage" ])
                    ]
              }
            , { text = S "You won!", condition = Just <| Predicate (Counter "fight_won") Gt (Const 0), action = [Screept <| Screept.SetCounter (S "fight_won") (Const 0), GoBackAction ] }
            , { text = S "You lost!", condition = Just <| Predicate (Counter "fight_lost") Gt (Const 0), action = [] }
            ]
      }
    , { id = "goblin_cave"
      , text = S "Goblin Cave"
      , options =
            [ { text = S "Fight Goblin", condition = Just <| zero (Counter "defeated_goblin"), action = [ fightGoblin, GoAction "combat" ] }
            , { text = S "Take treasure"
              , condition = Just <| AND [ nonZero (Counter "defeated_goblin"), zero (Counter "taken_goblin_treasure") ]
              , action =
                    [ Screept <|
                        Screept.Block
                            [ Screept.SetCounter (S "taken_goblin_treasure") (Const 1)
                            , Screept.SetCounter (S "money") (Addition (Counter "money") (Const 10))
                            ]
                    ]
              }
            ]
      }
    ]


fightGoblin : DialogActionExecution
fightGoblin =
    Screept <|
        Screept.Block
            [ Screept.SetCounter (S "enemy_stamina") (Const 10)
            , Screept.SetCounter (S "enemy_defence") (Const 6)
            , Screept.SetCounter (S "enemy_combat") (Const 6)
            , Screept.SetCounter (S "fight_won") (Const 0)
            , Screept.SetCounter (S "fight_lost") (Const 0)
            , Screept.SetLabel (S "enemy_marker") (S "defeated_goblin")
            , Screept.SetLabel (S "enemy_name") (S "Old Goblin")
            ]

fightWolf : DialogActionExecution
fightWolf =
    Screept <|
        Screept.Block
            [ Screept.SetCounter (S "enemy_stamina") (Const 4)
            , Screept.SetCounter (S "enemy_defence") (Const 6)
            , Screept.SetCounter (S "enemy_combat") (Const 5)
            , Screept.SetCounter (S "fight_won") (Const 0)
            , Screept.SetCounter (S "fight_lost") (Const 0)
            , Screept.SetLabel (S "enemy_marker") (S "defeated_wolf")
            , Screept.SetLabel (S "enemy_name") (S "Wild Wolf")
            ]

backOption : DialogOption
backOption =
    { text = S "Go back", condition = Nothing, action = [ GoBackAction ] }
