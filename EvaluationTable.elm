module EvaluationTable exposing (view, Msg(UpdateEffort, UpdateValue, SetTableState))

import Table
import EvaluationColumn exposing (evaluationColumn)
import Item exposing (Item, Evaluation)
import Html


type EvaluationType
    = Value
    | Effort


type Msg
    = UpdateEffort Item Evaluation
    | UpdateValue Item Evaluation
    | SetTableState Table.State


view : Table.State -> List Item -> (Msg -> msg) -> Html.Html msg
view state items msg =
    Table.view (config msg) state items


config : (Msg -> msg) -> Table.Config Item msg
config msg =
    let
        values =
            [ 1, 2, 3 ]
    in
        Table.config
            { toId = .text
            , toMsg = (\x -> msg (SetTableState x))
            , columns =
                [ Table.stringColumn "Tech Debt" .text
                , evaluationColumn values "Effort" .effort (handleClick msg Effort)
                , evaluationColumn values "Value" .value (handleClick msg Value)
                ]
            }


handleClick : (Msg -> msg) -> EvaluationType -> Item -> Evaluation -> msg
handleClick msg evaluationType item number =
    case evaluationType of
        Value ->
            msg (UpdateValue item number)

        Effort ->
            msg (UpdateEffort item number)
