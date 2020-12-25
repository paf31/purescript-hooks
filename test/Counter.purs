module Counter where

import Prelude

import Data.Symbol (SProxy(..))
import Hooks (make, useState)
import Hooks as Hooks
import React.Basic.Classic (Component, createComponent, JSX)
import React.Basic.DOM as R
import React.Basic.DOM.Events (capture_)

component :: Component Props
component = createComponent "counter"

type Props =
  { label :: String
  }

counter :: Props -> JSX
counter = make component Hooks.do
  value <- useState (SProxy :: SProxy "value") 0
  Hooks.pure \self ->
    R.button
      { onClick: capture_ $ self.setState \s -> s { value = s.value + 1 }
      , children: [ R.text (self.props.label <> ": " <> show value) ]
      }