module Utils
    ( formatTime
    , onEnterValue
    , onBlurValue
    , onEnter
    , parseUserTime
    ) where

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode, targetValue)
import Time exposing (Time, inSeconds)
import Signal exposing (Signal, Address)
import Json.Decode exposing (..)
import Regex exposing (Regex)
import String exposing (repeat, length, toInt)
import Result exposing (toMaybe)
import Types exposing (..)


formatTime : Time -> String
formatTime time =
  let
    totalSeconds = inSeconds time |> truncate
    minutes = totalSeconds // 60 |> toString
    seconds = totalSeconds % 60 |> toString
  in
    atLeastTwoDigits(minutes) ++ ":" ++ atLeastTwoDigits(seconds)

leadingZeros : Int -> String -> String
leadingZeros zeros nstr =
  let
    neededZeros = max 0 (zeros - length nstr)
  in
    (repeat neededZeros "0") ++ nstr

atLeastTwoDigits : String -> String
atLeastTwoDigits nstr = leadingZeros 2 nstr

onEnterValue : Address a -> (String -> a) -> Attribute
onEnterValue address valueToAction =
    on "keydown"
        (object2
            (\_ value -> value)
            isEnter
            targetValue
        )
        (\value -> Signal.message address (valueToAction value))

isEnter : Decoder ()
isEnter =
    customDecoder
    keyCode
    (\code -> if code == 13 then Ok () else Err "Not Enter")

onEnter : Address a -> a -> Attribute
onEnter address value =
    on "keydown" isEnter
        (\_ -> Signal.message address value)


onBlurValue : Address a -> (String -> a) -> Attribute
onBlurValue address valueToAction =
    on "blur" targetValue (\v -> Signal.message address (valueToAction v))

parseUserTime : String -> Action
parseUserTime value =
    case parseClock value of
        Just seconds -> UserSetTimer (toFloat seconds * Time.second)
        Nothing -> NoOp

clockRe : Regex
clockRe = Regex.regex "\\d+"

parseClock : String -> Maybe Int
parseClock value =
    case List.map .match (Regex.find Regex.All clockRe value) of
        [] ->
            Nothing
        [pseconds] ->
            toMaybe (toInt pseconds)
        [pminutes, pseconds] ->
            case toMaybe (toInt pseconds) of
                Nothing ->
                    Nothing
                Just seconds ->
                    Just (seconds + (
                        case toMaybe (toInt pminutes) of
                            Just minutes -> minutes * 60
                            Nothing -> 0
                    ))
        _ ->
            Nothing
