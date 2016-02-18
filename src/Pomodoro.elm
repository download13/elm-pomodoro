module Pomodoro where

import Html exposing (Html, div, section, text, input, button, Attribute)
import Signal exposing (Signal, Address)
import Time exposing (Time, minute, second)
import Types exposing (..)
import Model exposing (Model, emptyModel)
import View exposing (view)
import Storage exposing (..)


update : Action -> Model -> Model
update action model =
    let
        {status, tasks} = model
    in
        case action of
            NoOp ->
                model

            StartOrPause ->
                { model |
                    status =
                        case model.status of
                            ResetState -> RunningState
                            RunningState -> PausedState
                            PausedState -> RunningState
                            s -> s
                }

            Reset ->
                { model | status = ResetState, timeRemaining = model.pomodoroLength }

            SetTaskInput str ->
                { model | taskInput = str }

            CreateTask ->
                let
                    { taskInput, tasks } = model
                in
                    if taskInput == "" then
                        model
                    else
                        { model | tasks = List.append tasks [taskInput], taskInput = "" }

            MarkTaskComplete ->
                case tasks of
                    (first :: rest) -> { model | tasks = rest }
                    [] -> model

            TimerDelta delta ->
                if status == RunningState then
                    let
                        timeLeft = model.timeRemaining - delta
                    in
                        if timeLeft <= 0 then
                            { model | status = RingingState, timeRemaining = 0 }
                        else
                            { model | timeRemaining = timeLeft }
                else
                    model

            UserSetTimer seconds ->
                if isStatusReady status then
                    { model | timeRemaining = seconds }
                else
                    model


main : Signal Html
main = Signal.map (view actions.address) model

model : Signal Model
model =
    Signal.foldp update initialModel <|
        Signal.merge actions.signal <|
            Signal.map TimerDelta (Time.fps 5)

initialModel : Model
initialModel = fromStorageModel getStorage

actions : Signal.Mailbox Action
actions = Signal.mailbox NoOp


port getStorage : Maybe StorageModel

port setStorage : Signal StorageModel
port setStorage = Signal.map toStorageModel model

port setRinging : Signal Bool
port setRinging = Signal.map (\{status} -> status == RingingState) model
