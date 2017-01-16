module Item exposing (Item, Text, Evaluation)


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
