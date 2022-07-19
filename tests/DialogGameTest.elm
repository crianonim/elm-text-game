module DialogGameTest exposing (..)

import Char as Chat
import DialogGame exposing (..)
import Dict
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Json
import Json.Encode as Json
import Parser
import Random
import Screept
import Stack
import Test exposing (..)


exampleDialog : Dialog
exampleDialog =
    { id = "start"
    , text = Screept.S ""
    , options =
        [ { text = Screept.S "Option1", condition = Just (Screept.IntVariable (Screept.VLit "test1")), action = [] }
        ]
    }


exampleDialogs : Dialogs
exampleDialogs =
    DialogGame.listDialogToDictDialog
        [ { id = "start", text = Screept.S "", options = [] }
        ]


exampleSimpleDialogModel : Model
exampleSimpleDialogModel =
    DialogGame.initSimple exampleDialogs


codecDialog : Test
codecDialog =
    describe "Encoding and decoding dialogs"
        [ test "round trip example dialog" <|
            \_ -> Expect.equal (DialogGame.encodeDialog exampleDialog |> Json.encode 0 |> Json.decodeString DialogGame.decodeDialog) (Ok exampleDialog)
        ]


stateEncoding : Test
stateEncoding =
    --Test.only <|
    describe "Encoding and decoding state"
        [ test "round trip example state" <|
            \_ -> Expect.equal (DialogGame.encodeState exampleState |> Json.encode 0 |> Json.decodeString DialogGame.decodeState) (Ok exampleState)
        ]


exampleState : GameState
exampleState =
    { vars =
        Dict.fromList
            [ ( "i1", Screept.VInt 5 )
            , ( "t1", Screept.VText "Jan" )
            , ( "f1", Screept.VLazyInt (Screept.IntVariable (Screept.VLit "i1")) )
            ]
    , procedures = Dict.empty
    , rnd = Random.initialSeed 666
    , messages = []
    , dialogStack = Stack.initialise
    }



--
--decodingVariables : Test
--decodingVariables =
--    describe "Encoding Variables"
--    [
--
--    ]
