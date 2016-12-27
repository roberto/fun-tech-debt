module PostIt exposing (draw)

import Collage exposing (Form, filled, group, outlined, solid, rect, text, toForm)
import Text exposing (fromString, monospace, height)
import Element exposing (leftAligned)
import Color


draw : String -> Form
draw message =
    let
        formattedText =
            message
                |> fromString
                |> height 12
                |> monospace
                |> leftAligned
                |> toForm

        shape =
            rect 100 50

        content =
            shape |> filled Color.white

        border =
            shape |> outlined (solid Color.black)
    in
        group [ content, border, formattedText ]
