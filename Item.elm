module Item exposing (Item, Text, Evaluation, PositionTexts(PositionTexts))

import Element exposing (Position)


type PositionTexts
    = PositionTexts Position (List Text)


type alias Item =
    { effort : Evaluation
    , value : Evaluation
    , text : Text
    , id : Int
    }


type alias Text =
    String


type alias Evaluation =
    Float
