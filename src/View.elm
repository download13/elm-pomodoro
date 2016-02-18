module View
    ( view
    ) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Html.Lazy exposing (lazy, lazy2)
import Signal exposing (Address)
import Types exposing (..)
import Utils exposing (parseUserTime, onEnter, onBlurValue, onEnterValue, formatTime)
import Model exposing (Model)



view : Address Action -> Model -> Html
view address model =
    div
        [ class "pomodoro-app" ]
        [ lazy2 timer address model
        , lazy taskList model.tasks
        , lazy2 taskCreator address model
        ]

timer : Address Action -> Model -> Html
timer address {timeRemaining, status, tasks} =
    div
        [ class "timer" ]
        [ div
            [ class "timer-status-type" ]
            []
        , input
            [ class "timer-display"
            , readonly ( status |> isStatusReady |> not )
            , onBlurValue address parseUserTime
            , onEnterValue address parseUserTime
            , timeRemaining |> formatTime |> value
            ]
            []
        , div
            [ class "timer-buttons" ]
            [ button
                [ onClick address StartOrPause
                , disabled (status == RingingState)
                ]
                [ text (if isStatusReady status then "Start" else "Pause") ]
            , button
                [ onClick address Reset
                , disabled (status == ResetState)
                ]
                [ text "Reset" ]
            , button
                [ onClick address MarkTaskComplete
                , disabled ((List.length tasks) == 0)
                ]
                [ text "Task Done" ]
            ]
        ]

taskList : List PomodoroTask -> Html
taskList tasks =
    div
        [ class "tasks" ]
        (List.map taskRow tasks)

taskRow : PomodoroTask -> Html
taskRow task =
    section
        [ class "task" ]
        [ text task ]

taskCreator : Address Action -> Model -> Html
taskCreator address model =
    input
        [ class "task-creator"
        , placeholder "Task..."
        , onEnter address CreateTask
        , on "input" targetValue (Signal.message address << SetTaskInput)
        , value model.taskInput
        ]
        []
