module Router exposing (..)


import Url.Parser as Url

type Route =
    Preview
    | NotFound

route: Url.Parser (Route -> a) a
route =
    Url.oneOf
        [ Url.map Preview (Url.s "preview")
        , Url.map NotFound (Url.s "404")
        ]

getRoute: Maybe Route -> Route
getRoute isroute =
    case isroute of
        Just r ->
            r
        Nothing ->
            NotFound


