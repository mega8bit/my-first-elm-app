module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, div, p, text)
import Pages.Gif
import Pages.NotFound
import Pages.Preview
import Pages.Tree
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
    , notFoundModel: Pages.NotFound.Model
    , previewModel: Pages.Preview.Model
    , gifModel: Pages.Gif.Model
    , treeModel: Pages.Tree.Model
    }

init: () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    let
        route = Url.Parser.parse Router.route url |> Router.getRoute
        initModel =
            {
               urlKey = key
             , currentRoute = route
             , notFoundModel = False
             , previewModel = Pages.Preview.Noop
             , gifModel = Pages.Gif.Noop
             , treeModel = {tree = []}
            }
    in
        initialModels initModel route


initialModels: Model -> Router.Route -> (Model, Cmd Msg)
initialModels model route =
    case route of
        Router.NotFound ->
            ({model | notFoundModel = Pages.NotFound.init, currentRoute = route}, Cmd.none)
        Router.Preview ->
            let
                (newModel, cmd) = Pages.Preview.init
            in
            ({model | previewModel = newModel, currentRoute = route}, Cmd.map PreviewMsg cmd)
        Router.Gif ->
            let
                (newModel, cmd) = Pages.Gif.init
            in
            ({model | gifModel = newModel, currentRoute = route}, Cmd.map GifMsg cmd)
        Router.Tree ->
            let
                (newModel, cmd) = Pages.Tree.init
            in
            ({model | treeModel = newModel, currentRoute = route}, Cmd.map TreeMsg cmd)
type Msg =
    UrlChange Url.Url
    | LinkClicked Browser.UrlRequest
    | NotFoundMsg Pages.NotFound.Msg
    | PreviewMsg Pages.Preview.Msg
    | GifMsg Pages.Gif.Msg
    | TreeMsg Pages.Tree.Msg

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
                initialModels model route
        NotFoundMsg subMsg ->
            let
                updatedModel = Pages.NotFound.update subMsg model.notFoundModel
            in
            ({model | notFoundModel = updatedModel}, Cmd.none)
        PreviewMsg subMsg ->
            let
                updateModel = Pages.Preview.update subMsg
            in
                ({model | previewModel = updateModel}, Cmd.none)
        GifMsg subMsg ->
            let
                (updateModel, updateMsg) = Pages.Gif.update subMsg
            in
                ({model | gifModel = updateModel}, Cmd.map GifMsg updateMsg)
        TreeMsg subMsg ->
            let
                (updateModel, updateMsg) = Pages.Tree.update subMsg model.treeModel
            in
                ({model | treeModel = updateModel}, Cmd.map TreeMsg updateMsg)

view: Model -> Browser.Document Msg
view model =
    {
        title = "elm app"
        , body =
            [ div [] [
                    render model
                ]
            ]
    }

render: Model -> Html Msg
render model =
    case model.currentRoute of
        Router.Preview ->
            div []
            [
                Html.map PreviewMsg (Pages.Preview.view model.previewModel)
            ]
        Router.NotFound ->
            div []
            [
                Html.map NotFoundMsg (Pages.NotFound.view model.notFoundModel)
            ]
        Router.Gif ->
            div []
            [
                Html.map GifMsg (Pages.Gif.view model.gifModel)
            ]
        Router.Tree ->
            div []
            [
                Html.map TreeMsg (Pages.Tree.view model.treeModel)
            ]