module Pages.Preview exposing (..)

import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (href)
import Http


type  Model = Loading | Success String | Fail | Noop

type Msg =
    GotText (Result Http.Error String)

init: (Model, Cmd Msg)
init =
    (
    Loading
    , Http.get
        {
          url = "http://localhost:8080/i.php"
        , expect = Http.expectString GotText
        }
    )

update: Msg -> Model
update msg =
    case msg of
        GotText result ->
            case result of
                Ok text ->
                    (Success text)
                Err _ ->
                    Fail

view: Model -> Html msg
view model =
    div[]
    [
        case model of
            Loading ->
                p [] [text "Loading.."]
            Fail ->
                p [] [text "Loading failed. Repeat please."]
            Success result ->
                div []
                [ p [] [text result]
                , a [href "/gif"] [text "get gif"]
                ]
            Noop ->
                div [] []
    ]