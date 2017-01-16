module PostIt exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Css exposing (border3, boxShadow3, px, solid, asPairs, rgb, width, height, fontSize, margin)
import Item exposing (Item)


cardStyle : Html.Attribute msg
cardStyle =
    [ border3 (px 1) solid (rgb 1 1 1)
    , boxShadow3 (px 1) (px 2) (px 3)
    , width (px 150)
    , height (px 50)
    , fontSize (px 12)
    , margin (px 5)
    ]
        |> asPairs
        |> style


view : Item -> Html a
view { text } =
    div
        [ cardStyle ]
        [ Html.text text ]
