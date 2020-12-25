purescript-hooks
================

This is an experimental package, not intended for real-world use. It demonstrates that we can create a pure implementation of something like React's hooks (i.e. without relying on mutable variables or references behind the scenes) using an abstraction similar to indexed monads.

Knowing that indexed monads represent (in a sense) the "essence" of hooks can help as a guiding principle when we use them in practice. For example, when can we use a function like traverse in order to combine multiple components? Indexed monads tell us that we should only use a function like traverse when we can preserve indices in the types, i.e. when the container we're traversing has a statically-known size.

A hooks-based version of the react-basic counter demo is provided for illustration.
