module App exposing (main)

import Html exposing (Html, Attribute, div, text, input, li, ul, button)
import Html.Attributes exposing (style, type_, placeholder, value, disabled)
import Html.Events exposing (onInput, on, onClick, keyCode)
import Json.Decode as Json
import Table
import List.Extra exposing (replaceIf)


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


type alias Evaluation =
    Float


type alias Item =
    { effort : Evaluation
    , value : Evaluation
    , text : Text
    , id : Int
    }


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
    | SetTableState Table.State
    | Add
    | UpdateNewItem String
    | UpdateEffort Item Evaluation
    | UpdateValue Item Evaluation


type EvaluationType
    = Value
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

        SetTableState newState ->
            { model | tableState = newState } ! []

        UpdateValue item newValue ->
            let
                findItem candidate =
                    item.id == candidate.id

                newItems =
                    replaceIf findItem { item | value = newValue } model.items
            in
                { model | items = newItems } ! []

        UpdateEffort item newEffort ->
            let
                findItem candidate =
                    item.id == candidate.id

                newItems =
                    replaceIf findItem { item | effort = newEffort } model.items
            in
                { model | items = newItems } ! []



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
        , Table.view config model.tableState model.items
        ]


config : Table.Config Item Msg
config =
    Table.config
        { toId = .text
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Tech Debt" .text
            , evaluationColumn "Effort" .effort Effort
            , evaluationColumn "Value" .value Value
            ]
        }


evaluationColumn : String -> (Item -> Evaluation) -> EvaluationType -> Table.Column Item Msg
evaluationColumn name getData evaluationType =
    Table.veryCustomColumn
        { name = name
        , viewData = viewEvaluationButtons getData evaluationType
        , sorter = Table.increasingOrDecreasingBy getData
        }


viewEvaluationButtons : (Item -> Evaluation) -> EvaluationType -> Item -> Table.HtmlDetails Msg
viewEvaluationButtons getData evaluationType item =
    let
        currentNumber =
            item |> getData

        renderButton number =
            button
                [ onClick (handleClick evaluationType item number)
                , disabled (number == currentNumber)
                ]
                [ text (toString number) ]
    in
        Table.HtmlDetails []
            (List.map renderButton [ 1, 2, 3 ])


handleClick : EvaluationType -> Item -> Evaluation -> Msg
handleClick evaluationType item number =
    case evaluationType of
        Value ->
            UpdateValue item number

        Effort ->
            UpdateEffort item number



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
