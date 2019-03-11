module Widget exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
type alias Model = Int

init: Model
init =
    0

type Msg =
    Inc
    | Dec

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Inc ->
            (model + 1, Cmd.none)
        Dec ->
            (model - 1, Cmd.none)

view: Model -> Html Msg
view model =
    div [] [
        button [onClick Dec] [text "-"]
        , p [] [text (String.fromInt model)]
        , button [onClick Inc] [text "+"]
    ]