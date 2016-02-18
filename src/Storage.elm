module Storage
    ( toStorageModel
    , fromStorageModel
    , StorageModel
    ) where

import Types exposing (PomodoroTask, Status(..))
import Model exposing (Model, emptyModel)
import Time exposing (Time)


type alias StorageModel =
    { status : String
    , timeRemaining : Time
    , pomodoroLength : Time
    , breakLength : Time
    , tasks : List PomodoroTask
    , taskInput : String
    }

toStorageModel : Model -> StorageModel
toStorageModel model =
    { status = statusToString model.status
    , timeRemaining = model.timeRemaining
    , pomodoroLength = model.pomodoroLength
    , breakLength = model.breakLength
    , tasks = model.tasks
    , taskInput = model.taskInput
    }

fromStorageModel : Maybe StorageModel -> Model
fromStorageModel result =
    case result of
        Nothing ->
            emptyModel

        Just model ->
            { status = stringToStatus model.status
            , timeRemaining = model.timeRemaining
            , pomodoroLength = model.pomodoroLength
            , breakLength = model.breakLength
            , tasks = model.tasks
            , taskInput = model.taskInput
            }

statusToString : Status -> String
statusToString status =
    case status of
        ResetState -> "reset"
        RunningState -> "running"
        PausedState -> "paused"
        RingingState -> "ringing"

stringToStatus : String -> Status
stringToStatus str =
    case str of
        "reset" -> ResetState
        "running" -> RunningState
        "paused" -> PausedState
        "ringing" -> RingingState
        _ -> ResetState
