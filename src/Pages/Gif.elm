module Pages.Gif exposing (..)

import Html exposing (Html, a, br, button, div, img, p, text)
import Html.Attributes exposing (href, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string)

type Model =
     Noop
    | Loading
    | Failed
    | Success String

type Msg =
    GotGif (Result Http.Error String)
    | More

init: (Model, Cmd Msg)
init =
    ( Loading
    , Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }
    )

update: Msg -> (Model, Cmd Msg)
update msg =
    case msg of
        GotGif result ->
            case result of
                Ok url ->
                    (Success url, Cmd.none)
                Err _ ->
                    (Failed, Cmd.none)
        More ->
            init

view: Model -> Html Msg
view model =
    div []
    [
        case model of
            Failed ->
                p [] [text "error"]
            Success url ->
                div []
                [ p[] [text "Random gif"]
                , img [src url] []
                , br [] []
                , a [href "/"] [text "back"]
                , br [] []
                , button [onClick More] [text "More"]
                ]
            Loading ->
                p [] [text "Loading..."]
            Noop ->
                div [] []
    ]

gifDecoder: Decoder String
gifDecoder =
    field "data" (field "image_url" string)
