module App exposing (main)

import Html exposing (Html, Attribute, div, text, input, li, ul)
import Html.Attributes exposing (style, type_, placeholder, value)
import Html.Events exposing (onInput, on, onClick, keyCode)
import Json.Decode as Json
import Table


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Text =
    String


type alias Item =
    { text : Text }


type alias Model =
    { newItem : Item
    , items : List Item
    , tableState : Table.State
    }


model : Model
model =
    { newItem = emptyItem
    , items =
        [ { text = "Hello" }
        , { text = "World" }
        ]
    , tableState = Table.initialSort "Name"
    }


emptyItem : Item
emptyItem =
    { text = "" }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )



-- Update


type Msg
    = NoOp
    | SetTableState Table.State
    | Add
    | UpdateNewItem String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Add ->
            ( { model
                | items = model.items ++ [ model.newItem ]
                , newItem = emptyItem
              }
            , Cmd.none
            )

        UpdateNewItem text ->
            ( { model | newItem = { text = text } }, Cmd.none )

        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


inputText : Item -> Html Msg
inputText item =
    input [ type_ "text", placeholder "item", value item.text, onInput UpdateNewItem, onEnter Add ] []


addButton : Html Msg
addButton =
    input [ type_ "submit", onClick Add ] [ text "Add" ]


view : Model -> Html Msg
view model =
    div []
        [ inputText model.newItem
        , addButton
        , Table.view config model.tableState model.items
        ]


config : Table.Config Item Msg
config =
    Table.config
        { toId = .text
        , toMsg = SetTableState
        , columns = [ Table.stringColumn "Tech Debt" .text ]
        }



-- aux


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        tagger code =
            if code == 13 then
                msg
            else
                NoOp
    in
        on "keydown" (Json.map tagger keyCode)
