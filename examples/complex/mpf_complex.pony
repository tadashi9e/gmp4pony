use "../../gmp"

class Complex
  """
  Complex number class based on mpf_t
  """
  var _r: Mpf val
  var _i: Mpf val

  new iso create(r: Mpf val, i: Mpf val) =>
    _r = r
    _i = i

  fun box string(): String =>
    if _r == Mpf then
      _i.string() + "i"
    elseif _i == Mpf then
      _r.string()
    elseif _i < Mpf then
      _r.string() + _i.string() + "i"
    else
      _r.string() + "+" + _i.string() + "i"
    end

  fun box real(): Mpf val => _r

  fun box imag(): Mpf val => _i

  fun box eq(c: Complex val): Bool =>
    (_r == c._r) and (_i == c._i)

  fun box ne(c: Complex val): Bool =>
    (_r != c._r) or (_i != c._i)

  fun box add(c: Complex box): Complex box =>
    Complex(_r + c._r, _i + c._i)

  fun box sub(c: Complex box): Complex box =>
    Complex(_r - c._r, _i - c._i)

  fun box mul(c: Complex box): Complex box =>
    Complex((_r * c._r) - (_i * c._i),
            (_i * c._r) + (_r * c._i))

  fun box div(c: Complex val): Complex box =>
    let n: Mpf val = norm() + c.norm()
    Complex(
      ((_r * c.real()) + (_i * c.imag())) / n,
      ((_i * c.real()) - (_r * c.imag())) / n)

  fun box conj(): Complex =>
    Complex(_r, -_i)

  fun box norm(): Mpf val =>
    (_r * _r) + (_i * _i)

  fun box abs(): Mpf val =>
    norm().sqrt()
