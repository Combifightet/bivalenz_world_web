# Bivalenz World Web

## To do

- [X] Create base application Layout class
- [X] Create object classes
- [X] Create shape renderer
- [X] Create board renderer
- [ ] Create board manager
- [ ] Evalueate logic statements
- [ ] Export and import "BivalenzWorld" data
- [ ] Create ui
- [ ] . . .
- [ ] Improve ux (light mode toggle?)

## Possible new names

- Bivalenz World v2
- Bivalenz World Web
- Bivalenz World Remastered
- FOL World (first-order-logic)

## Supported PL1 Syntax

### Predicate symbols

> A `predicate symbol` Pr is a symbol representing a property of a object or a relation between objects designated. And it alway has a return value of `true` or `false`

> An `atomic sentence` is a predicate symbol applied to an `individual constant`

 Atomic set         | Bivalence World equivalence | Interpretation
--------------------|:---------------------------:|------------------
 `Tri(a)`           | `Tet(a)`                    | _`a`_ is a triangle
 `Sqr(a)`           | `Cube(a)`                   | _`a`_ is a square
 `Pent(a)`          | `Dodec(a)`                  | _`a`_ is a pentagon
 `Small(a)`         | "                           | _`a`_ is small
 `Medium(a)`        | "                           | _`a`_ is medium
 `Large(a)`         | "                           | _`a`_ is large
 `SameSize(a, b)`   | "                           | _`a`_ is has the same size as _`b`_
 `SameShape(a, b)`  | "                           | _`a`_ is has the same shape as _`b`_
 `Larger(a, b)`     | "                           | _`a`_ is larger than _`b`_
 `Smaller(a, b)`    | "                           | _`a`_ is smaller than _`b`_
 `SameCol(a, b)`    | "                           | _`a`_ is in the same column as _`b`_
 `SameRow(a, b)`    | "                           | _`a`_ is in the same row as _`b`_
 `Adjoins(a, b)`    | "                           | _`a`_ and _`b`_ on neighbouring squares (not diagonal)
 `LeftOf(a, b)`     | "                           | _`a`_ is positioned closer to the left edge then _`b`_
 `RightOf(a, b)`    | "                           | _`a`_ is positioned closer to the right edge then _`b`_
 `BelowOf(a, b)`    | `FrontOf(a, b)`             | _`a`_ is positioned closer to the bottom edge then _`b`_
 `AboveOf(a, b)`    | `BackOf(a, b)`              | _`a`_ is positioned closer to the top edge then _`b`_
 `Between(a, b, c)` | "                           | _`a`_, _`b`_ and _`c`_ are located in the same row, column or diagonal and a is positioned between _`b`_ and _`c`_

### Funtion symbols

> A `function symbol` _f_ is a symbol representing a relation (function) between objects.

> A `funtion` alway has a return value of an `individual constant`

 Function | Interpretation
----------|-------------------
 `+`      |
 `-`      |
 `*`      |
 `/`      |
 `rm(a)`  | returns the rightmost individual constant in the row of `a`
 `lm(a)`  |
 `fm(a)`  |
 `bm(a)`  |

### Individual constant

> An `individual constant` is a symbol that represents exactly one person, denoting thing or object.

### Variable free term

> Every individual constant _`c`_ is a term,

> If _t<sub>1</sub>, . . . ,t<sub>n</sub>_ are terms and _f_ is an n-ary term function symbol, then f(_t<sub>1</sub>, . . . ,t<sub>n</sub>_) is also an expression.

### Propositional sentence
