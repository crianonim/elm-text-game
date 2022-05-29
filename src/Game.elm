module Game exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Stack exposing (Stack)


type alias GameState =
    { counters : Dict String Int
    , dialogStack : Stack DialogId
    , messages : List String
    }


type GameValue
    = Const Int
    | Counter String



--
--type alias GameCheck =
--    ( GameValue, GameTestOpertation )


type Condition
    = Predicate GameValue PredicateOp GameValue
    | NOT Condition
    | AND (List Condition)
    | OR (List Condition)


type PredicateOp
    = EQ
    | GT
    | LT


nonZero : GameValue -> Condition
nonZero gameValue =
    NOT (zero gameValue)


zero : GameValue -> Condition
zero gameValue =
    Predicate gameValue EQ (Const 0)


inc1 : String -> DialogActionExecution
inc1 counter =
    Inc counter (Const 1)



--
--type GameTestOpertation
--    = EQ GameValue
--    | GT GameValue
--    | LT GameValue
--    | NOT GameTestOpertation
--


type Text
    = S String
    | Special (List Text)
    | Conditional Condition Text
    | GameValueText GameValue


getText : GameState -> Text -> String
getText gameState text =
    case text of
        S string ->
            string

        Special specialTexts ->
            List.map (getText gameState) specialTexts |> String.concat

        Conditional gameCheck conditionalText ->
            if testCondition gameCheck gameState then
                getText gameState conditionalText

            else
                ""

        GameValueText gameValue ->
            getGameValueWithDefault gameValue gameState |> String.fromInt


getGameValueWithDefault : GameValue -> GameState -> Int
getGameValueWithDefault gameValue gameState =
    getMaybeGameValue gameValue gameState |> Maybe.withDefault 0


getMaybeGameValue : GameValue -> GameState -> Maybe Int
getMaybeGameValue gameValue gameState =
    case gameValue of
        Const int ->
            Just int

        Counter counter ->
            Dict.get counter gameState.counters


addCounter : String -> Int -> GameState -> GameState
addCounter counter add gameState =
    { gameState | counters = Dict.update counter (\value -> Maybe.map (\v -> v + add) value) gameState.counters }


testCondition : Condition -> GameState -> Bool
testCondition condition gameState =
    let
        testPredicate : GameValue -> PredicateOp -> GameValue -> Bool
        testPredicate x predicate y =
            let
                comp =
                    case predicate of
                        LT ->
                            (<)

                        EQ ->
                            (==)

                        GT ->
                            (>)
            in
            Maybe.map2 comp (getMaybeGameValue x gameState) (getMaybeGameValue y gameState)
                |> Maybe.withDefault False
    in
    case condition of
        Predicate v1 ops v2 ->
            testPredicate v1 ops v2

        NOT innerTest ->
            not <| testCondition innerTest gameState

        AND conditions ->
            List.foldl (\c acc -> testCondition c gameState && acc) True conditions

        OR conditions ->
            List.foldl (\c acc -> testCondition c gameState || acc) False conditions


type alias DialogOption =
    { text : Text
    , condition : Maybe Condition
    , action : List DialogActionExecution
    }


type DialogActionExecution
    = GoAction DialogId
    | GoBackAction
    | Inc String GameValue
    | Msg String
    | DoNothing


type alias DialogId =
    String


type alias Dialog =
    { id : DialogId
    , text : Text
    , options : List DialogOption
    }


type alias Dialogs =
    Dict DialogId Dialog


listDialogToDictDialog : List Dialog -> Dict DialogId Dialog
listDialogToDictDialog dialogs =
    dialogs
        |> List.map (\dial -> ( dial.id, dial ))
        |> Dict.fromList


getDialog : DialogId -> Dialogs -> Dialog
getDialog dialogId dialogs =
    Dict.get dialogId dialogs |> Maybe.withDefault badDialog


executeAction : DialogActionExecution -> GameState -> GameState
executeAction dialogActionExecution gameState =
    case dialogActionExecution of
        GoAction dialogId ->
            { gameState | dialogStack = Stack.push dialogId gameState.dialogStack }

        GoBackAction ->
            { gameState | dialogStack = Tuple.second (Stack.pop gameState.dialogStack) }

        Inc counter gv ->
            getMaybeGameValue gv gameState
                |> Maybe.map (\amount -> addCounter counter amount gameState)
                |> Maybe.withDefault gameState

        DoNothing ->
            gameState

        Msg msg ->
            { gameState | messages = msg :: gameState.messages }


introText : GameState -> Html a
introText gameState =
    div [ class "intro" ]
        [ p [] [ text <| "It is now " ++ (Dict.get "turn" gameState.counters |> Maybe.map String.fromInt |> Maybe.withDefault " - BAD TURN -") ++ " turn. " ]
        , p [] (Dict.toList gameState.counters |> List.map (\( k, v ) -> text <| k ++ ":" ++ String.fromInt v ++ ", "))
        ]


dialogExamples : List Dialog
dialogExamples =
    [ { id = "start"
      , text = Special [ S "You're in a dark room. ", Conditional (zero (Counter "start_look_around")) (S "You see nothing. "), Conditional (nonZero (Counter "start_look_around")) (S "You see a straw bed. "), Conditional (nonZero (Counter "start_search_bed")) (S "There is a rusty key among the straw. ") ]
      , options =
            [ { text = S "Go through the exit", condition = Just (nonZero (Counter "start_look_around")), action = [ GoAction "second" ] }
            , { text = S "Look around", condition = Just (zero (Counter "start_look_around")), action = [ inc1 "start_look_around", Msg "You noticed a straw bed" ] }
            , { text = S "Search the bed", condition = Just (AND [ zero (Counter "start_search_bed"), nonZero (Counter "start_look_around") ]), action = [ inc1 "start_search_bed" ] }
            , { text = S "Spend money", condition = Nothing, action = [ Inc "money" (Counter "turn"), Inc "money" (Counter "wood"), GoAction "third" ] }
            ]
      }
    , { id = "second"
      , text = S "You're at second"
      , options =
            [ { text = S "Go start", condition = Nothing, action = [ Inc "turn" (Const 1), GoAction "start" ] }
            , { text = S "Go third", condition = Nothing, action = [ GoAction "third" ] }
            ]
      }
    , { id = "third", text = S "You're at third", options = [ { text = S "Go start", condition = Nothing, action = [ GoAction "start" ] } ] }
    ]


badDialog : Dialog
badDialog =
    { id = "bad", text = S "BAD Dialog", options = [] }


exampleCounters : Dict String Int
exampleCounters =
    [ ( "turn", 1 )
    , ( "raining", 0 )
    , ( "killed_dragon", 1 )
    , ( "money", 40 )
    , ( "wood", 3 )
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
