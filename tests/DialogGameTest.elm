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
import ScreeptV2 exposing (Environment, Expression(..), Identifier(..), Statement(..), Value(..))
import Stack
import Test exposing (..)


exampleDialog : Dialog
exampleDialog =
    { id = "start"
    , text = Literal <| Text ""
    , options =
        [ { text = Literal <| Text "Option1", condition = Just (Variable <| LiteralIdentifier "test1"), actions = [] }
        ]
    }


exampleDialogs : Dialogs
exampleDialogs =
    DialogGame.listDialogToDictDialog
        [ { id = "start", text = Literal <| Text "", options = [] }
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
    describe "Encoding and decoding state"
        [ test "round trip example state" <|
            \_ ->
                Expect.equal
                    (DialogGame.encodeState exampleState
                        |> Json.encode 0
                        |> Json.decodeString DialogGame.decodeState
                    )
                    (Ok exampleState)
        ]


exampleScreeptEnv : Environment
exampleScreeptEnv =
    { vars =
        Dict.fromList
            [ ( "i1", Number 5 )
            , ( "t1", Text "Jan" )
            , ( "f1", Func (Variable (LiteralIdentifier "i1")) )
            ]
    , procedures =
        Dict.fromList
            [ ( "p1"
              , Block
                    [ Bind (LiteralIdentifier "v1") (Literal <| Number 5)
                    ]
              )
            ]
    , rnd = Random.initialSeed 666
    }


exampleState : GameState
exampleState =
    { screeptEnv = exampleScreeptEnv
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
