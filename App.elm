module App exposing (main)

import Html exposing (Html, Attribute, div, text, input, li, ul, button)
import Html.Attributes exposing (style, type_, placeholder, value, disabled)
import Html.Events exposing (onInput, on, onClick, keyCode)
import Json.Decode as Json
import List.Extra exposing (replaceIf)
import Table
import Wall
import Item exposing (Item, Evaluation, Text)
import EvaluationTable


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { newItem : Item
    , items : List Item
    , tableState : Table.State
    , uid : Int
    }


buildItem : Int -> Item
buildItem id =
    { text = "", id = id, effort = 0, value = 0 }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { newItem = buildItem 0
            , items = []
            , tableState = Table.initialSort "Name"
            , uid = 1
            }
    in
        ( model, Cmd.none )



-- Update


type Msg
    = NoOp
    | EvaluationTableMsg EvaluationTable.Msg
    | Add
    | UpdateNewItem String


type EvaluationType
    = Pain
    | Effort


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Add ->
            { model
                | uid = model.uid + 1
                , items = model.items ++ [ model.newItem ]
                , newItem = buildItem model.uid
            }
                ! []

        UpdateNewItem text ->
            let
                updateItem item text =
                    { item | text = text }
            in
                { model | newItem = (updateItem model.newItem text) } ! []

        EvaluationTableMsg msg2 ->
            case msg2 of
                EvaluationTable.UpdatePain item newPain ->
                    let
                        findItem candidate =
                            item.id == candidate.id

                        newItems =
                            replaceIf findItem { item | value = newPain } model.items
                    in
                        { model | items = newItems } ! []

                EvaluationTable.UpdateEffort item newEffort ->
                    let
                        findItem candidate =
                            item.id == candidate.id

                        newItems =
                            replaceIf findItem { item | effort = newEffort } model.items
                    in
                        { model | items = newItems } ! []

                EvaluationTable.SetTableState newState ->
                    { model | tableState = newState } ! []



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


inputText : Item -> Html Msg
inputText item =
    input
        [ type_ "text"
        , placeholder "item"
        , value item.text
        , onInput UpdateNewItem
        , onEnter Add
        ]
        []


addButton : Html Msg
addButton =
    input
        [ type_ "submit"
        , onClick Add
        ]
        [ text "Add" ]


view : Model -> Html Msg
view model =
    div []
        [ inputText model.newItem
        , addButton
        , EvaluationTable.view model.tableState model.items EvaluationTableMsg
        , Wall.view model.items
        ]


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
