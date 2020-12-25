module Main where

import Prelude

import Counter (counter)
import Data.Foldable (for_)
import Effect (Effect)
import React.Basic.DOM (render)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  document <- document =<< window
  container <- getElementById "root" (toNonElementParentNode document)
  for_ container (render (counter { label: "Increment" }))