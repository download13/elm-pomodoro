module Types
    ( Status(..)
    , isStatusReady
    , PomodoroTask
    , Action(..)
    ) where

import Time exposing (Time)


type Status
    = ResetState
    | RunningState
    | PausedState
    | RingingState

isStatusReady : Status -> Bool
isStatusReady status = status == ResetState || status == PausedState

type alias PomodoroTask = String

type Action
    = NoOp
    | StartOrPause
    | Reset
    | CreateTask
    | SetTaskInput String
    | MarkTaskComplete
    | TimerDelta Time
    | UserSetTimer Time
