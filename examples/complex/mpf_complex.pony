use "../../gmp"

class Complex
  """
  Complex number class based on mpf_t
  """
  var _r: Mpf
  var _i: Mpf

  new create(r: Mpf, i: Mpf) =>
    _r = r
    _i = i

  fun string(): String =>
    if _r == Mpf then
      _i.string() + "i"
    elseif _i == Mpf then
      _r.string()
    elseif _i < Mpf then
      _r.string() + _i.string() + "i"
    else
      _r.string() + "+" + _i.string() + "i"
    end

  fun ref real(): Mpf => _r

  fun ref image(): Mpf => _i

  fun ref eq(c: Complex ref): Bool =>
    (_r == c._r) and (_i == c._i)

  fun ref ne(c: Complex ref): Bool =>
    (_r != c._r) or (_i != c._i)

  fun ref add(c: Complex ref): Complex ref =>
    Complex(_r + c._r, _i + c._i)

  fun ref sub(c: Complex ref): Complex ref =>
    Complex(_r - c._r, _i - c._i)

  fun ref mul(c: Complex ref): Complex ref =>
    Complex((_r * c._r) - (_i * c._i),
            (_i * c._r) + (_r * c._i))

  fun ref div(c: Complex ref): Complex ref =>
    let n: Mpf = norm() + c.norm()
    Complex(((_r * c.real()) + (_i * c.image())) / n,
      ((_i * c.real()) - (_r * c.image())) / n)

  fun ref conj(): Complex =>
    Complex(_r, -_i)

  fun ref norm(): Mpf =>
    (_r * _r) + (_i * _i)

  fun ref abs(): Mpf =>
    norm().sqrt()
