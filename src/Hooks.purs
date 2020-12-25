module Hooks 
  ( UI(..)
  , map
  , bind
  , discard
  , apply
  , pure
  , useState
  , runUI
  , make
  ) where

import Prelude hiding (map, bind, discard, apply, pure)

import Data.Symbol (class IsSymbol, SProxy)
import Prim.Row (class Cons, class Lacks, class Union)
import React.Basic.Classic (Component, JSX, Self)
import React.Basic.Classic as Classic
import Record (get, insert)

import Unsafe.Coerce (unsafeCoerce)

data UI i j a = UI (Record i -> Record j) (Record j -> a)

pick :: forall a b c. Union a b c => Record c -> Record a
pick = unsafeCoerce

map :: forall i j a b. (a -> b) -> UI i j a -> UI i j b
map f (UI ij h) = UI ij (\j -> f (h j))

apply :: forall i j k a b rest. Union j rest k => UI i j (a -> b) -> UI j k a -> UI i k b
apply x y = bind x \f -> map f y

discard :: forall i j k a b rest. Discard a => Union j rest k => UI i j a -> (a -> UI j k b) -> UI i k b
discard = bind

bind :: forall i j k a b rest. Union j rest k => UI i j a -> (a -> UI j k b) -> UI i k b
bind (UI ij ja) g = UI 
  (\i -> 
    let j = ij i 
        UI jk _ = g (ja j)
     in jk j)
  (\k -> 
    let j = pick k
        UI _ jka = g (ja j)
     in jka k) 
     
pure :: forall i a. a -> UI i i a
pure a = UI identity \_ -> a

useState 
  :: forall l i j a
   . IsSymbol l
  => Lacks l i
  => Cons l a i j
  => SProxy l
  -> a
  -> UI i j a
useState l a0 = UI (insert l a0) \r -> get l r

runUI
  :: forall s a
   . UI () s a
  -> { initialState :: Record s
     , render :: Record s -> a
     }
runUI (UI f g) = { initialState: f {}, render: g }

make
  :: forall props s
   . Component props
  -> UI () s (Self props (Record s) -> JSX)
  -> props
  -> JSX
make component ui = 
  let { initialState, render } = runUI ui
   in Classic.make component 
        { initialState
        , render: \self@{ state } -> render state self 
        }
   
   
   
   
   