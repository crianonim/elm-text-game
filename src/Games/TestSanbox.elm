module Games.TestSanbox exposing (..)

import DialogGame exposing (..)
import Dict exposing (Dict)
import Screept exposing (..)


initialDialogId =
    "start"


labels : Dict String String
labels =
    [ ( "player_name", "Liana" )
    , ( "player_profession", "wayfarer" )
    , ( "enemy_name", "" )
    ]
        |> Dict.fromList


counters : Dict String Int
counters =
    [ ( "turn", 1 )
    , ( "turns_count", 3 )
    , ( "turns_per_hour", 2 )
    , ( "hour", 0 )
    , ( "minutes", 0 )
    ]
        |> Dict.fromList


statusLine : TextValue
statusLine =
    parseTextValue """["Turn: ", str($turn), " Time: ", str($hour), ":", str($minutes)]"""


functions : Dict String IntValue
functions =
    []
        |> Dict.fromList


procedures : Dict String Statement
procedures =
    [ ( "turn", run """{
 SET $turn = ($turn + 1);
 SET $turns_count = ($turns_count - 1);

 SET $minutes = (($turn %% $turns_per_hour) * (60 / $turns_per_hour));
 SET $hour = (($turn / $turns_per_hour) %% 24);
 SET $day = ($turn / ($turns_per_hour * 24));
 IF ($turns_count > 0) THEN RUN turn ELSE {SET $turns_count = 1}
}""" ) ]
        |> Dict.fromList


dialogs : List Dialog
dialogs =
    [ { id = "start"
      , text = Concat []
      , options = [ { text = S "...", condition = Nothing, action = [ runScreept "RUN turn" ] } ]
      }
    ]
