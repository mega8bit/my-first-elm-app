module Pages.NotFound exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
type alias Model = Bool

init: Model
init = False

type Msg =
    Show | Hide

update: Msg -> Model -> Model
update msg model =
    case msg of
        Show ->
            True
        Hide ->
            False

view: Model -> Html Msg
view model =
    div []
    [ p [] [text "404 page. Not found"]
    , viewMoreInformation model
    ]

viewMoreInformation: Model -> Html Msg
viewMoreInformation model =
    if model then
        div []
        [
          p [] [text "The HTTP 404, 404 Not Found and 404 error message is a Hypertext Transfer Protocol standard response code, in computer network communications, to indicate that the client was able to communicate with a given server, but the server could not find what was requested."]
        , button [onClick Hide] [text "hide information"]
        ]
    else
        div []
        [
          p [] [text ""]
        , button [onClick Show] [text "Show more information"]
        ]