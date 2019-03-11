module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, div, p, text)
import Url
import Widget

main =
    Browser.application {
        init = init
        , update = update
        , view = view
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChange
        , subscriptions = \_ -> Sub.none
    }

type alias Model =
    {
        key: Nav.Key,
        widgetModel: Widget.Model
    }

init: () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    ({key = key, widgetModel = Widget.init}, Cmd.none)

type Msg =
    NoopMsg
    | LinkClicked Browser.UrlRequest
    | UrlChange Url.Url
    | WidgetMsg Widget.Msg

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked request ->
            case request of
                Browser.Internal url ->
                    (model, Nav.pushUrl model.key (Url.toString url) )
                Browser.External href ->
                    (model, Nav.load href)
        UrlChange url ->
                (model, Cmd.none)
        NoopMsg ->
            (model, Cmd.none)
        WidgetMsg subMsg ->
            let
                (updateModel, widgetCmd) = Widget.update subMsg model.widgetModel
            in
                ({model | widgetModel = updateModel}, Cmd.map WidgetMsg widgetCmd)

view: Model -> Browser.Document Msg
view model =
    {
        title = "elmapp"
        , body =
            [ div[] [
                p [] [text "start app"]
                , Html.map WidgetMsg (Widget.view model.widgetModel)
            ] ]
    }