module PostIt exposing (draw)

import Collage exposing (Form, collage, filled, group, outlined, solid, rect, text, toForm)
import Text exposing (fromString, monospace)
import Element exposing (leftAligned, flow, down, spacer, container, middle)
import Color


width : Float
width =
    100


height : Float
height =
    50


drawPostIt : String -> Form
drawPostIt message =
    let
        formattedText =
            message
                |> fromString
                |> Text.height 12
                |> monospace
                |> leftAligned
                |> container (round width) (round height) Element.topLeft
                |> toForm

        shape =
            rect width height

        content =
            shape |> filled Color.white

        border =
            shape |> outlined (solid Color.black)
    in
        group [ content, border, formattedText ]


draw : ( Int, Int ) -> List String -> Form
draw ( widthTotal, heightTotal ) texts =
    let
        element form =
            collage (round width) (round height) [ form ]

        plot text =
            element (drawPostIt text)

        postIts =
            List.map plot texts

        spaces =
            List.intersperse (spacer 5 5)
    in
        flow down (spaces postIts) |> toForm
