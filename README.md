# gmp4pony

GMP wrapper for Pony. Requires GNU MP.

## Status

pre-alpha software.

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Install GMP library (gmp.h, libgmp.so)
* Update your `bundle.json`

```json
{
  "type": "github",
  "repo": "tadashi9e/gmp4pony"
}
```

* `stable fetch` to fetch your dependencies
* `use "gmp"` to include this package
* `stable env ponyc` to compile your application
