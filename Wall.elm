module Wall exposing (draw)

import Collage exposing (collage)
import Element exposing (Element, toHtml)
import Html exposing (Html)
import PostIt
import Zone
import Item exposing (Item, PositionTexts)


draw : ( Int, Int ) -> List PositionTexts -> Html a
draw ( width, height ) positionTexts =
    let
        zones =
            Zone.draw ( width, height )

        postItZone (Item.PositionTexts position texts) =
            PostIt.draw ( width, height ) position texts

        postIts =
            List.map postItZone positionTexts

        things =
            zones :: postIts
    in
        collage width height things |> toHtml
