module Wall exposing (draw)

import Collage exposing (collage)
import Element exposing (Element, toHtml)
import Html exposing (Html)
import PostIt
import Zone
import Item exposing (Item)


draw : ( Int, Int ) -> List Item -> Html a
draw ( width, height ) items =
    let
        zones =
            Zone.draw ( width, height )

        postIts =
            PostIt.draw ( width, height ) (List.map .text items)

        things =
            [ zones, postIts ]
    in
        collage width height things |> toHtml
