module Router exposing (..)


import Url.Parser as Url exposing (top)

type Route =
    Preview
    | NotFound
    | Gif

route: Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Preview top
        , Url.map Preview (Url.s "preview")
        , Url.map NotFound (Url.s "404")
        , Url.map Gif (Url.s "gif")
        ]

getRoute: Maybe Route -> Route
getRoute isroute =
    case isroute of
        Just r ->
            r
        Nothing ->
            NotFound


