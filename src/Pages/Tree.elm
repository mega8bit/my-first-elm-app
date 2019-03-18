module Pages.Tree exposing (..)

import Html exposing (Html, div, li, p, strong, text, ul)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, bool, field, int, lazy, list, string)
import Result as Http


type  alias Tree
    =   {
          id: Int
        , name: String
        , parentId: Int
        , text: String
        , children: Childrens
        , isActive: Bool
        }
type Childrens = Childrens (List Tree)

type alias Model
    = { tree: List Tree
      }

type Msg =
    GotTree (Http.Result Http.Error (List Tree))
    | ClickNode Tree

init:  (Model, Cmd Msg)
init  =
    (
        {tree = []}
        ,
        Http.get
        {
          url = "http://localhost:8080/t.json"
        , expect = Http.expectJson GotTree treeDataDecoder
        }
    )


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotTree result ->
            case result of
                Ok text ->
                    ({tree = text}, Cmd.none)
                Err text ->
                     Debug.log (Debug.toString text)
                    ({tree = []}, Cmd.none)
        ClickNode treeNode ->
            let
                newTree = List.map (changeNode treeNode) model.tree
            in
            Debug.log (Debug.toString treeNode.name)
            ({model | tree = newTree}, Cmd.none)

changeNode: Tree -> Tree -> Tree
changeNode currentTree modelTree =
        let
            newChild = List.map (changeNode currentTree) (getTreeChildren modelTree.children)
        in
        if modelTree.id == currentTree.id then
            {modelTree | isActive = True}
        else
            {modelTree | isActive = False, children = Childrens newChild}

view: Model -> Html Msg
view model =
    ul[] (List.map viewTreeElement model.tree)


viewTreeElement: Tree -> Html Msg
viewTreeElement tree =
     li [] [
        if tree.isActive then
            strong [onClick (ClickNode tree)] [text tree.name]
        else
            p [onClick (ClickNode tree)] [text tree.name]
        , ul [] (List.map viewTreeElement (getTreeChildren tree.children))
    ]


getTreeChildren: Childrens -> List Tree
getTreeChildren child =
    case child of
        Childrens a ->
            a

treeDataDecoder: Decoder (List Tree)
treeDataDecoder =
    Json.Decode.map6 Tree
       (field "id" int)
       (field "name" string)
       (field "parent_id" int)
       (field "text" string)
       (field "children" (Json.Decode.map Childrens (lazy (\_ -> treeDataDecoder))))
       (field "isActive" bool)
       |> Json.Decode.list
