use "lib:gmp"
use "lib:gmp4pony"

use @pony_mpf_set_default_prec[None](prec: U64)
use @pony_mpf_get_default_prec[U64]()
use @pony_mpf_init[Pointer[None]]() 
use @pony_mpf_init_set_ui[Pointer[None]](i: U64)
use @pony_mpf_init_set_si[Pointer[None]](i: I64)
use @pony_mpf_init_set_d[Pointer[None]](double: F64)
use @pony_mpf_init_set_z[Pointer[None]](f: Pointer[None])
use @pony_mpf_init_set_str[Pointer[None]](s: Pointer[U8] tag,  base: I32)
use @pony_mpf_clear[None](f: Pointer[None])
use @pony_mpf_get_ui[U64](f: Pointer[None])
use @pony_mpf_get_si[I64](f: Pointer[None])
use @pony_mpf_get_d[F64](f: Pointer[None])
use @pony_mpf_add[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpf_sub[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpf_mul[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpf_div[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpf_sqrt[None](r: Pointer[None], f: Pointer[None])
use @pony_mpf_cmp[I32](f: Pointer[None], other: Pointer[None])
use @pony_mpf_snprintf[Pointer[U8] ref](
  buf: Pointer[U8] tag, size: USize, format: Pointer[U8] tag, f: Pointer[None])

class Mpf
  """
  mpf_t wrapper class
  """
  let _f: Pointer[None]

  fun set_default_prec(prec: U64): None =>
    @pony_mpf_set_default_prec(prec)

  fun get_default_prec(): U64 =>
    @pony_mpf_get_default_prec()

  new create() =>
    """
    Initialize to 0 (mpf_init).
    """
    _f = @pony_mpf_init()

  new from_u64(u: U64) =>
    """
    Initialize and set the value from u (mpf_init_set_ui).
    """
    _f = @pony_mpf_init_set_ui(u)

  new from_i64(i: I64) =>
    """
    Initialize and set the value from i (mpf_init_set_si).
    """
    _f = @pony_mpf_init_set_si(i)

  new from_f64(double: F64) =>
    """
    Initialize and set the value from double (mpf_init_set_d).
    """
    _f = @pony_mpf_init_set_d(double)

  new from_mpz(mpz: Mpz) =>
    """
    Initialize and set the value from mpz (mpf_init & mpf_set_z).
    """
    _f = @pony_mpf_init_set_z(mpz.cpointer())

  new from_string(s: String, base: I32 = 10) =>
    """
    Initialize and set the value from s (mpf_init_set_str).
    """
    _f = @pony_mpf_init_set_str(s.cstring(), base)

  fun _final() =>
    """
    Free the space occupied by mpf_t (mpf_clear).
    """
    @pony_mpf_clear(_f)

  fun cpointer(): Pointer[None] tag =>
    """
    Get mpf_t pointer.
    """
    _f

  fun i64(): I64 =>
    """
    Convert value to I64 (mpf_get_si).
    """
    @pony_mpf_get_si(_f)

  fun u64(): U64 =>
    """
    Convert value to U64 (mpf_get_ui).
    """
    @pony_mpf_get_ui(_f)

  fun f64(): F64 =>
    """
    Convert value to F64 (mpf_get_d).
    """
    @pony_mpf_get_d(_f)

  fun format(bufSize: USize = 100, pattern: String = "%Ff",
      base: I32 = 10): String ref =>
    """
    Format value to string ref (gmp_snprintf).
    """
    let s: String iso = recover iso String(bufSize) end
    String.from_cstring(@pony_mpf_snprintf(s.cpointer(), bufSize,
    pattern.cstring(), _f))

  fun string(bufSize: USize = 100, pattern: String = "%Ff",
    base: I32 = 10): String val =>
    """
    Format value to string val (gmp_snprintf).
    """
    let s: String ref = format(bufSize, pattern, base)
    let copy: String iso = recover iso String(bufSize) end
    var i: ISize = 0
    try
      while i < bufSize.isize() do
        copy.push(s.at_offset(i)?)
        i = i + 1
      end
    end
    consume copy

  fun neg(): Mpf =>
    """
    Convert value to negative.
    """
    let r: Mpf = Mpf
    let zero: Mpf = Mpf.from_i64(0)
    @pony_mpf_sub(r._f, zero._f, _f)
    r

  fun add(other: Mpf): Mpf =>
    """
    add operattor (mpf_add).
    """
    let r: Mpf = Mpf
    @pony_mpf_add(r._f, _f, other._f)
    r

  fun sub(other: Mpf): Mpf =>
    """
    sub operattor (mpf_sub).
    """
    let r: Mpf = Mpf
    @pony_mpf_sub(r._f, _f, other._f)
    r

  fun mul(other: Mpf): Mpf =>
    """
    mul operattor (mpf_mul).
    """
    let r: Mpf = Mpf
    @pony_mpf_mul(r._f, _f, other._f)
    r

  fun div(other: Mpf): Mpf =>
    """
    div operattor (mpf_div).
    """
    let r: Mpf = Mpf
    @pony_mpf_div(r._f, _f, other._f)
    r

  fun sqrt(): Mpf =>
    """
    Returns square root of value (mpf_sqrt).
    """
    let r: Mpf = Mpf
    @pony_mpf_sqrt(r._f, _f)
    r

  fun eq(other: Mpf): Bool =>
    """
    eq operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) == 0 then
      true
    else
      false
    end

  fun ne(other: Mpf): Bool =>
    """
    ne operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) == 0 then
      false
    else
      true
    end

  fun lt(other: Mpf): Bool =>
    """
    lt operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) < 0 then
      true
    else
      false
    end

  fun le(other: Mpf): Bool =>
    """
    le operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) <= 0 then
      true
    else
      false
    end

  fun gt(other: Mpf): Bool =>
    """
    gt operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) > 0 then
      true
    else
      false
    end

  fun ge(other: Mpf): Bool =>
    """
    Ge operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) >= 0 then
      true
    else
      false
    end
