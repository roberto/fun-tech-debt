module Zone exposing (draw)

import Collage exposing (Form, collage, filled, rect, toForm, move, group)
import Element exposing (Element, Position, container)
import Color


type alias Zone =
    { position : Position
    , section : Section
    }


type Section
    = Neutral
    | Good
    | Bad


type alias Location =
    ( Float, Float )


type alias Dimension =
    ( Float, Float )


default : List Zone
default =
    [ { position = Element.topLeft, section = Bad }
    , { position = Element.topRight, section = Neutral }
    , { position = Element.bottomLeft, section = Neutral }
    , { position = Element.bottomRight, section = Good }
    ]


color : Section -> Color.Color
color section =
    case section of
        Neutral ->
            Color.white

        Good ->
            -- green
            Color.rgba 115 210 22 0.5

        Bad ->
            -- red
            Color.rgba 204 0 0 0.5


drawZone : ( Int, Int ) -> Zone -> Form
drawZone ( widthTotal, heightTotal ) zone =
    let
        ( width, height ) =
            ( (toFloat widthTotal) / 2, (toFloat heightTotal) / 2 )

        paint =
            rect width height
                |> filled (color zone.section)

        element form =
            collage (round width) (round height) [ form ]

        plot =
            container widthTotal heightTotal zone.position
    in
        paint |> element |> plot |> toForm


draw : ( Int, Int ) -> Form
draw dimension =
    List.map (drawZone dimension) default |> group
