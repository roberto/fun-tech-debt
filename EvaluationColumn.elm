module EvaluationColumn exposing (evaluationColumn)

import Table
import Html exposing (Html, text, button)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)


type alias HandleClick item msg =
    item -> Float -> msg


type alias Value =
    Float


type alias PossibleValues =
    List Value


evaluationColumn : PossibleValues -> String -> (item -> Value) -> HandleClick item msg -> Table.Column item msg
evaluationColumn values name getData handleClick =
    Table.veryCustomColumn
        { name = name
        , viewData = viewEvaluationButtons values getData handleClick
        , sorter = Table.increasingOrDecreasingBy getData
        }


viewEvaluationButtons : PossibleValues -> (item -> Value) -> HandleClick item msg -> item -> Table.HtmlDetails msg
viewEvaluationButtons values getData handleClick item =
    let
        currentNumber =
            getData item

        renderButton number =
            button
                [ onClick (handleClick item number)
                , disabled (number == currentNumber)
                ]
                [ text (toString number) ]
    in
        Table.HtmlDetails []
            (List.map renderButton values)
