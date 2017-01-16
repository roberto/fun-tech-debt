module Wall exposing (view)

import Html exposing (Html, div)
import Item exposing (Item, Evaluation)
import PostIt exposing (view)
import Dict.Extra exposing (groupBy)
import Dict


view : List Item -> Html a
view items =
    let
        list =
            -- temp... split by groups
            items |> groupByEvaluation |> Dict.values |> List.concat
    in
        div
            []
            (List.map PostIt.view list)


groupByEvaluation : List Item -> Dict.Dict ( Evaluation, Evaluation ) (List Item)
groupByEvaluation items =
    let
        key { value, effort } =
            ( value, effort )
    in
        groupBy key items


main : Html a
main =
    view
        [ { id = 1, text = "Do something 1", value = 1, effort = 1 }
        , { id = 2, text = "Do something 2", value = 1, effort = 2 }
        , { id = 3, text = "Do something 3", value = 1, effort = 3 }
        , { id = 4, text = "Do something 4", value = 2, effort = 1 }
        , { id = 5, text = "Do something 5", value = 2, effort = 2 }
        , { id = 6, text = "Do something 6", value = 2, effort = 3 }
        , { id = 7, text = "Do something 7", value = 3, effort = 1 }
        , { id = 8, text = "Do something 8", value = 3, effort = 2 }
        , { id = 9, text = "Do something 9", value = 3, effort = 3 }
        ]
