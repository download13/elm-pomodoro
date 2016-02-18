#!/bin/sh
elm make src/Pomodoro.elm --output dist/elm.js --warn &&\
uglifyjs -c -m -- dist/elm.js > dist/elm.min.js 2> /dev/null
