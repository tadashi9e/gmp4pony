use "../../gmp"

class Complex
  """
  Complex number class based on mpf_t
  """
  var _r: Mpf box
  var _i: Mpf box

  new create(r: Mpf box, i: Mpf box) =>
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

  fun box real(): Mpf box => _r

  fun box image(): Mpf box => _i

  fun box eq(c: Complex box): Bool =>
    (_r == c._r) and (_i == c._i)

  fun box ne(c: Complex box): Bool =>
    (_r != c._r) or (_i != c._i)

  fun box add(c: Complex box): Complex box =>
    Complex(_r + c._r, _i + c._i)

  fun box sub(c: Complex box): Complex box =>
    Complex(_r - c._r, _i - c._i)

  fun box mul(c: Complex box): Complex box =>
    Complex((_r * c._r) - (_i * c._i),
            (_i * c._r) + (_r * c._i))

  fun box div(c: Complex box): Complex box =>
    let n: Mpf = norm() + c.norm()
    Complex(((_r * c.real()) + (_i * c.image())) / n,
      ((_i * c.real()) - (_r * c.image())) / n)

  fun box conj(): Complex =>
    Complex(_r, -_i)

  fun box norm(): Mpf box =>
    (_r * _r) + (_i * _i)

  fun box abs(): Mpf box =>
    norm().sqrt()
