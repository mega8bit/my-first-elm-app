module Pages.Tree exposing (..)

import Html exposing (Html, div, li, p, text, ul)
import Http
import Json.Decode exposing (Decoder, field, int, lazy, list, string)
import Result as Http


type  alias Tree
    =   {
          id: Int
        , name: String
        , parentId: Int
        , text: String
        , children: Childrens
        }
type Childrens = Childrens (List Tree)

type alias Model
    = List Tree

type Msg =
    GotTree (Http.Result Http.Error (List Tree))

init:  (Model, Cmd Msg)
init  =
    (
        []
        ,
        Http.get
        {
          url = "http://localhost:8080/t.json"
        , expect = Http.expectJson GotTree treeDataDecoder
        }
    )


update: Msg -> (Model, Cmd Msg)
update msg =
    case msg of
        GotTree result ->
            case result of
                Ok text ->
                    (text, Cmd.none)
                Err text ->
                     Debug.log (Debug.toString text)
                    ([], Cmd.none)

view: Model -> Html msg
view tree =
    ul[] (List.map viewTreeElement tree)


viewTreeElement: Tree -> Html msg
viewTreeElement tree =
     li [] [
        text tree.name
        , ul [] (List.map viewTreeChildrens (getTreeChildren tree.children))
    ]

viewTreeChildrens: Tree -> Html msg
viewTreeChildrens children =
    ul [] [
        viewTreeElement children
    ]

getTreeChildren: Childrens -> List Tree
getTreeChildren child =
    case child of
        Childrens a ->
            a

treeDataDecoder: Decoder (List Tree)
treeDataDecoder =
    Json.Decode.map5 Tree
       (field "id" int)
       (field "name" string)
       (field "parent_id" int)
       (field "text" string)
       (field "children" (Json.Decode.map Childrens (lazy (\_ -> treeDataDecoder))))
       |> Json.Decode.list
