module Game exposing (..)

import Dict exposing (Dict)


type alias DialogOption =
    { text : String
    , go : DialogId
    }


type alias DialogId =
    String


type alias Dialog =
    { id : DialogId
    , text : String
    , options : List DialogOption
    }

type alias Dialogs = Dict DialogId Dialog

dialogExamples : List Dialog
dialogExamples =
    [ { id = "start", text = "You're at start", options = [ { text = "Go second", go = "second" } ] }
    , { id = "second", text = "You're at second", options = [ { text = "Go start", go = "start" }, { text = "Go third", go = "third" } ] }
    , { id = "third", text = "You're at third", options = [ { text = "Go start", go = "start" } ] }
    ]


listDialogToDictDialog : List Dialog -> Dict DialogId Dialog
listDialogToDictDialog dialogs =
    dialogs
        |> List.map (\dial -> ( dial.id, dial ))
        |> Dict.fromList

badDialog : Dialog
badDialog =
    { id = "bad", text = "BAD Dialog", options = [ ] }

getDialog : DialogId -> Dialogs -> Dialog
getDialog dialogId dialogs =
    Dict.get dialogId dialogs |> Maybe.withDefault badDialog
