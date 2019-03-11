module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (div, p, text)
import Router
import Url exposing (Url)
import Url.Parser
main =
    Browser.application
    {
        init = init
        , update = update
        , view = view
        , subscriptions = \_->Sub.none
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
    }


type alias Model =
    { urlKey: Nav.Key
    , currentRoute: Router.Route
    }

init: () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    let
        route = Url.Parser.parse Router.route url |> Router.getRoute
    in
    ({ urlKey = key, currentRoute = route}, Cmd.none)

type Msg =
    UrlChange Url.Url
    | LinkClicked Browser.UrlRequest

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked request ->
            case request of
                Browser.Internal url ->
                    (model, Nav.pushUrl model.urlKey (Url.toString url))
                Browser.External href ->
                    (model, Nav.load href)
        UrlChange url ->
            let
                route = Url.Parser.parse Router.route url |> Router.getRoute
            in
            ({model | currentRoute = route}, Cmd.none)

view: Model -> Browser.Document Msg
view model =
    {
        title = "elm app"
        , body =
            [ div [] [
                    case model.currentRoute of
                        Router.Preview ->
                            p [] [text "preview"]
                        Router.NotFound ->
                            p [] [text "404"]
                ]
            ]
    }