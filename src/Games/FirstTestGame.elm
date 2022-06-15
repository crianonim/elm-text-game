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


initialGameState : GameState
initialGameState =
    { counters = exampleCounters
    , labels = exampleLabels
    , dialogStack = Stack.push "#630" Stack.initialise
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
            , { text = S "Game", condition = Nothing, action = [ GoAction "#1" ] }
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
              , condition = Just <| nonZero (Counter "defeated_wolf")
              , action =
                    [ Screept <|
                        Screept.Block
                            [ Screept.Rnd (S "rnd_wood") (Const 0) (Const 5)
                            , Screept.SetCounter (S "wood") (Addition (Counter "wood") (Counter "rnd_wood"))
                            , Screept.Rnd (S "rnd_sticks") (Const 0) (Const 5)
                            , Screept.SetCounter (S "sticks") (Addition (Counter "sticks") (Counter "rnd_sticks"))
                            ]
                    , Turn 4
                    , Message <| Special [ S "You found ", IntValueText (Counter "rnd_wood"), S " of wood and ", IntValueText (Counter "rnd_sticks"), S " of sticks." ]
                    ]
              }
            , { text = S "Fight Wolf", condition = Just <| zero (Counter "defeated_wolf"), action = [ fightWolf, GoAction "combat" ] }
            , backOption
            ]
      }
    , standardCombat
    , { id = "combat_old"
      , text = Special [ S "Combat. ", S "You are fighting ", Label "enemy_name", S " .You have ", IntValueText (Counter "player_stamina"), S " stamina. ", S "Your enemy ", IntValueText (Counter "enemy_stamina") ]
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
                    , Message <| Conditional (Predicate (Counter "player_damage") Gt (Const 0)) (Special [ S "You dealt ", IntValueText (Counter "player_damage"), S " damage" ])
                    , Message <| Conditional (Predicate (Counter "enemy_damage") Gt (Const 0)) (Special [ S "You were dealt ", IntValueText (Counter "enemy_damage"), S " damage" ])
                    ]
              }
            , { text = S "You won!", condition = Just <| Predicate (Counter "fight_won") Gt (Const 0), action = [ Screept <| Screept.SetCounter (S "fight_won") (Const 0), GoBackAction ] }
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
    , { id = "#1", text = S """
    The approach of dawn has turned the sky a milky grey-green, like jade. The sea is a luminous pane of silver. Holding the tiller of your sailing boat, you keep your gaze fixed on the glittering constellation known as the Spider. It marks the north, and by keeping it to port you know you are still on course.
    The sun appears in a trembling burst of red fire at the rim of the world. Slowly the chill of night gives way to brazen warmth. You lick your parched lips. There is a little water sloshing in the bottom of the barrel by your feet, but not enough to see you through another day.
    Sealed in a scroll case tucked into your jerkin is the parchment map your grandfather gave to you on his death-bed. You remember his stirring tales of far sea voyages, of kingdoms beyond the western horizon, of sorcerous islands and ruined palaces filled with treasure. As a child you dreamed of nothing else but the magical quests that were in store if you too became an adventurer.
    You never expected to die in an open boat before your adventures even began.
    Securing the tiller, you unroll the map and study it again. You hardly need to. Every detail is etched into your memory by now. According to your reckoning, you should have reached the east coast of Harkuna, the great northern continent, days ago.
    A pasty grey blob splatters on to the map. After a moment of stunned surprise, you look up and curse the seagull circling directly overhead. Then it strikes you – where there’s a seagull, there may be land.
    You leap to your feet and scan the horizon. Sure enough, a line of white cliffs lie a league to the north. Have you been sailing along the coast all this time without realising the mainland was so close?
    Steering towards the cliffs, you feel the boat judder against rough waves. A howling wind whips plumes of spindrift across the sea. Breakers pound the high cliffs. The tiller is yanked out of your hands. The little boat is spun around, out of control, and goes plunging in towards the coast.
    You leap clear at the last second. There is the snap of timber, the roaring crescendo of the waves – and then silence as you go under. Striking out wildly, you try to swim clear of the razor- sharp rocks. For a while the undertow threatens to drag you down, then suddenly a wave catches you and flings you contemptuously up on to the beach.
    Battered and bedraggled you lie gasping for breath until you hear someone walking along the shore towards you. Wary of danger, you lose no time in getting to your feet. Confronting you is an old man clad in a dirty loin-cloth. His eyes have a feverish bright look that is suggestive of either a mystic or a madman.

      """, options = [ { text = S "...", condition = Nothing, action = [ GoAction "#20" ] } ] }
    , { id = "#20"
      , text = S """
      ‘Well, well, well, what have we here, friends?’ asks the old man. He seems to be talking to someone next to him, although you are certain he is alone. ‘Looks like a washed up adventurer to me!’ he says in answer to his own question, ‘all wet and out of luck.’
      He carries on having a conversation – a conversation that quickly turns into a heated debate. He is clearly quite mad.
      ‘Excuse me, umm, EXCUSE ME!,’ you shout above the hubbub in an attempt to grab the old man’s attention. He stops and stares at you.
      ‘Is this the Isle of the Druids?’ you ask impatiently.
      ‘Indeed it is,’ says the old man, ‘I see that you are from a far land so it is up to me to welcome you to Harkuna. But I think you may have much to do here as it is written in the stars that someone like you would come. Your destiny awaits you! Follow me, young adventurer.’
      The old man turns smartly about and begins walking up a path towards some hills. You can just see some sort of monolithic stone structure atop one of them.
      ‘Come on, come one, I’ll show you the Gates of the World,’ the old man babbles.
      """
      , options =
            [ { text = S "Follow him", condition = Nothing, action = [ GoAction "#192" ] }
            , { text = S "Explore the coast", condition = Nothing, action = [ GoAction "#128" ] }
            , { text = S "Head into the nearby forest", condition = Nothing, action = [ GoAction "#257" ] }
            ]
      }
    , { id = "#65"
      , text = S """
    There are three stone gates engraved with ancient runes. Each gate is marked with a name – Yellowport, Marlock City, and Wishport. From here, you can see the coast and the whole island, which is heavily forested
    """
      , options =
            [ { text = S "Explore the coastline", condition = Nothing, action = [ GoAction "#128" ] }
            , { text = S "Head into the forest", condition = Nothing, action = [ GoAction "#257" ] }
            , { text = S "Step through the Yellowport arch", condition = Nothing, action = [ GoAction "#8" ] }
            , { text = S "Step through the Marlock City arch", condition = Nothing, action = [ GoAction "#180" ] }
            , { text = S "Step through the Wishport arch", condition = Nothing, action = [ GoAction "#330" ] }
            ]
      }
    , { id = "#128", text = S """
      You make your way around the coast. The interior of the island appears to be heavily forested. After a while, however, you come to a bay in which a couple of ships are anchored. A small settlement nestles on the beach, and you make your way towards it
      """, options = [ { text = S "...", condition = Nothing, action = [ GoAction "#195" ] } ] }
    , { id = "#148", text = S """
   ‘Stop, stop, I surrender!’ yells the tree. You cease your attack. ‘I guess you can pass, in view of recent events!’ it says grudgingly. Then it uproots itself with a great tearing sound, and shuffles out of the way. ‘There you go!’ mutters the tree, ‘You can blooming well pass.’
   You walk through the thorn bush gate. Beyond, you find several huge oak trees whose branches are so big that they are able to support the homes of many people.
   """, options = [ { text = S "...", condition = Nothing, action = [ Screept <| Screept.SetCounter (S "codeword_apple") (Const 1), GoAction "#358" ] } ] }
    , { id = "#192", text = S """
      During your short trip upward, the old man regales you with tales of your destiny and fate, continuously arguing with himself as he does so.
      You reach a hill covered with a circle of large obsidian standing stones. Despite the bitter wind that blow across these hills the stones are unweathered and seem almost newly lain.
      ‘Here are the Gates of the World.’ says the mad old man.
      The stones are laid in such a way that they form three archways, each carven with mystic symbols and runes of power.
      ‘Each gate will take you to a part of the world of Harkuna, though I know not where,’ explains the old man. Abruptly, he turns around and sets off down the hill, babbling to himself. His voice fades as he descends the hill, leaving you alone with the brooding stones and the howling wind
      """, options = [ { text = S "...", condition = Nothing, action = [ GoAction "#65" ] } ] }
    , { id = "#195"
      , text = S """
      The Trading Post is a small village, set up here by enterprising settlers from the mainland. Its main export appears to be furs from the forest.
      The Mayor, a fat genial fellow, who greets you personally, insists that one day the Trading Post will be a thriving town. There is not a lot here yet, however: a small market, a quay, the settler’s houses, and a shrine to Lacuna the Huntress, goddess of nature.
      """
      , options =
            [ { text = S "...", condition = Just <| zero (Counter "codeword_aspen"), action = [ Screept <| Screept.SetCounter (S "codeword_aspen") (Const 1) ] }
            , { text = S "Visit the shrine to Lacuna", condition = Just <| nonZero (Counter "codeword_aspen"), action = [ GoAction "#544" ] }
            , { text = S "Visit the market", condition = Just <| nonZero (Counter "codeword_aspen"), action = [ GoAction "#452" ] }
            , { text = S "Visit the quayside", condition = Just <| nonZero (Counter "codeword_aspen"), action = [ GoAction "#332" ] }
            , { text = S "Visit the Green Man Inn", condition = Just <| nonZero (Counter "codeword_aspen"), action = [ GoAction "#181" ] }
            , { text = S "Climb the hill that overlooks the town", condition = Just <| nonZero (Counter "codeword_aspen"), action = [ GoAction "#11" ] }
            , { text = S "Go inland, into the Old Forest", condition = Just <| nonZero (Counter "codeword_aspen"), action = [ GoAction "#257" ] }
            ]
      }
    , { id = "#257", text = S """
      The trees are closely packed, leaning together as if in conference, whispering quietly among themselves. Birds twitter in the distance, and slivers of sunlight lance down through the musty gloom.
      As you proceed along a forest track, you think you hear a rustling in the bushes. Later, you spot a shadowy figure darting through the trees – or was it your imagination? An animal snuffling sound right behind you makes you spin round, but there is nothing there.
      """, options = [ { text = S "...", condition = Nothing, action = [ Screept <| testAgainstDifficulty "player_scouting" 10, onTestCondition (GoAction "#630") (GoAction "#36") ] } ] }
    , { id = "#358"
      , text = S """
    ‘Welcome to the City of the Trees,’ says a passing woman, dressed in the garb of a druid.
    The city has been built amid the branches of several mighty oaks. Ladders run up and down the trees to houses that perch like nests in the branches. You are not allowed into any houses, but the druids allow you to barter at the market.
    """
      , options = [ { text = S "Finished shopping", condition = Nothing, action = [] } ]
      }
    , { id = "#630"
      , text = S """
     You struggle deeper into the forest until you come to a thick wall of impenetrable thorn bushes. Circling it, you find there is a break in the hedge, but it is filled by a large tree.
     To your surprise, a face forms in the trunk, and speaks in a woody voice, ‘None can pass – begone, human!’
     """
      , options =
            [ { text = S "...", condition = Just <| nonZero (Counter "codeword_apple"), action = [ GoAction "#594" ] }
            , { text = S "Return to the Trading Post", condition = Just <| zero (Counter "codeword_apple"), action = [ GoAction "#195" ] }
            , { text = S "Attack the tree", condition = Just <| zero (Counter "codeword_apple"), action = [ GoAction "#570" ] }
            , { text = S "Try to persuade it to let you pass", condition = Just <| zero (Counter "codeword_apple"), action = [ GoAction "#237" ] }
            ]
      }
    , { id = "#570"
      , text = S """
           ‘Aargh, you fiendish human!’ roars the tree, flailing its branches at you. You must fight.
           """
      , options =
            [ { text = S "..."
              , condition = Nothing
              , action =
                    [ fightCustom "Tree" "" 10 7 3
                    , GoAction "combat_tree"
                    ]
              }
            ]
      }
    , customCombat "combat_tree"
        (Predicate (Counter "enemy_stamina") Lt (Const 5))
        (Predicate (Counter "player_stamina") Lt (Const 1))
        (GoAction "#148")
        (ActionBlock [ Message (S "You wake up almost dead with no money..."), Screept <| Screept.Block [ Screept.SetCounter (S "money") (Const 0), Screept.SetCounter (S "player_stamina") (Const 1) ], GoAction "#195" ])
    ]


testAgainstDifficulty : String -> Int -> Screept.Statement
testAgainstDifficulty counter diff =
    Screept.Block
        [ Screept.Rnd (S "d6_1") (Const 1) (Const 6)
        , Screept.Rnd (S "d6_2") (Const 1) (Const 6)
        , Screept.SetCounter (S "2d6") (Addition (Counter "d6_1") (Counter "d6_2"))
        , Screept.If (Screept.Predicate (Addition (Counter "2d6") (Counter counter)) Screept.Gt (Const diff))
            (Screept.SetCounter (S "test_success") (Const 1))
            (Screept.SetCounter (S "test_success") (Const 0))
        ]


onTestCondition : DialogActionExecution -> DialogActionExecution -> DialogActionExecution
onTestCondition success failure =
    ConditionalAction (nonZero (Counter "test_success")) success failure


fightCustom : String -> String -> Int -> Int -> Int -> DialogActionExecution
fightCustom enemy_name enemy_marker stamina defence combat =
    Screept <|
        Screept.Block
            [ Screept.SetCounter (S "enemy_stamina") (Const stamina)
            , Screept.SetCounter (S "enemy_defence") (Const defence)
            , Screept.SetCounter (S "enemy_combat") (Const combat)
            , Screept.SetCounter (S "fight_won") (Const 0)
            , Screept.SetCounter (S "fight_lost") (Const 0)
            , Screept.SetLabel (S "enemy_marker") (S enemy_marker)
            , Screept.SetLabel (S "enemy_name") (S enemy_name)
            ]


fightGoblin : DialogActionExecution
fightGoblin =
    fightCustom "Old Goblin" "defeated_goblin" 10 6 6


standardCombat =
    customCombat "combat"
        (Predicate (Counter "enemy_stamina") Lt (Const 1))
        (Predicate (Counter "player_stamina") Lt (Const 1))
        GoBackAction
        DoNothing


customCombat : String -> Condition -> Condition -> DialogActionExecution -> DialogActionExecution -> Dialog
customCombat id successTest failureTest successAction failureAction =
    { id = id
    , text = Special [ S "Combat. ", S "You are fighting ", Label "enemy_name", S " .You have ", IntValueText (Counter "player_stamina"), S " stamina. ", S "Your enemy ", IntValueText (Counter "enemy_stamina") ]
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
                        , Screept.If (NOT successTest)
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
                            Screept.None
                        , Screept.If successTest
                            (Screept.Block
                                [ Screept.SetCounter (S "enemy_damage") (Const 0)
                                , Screept.SetCounter (S "fight_won") (Const 1)
                                , Screept.SetCounter (Label "enemy_marker") (Const 1)
                                ]
                            )
                            (Screept.If failureTest
                                (Screept.Block
                                    [ Screept.SetCounter (S "fight_lost") (Const 1)
                                    ]
                                )
                                Screept.None
                            )
                        ]
                , Message <| Conditional (Predicate (Counter "player_damage") Gt (Const 0)) (Special [ S "You dealt ", IntValueText (Counter "player_damage"), S " damage" ])
                , Message <| Conditional (Predicate (Counter "enemy_damage") Gt (Const 0)) (Special [ S "You were dealt ", IntValueText (Counter "enemy_damage"), S " damage" ])
                ]
          }
        , { text = S "You won!", condition = Just <| Predicate (Counter "fight_won") Gt (Const 0), action = [ Message (S "You won!"), Screept <| Screept.SetCounter (S "fight_won") (Const 0), successAction ] }
        , { text = S "You lost!", condition = Just <| Predicate (Counter "fight_lost") Gt (Const 0), action = [ Message (S "You lost!"), failureAction ] }
        ]
    }


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
