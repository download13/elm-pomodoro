module Model where

import Types exposing (..)
import Time exposing (Time, minute)


defaultPomodoroLength : Time
defaultPomodoroLength = 20 * minute
defaultBreakLength : Time
defaultBreakLength = 5 * minute

type alias Model =
  { status : Status
  , timeRemaining : Time
  , pomodoroLength : Time
  , breakLength : Time
  , tasks : List PomodoroTask
  , taskInput : String
  }

emptyModel : Model
emptyModel =
  { status = ResetState
  , timeRemaining = defaultPomodoroLength
  , pomodoroLength = defaultPomodoroLength
  , breakLength = defaultBreakLength
  , tasks = []
  , taskInput = ""
  }
