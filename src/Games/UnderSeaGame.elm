module Games.UnderSeaGame exposing (..)

import Dict
import Game exposing (..)
import Stack


config : GameConfig
config =
    { turnCallback = \_ gs -> gs
    , showMessages = False
    }


dialogs : List Dialog
dialogs =
    [ { id = "start"
      , text = S """

    You are an underwater explorer. You are leaving to explore the deepest oceans. You must find the lost city of Atlantis. This is your most challenging assignment.
    It is morning and the sun pushes up on the horizon. The sea is calm. You climb into the narrow pilot's compartment of the underwater vessel Seeker with your special gear. The crew of the research vessel Maray screws down the hatch clamps. Now begins the plunge into the depths of the ocean. The Seeker crew begins lowering by a strong, but thin cable. Within minutes, you are so deep in the ocean that little light filters down to you. The silence is eerie as the Seeker slips deeper and deeper. You peer out the thick glass porthole and see fish drifting past, sometimes stopping to look at you—an intruder from another world.
     Now the cable attaching you to Maray is extended almost to its limit. You have come to rest on a ledge near the canyon in the ocean floor that supposedly leads to the lost city of Atlantis.
    You have a special sea suit that will protect you from the intense pressure of the deep if you choose to walk about on the sea bottom. You can cut loose from the cable if you wish because the
    Seeker is self-propelled. You are now in another world.
    """
      , options =
            [ { text = S "Explore the ledge where the Seeker has come to rest", condition = Nothing, action = [ GoAction "p6" ] }
            , { text = S "Cut loose from the Maray and dive with the Seeker into the canyon in the ocean floor", condition = Nothing, action = [ GoAction "p5" ] }
            ]
      }
    , { id = "p5"
      , text = S """
      You radio a status report to the Moray and tell them that you are going to cast off from the line and descend under your own power. Your plan is approved and you cast off your line. Now you are on your own. The Seeker slips noiselessly into the undersea canyon.
      As you drop into the canyon, you turn on the Seeker's powerful searchlight. Straight ahead is a dark wall covered with a strange type of barnacle growth. To the left (port) side you see what appears to be a grotto. The entrance is perfectly
      round, as if it had been cut by human hands. Lantern fish give off a pale, greenish light. To the right (starboard) side of the Seeker you see bub- bles rising steadily from the floor of the canyon.
      """
      , options =
            [ { text = S "Investigate the bubbles", condition = Nothing, action = [ GoAction "p8" ] }
            , { text = S "Investigate the grotto with the round entrance", condition = Nothing, action = [ GoAction "p9" ] }
            ]
      }
    ]


initialGameState : GameState
initialGameState =
    { counters = Dict.empty, dialogStack = Stack.push "start" Stack.initialise, messages = [] }
