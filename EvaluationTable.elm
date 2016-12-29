module EvaluationTable exposing (view, Msg(UpdateEffort, UpdatePain, SetTableState))

import Table
import EvaluationColumn exposing (evaluationColumn)
import Item exposing (Item, Evaluation)
import Html


type EvaluationType
    = Pain
    | Effort


type Msg
    = UpdateEffort Item Evaluation
    | UpdatePain Item Evaluation
    | SetTableState Table.State


view : Table.State -> List Item -> (Msg -> msg) -> Html.Html msg
view state items msg =
    Table.view (config msg) state items


config : (Msg -> msg) -> Table.Config Item msg
config toMsg =
    let
        values =
            [ 1, 2, 3 ]
    in
        Table.config
            { toId = .text
            , toMsg = SetTableState >> toMsg
            , columns =
                [ Table.stringColumn "Tech Debt" .text
                , evaluationColumn values "Effort" .effort (handleClick toMsg Effort)
                , evaluationColumn values "Pain" .value (handleClick toMsg Pain)
                ]
            }


handleClick : (Msg -> msg) -> EvaluationType -> Item -> Evaluation -> msg
handleClick toMsg evaluationType item number =
    case evaluationType of
        Pain ->
            toMsg (UpdatePain item number)

        Effort ->
            toMsg (UpdateEffort item number)
