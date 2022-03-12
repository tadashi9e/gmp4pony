# gmp4pony

GMP wrapper for Pony. Requires GNU MP.

## Status

pre-alpha software.

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Install GMP library (gmp.h, libgmp.so)
* Install [corral](https://github.com/ponylang/corral)
* `corral init` in your project directory
* `corral add github.com/tadashi9e/gmp4pony.git --version 0.0.1`
* `corral update`
* `use "gmp"` to include this package
* `corral run -- ponyc` to compile your application

## Limitation

I tested on Ubuntu 20.04 LTS only.
