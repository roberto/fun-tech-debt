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


type alias Evaluation =
    Float


type alias Item =
    { effort : Evaluation
    , value : Evaluation
    , text : Text
    }


type alias Model =
    { newItem : Item
    , items : List Item
    , tableState : Table.State
    }


emptyItem : Item
emptyItem =
    { text = "", effort = 0, value = 0 }


buildItem : Text -> Item
buildItem text =
    { emptyItem | text = text }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { newItem = emptyItem
            , items =
                [ { effort = 1
                  , value = 3
                  , text = "Hello"
                  }
                , { effort = 2
                  , value = 1
                  , text = "World"
                  }
                ]
            , tableState = Table.initialSort "Name"
            }
    in
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
            model ! []

        Add ->
            { model
                | items = model.items ++ [ model.newItem ]
                , newItem = emptyItem
            }
                ! []

        UpdateNewItem text ->
            { model | newItem = (buildItem text) } ! []

        SetTableState newState ->
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
        , Table.view config model.tableState model.items
        ]


config : Table.Config Item Msg
config =
    Table.config
        { toId = .text
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Tech Debt" .text
            , evaluationColumn "Effort" .effort
            , evaluationColumn "Value" .value
            ]
        }


evaluationColumn : String -> (Item -> comparable) -> Table.Column Item Msg
evaluationColumn name getData =
    Table.veryCustomColumn
        { name = name
        , viewData = viewEvaluationButtons getData
        , sorter = Table.increasingOrDecreasingBy getData
        }


viewEvaluationButtons : (Item -> comparable) -> Item -> Table.HtmlDetails Msg
viewEvaluationButtons getData item =
    Table.HtmlDetails []
        [ item |> getData |> toString |> text
        ]



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
