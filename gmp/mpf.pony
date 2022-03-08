use "lib:gmp"
use "lib:gmp4pony"

use @pony_mpf_set_default_prec[None](prec: U64)
use @pony_mpf_get_default_prec[U64]()
use @pony_mpf_init[Pointer[None] tag]()
use @pony_mpf_init_set_ui[Pointer[None] tag](i: U64)
use @pony_mpf_init_set_si[Pointer[None] tag](i: I64)
use @pony_mpf_init_set_d[Pointer[None] tag](double: F64)
use @pony_mpf_init_set_z[Pointer[None] tag](z: Pointer[None] tag)
use @pony_mpf_init_set[Pointer[None] tag](f: Pointer[None] tag)
use @pony_mpf_init_set_str[Pointer[None] tag](s: Pointer[U8] tag,  base: I32)
use @pony_mpf_set_prec[None](f: Pointer[None] tag, prec: U64)
use @pony_mpf_get_prec[U64](f: Pointer[None] tag)
use @pony_mpf_clear[None](f: Pointer[None] tag)
use @pony_mpf_get_ui[U64](f: Pointer[None] tag)
use @pony_mpf_get_si[I64](f: Pointer[None] tag)
use @pony_mpf_get_d[F64](f: Pointer[None] tag)
use @pony_mpf_abs[None](r: Pointer[None] tag, f: Pointer[None] tag)
use @pony_mpf_add[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpf_sub[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpf_mul[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpf_div[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpf_sqrt[None](r: Pointer[None] tag, f: Pointer[None] tag)
use @pony_mpf_cmp[I32](f: Pointer[None] tag, other: Pointer[None] tag)
use @pony_mpf_snprintf[Pointer[U8] ref](
  buf: Pointer[U8] tag, size: USize,
  format: Pointer[U8] tag, f: Pointer[None] tag)

class Mpf
  """
  mpf_t wrapper class
  """
  let _f: Pointer[None] tag

  fun tag set_default_prec(prec: U64): None =>
    @pony_mpf_set_default_prec(prec)

  fun tag get_default_prec(): U64 =>
    @pony_mpf_get_default_prec()

  new create() =>
    """
    Initialize to 0 (mpf_init).
    """
    _f = @pony_mpf_init()

  fun set_prec(prec: U64): None =>
    @pony_mpf_set_prec(_f, prec)

  fun box get_prec(): U64 =>
    @pony_mpf_get_prec(_f)

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

  new from_mpz(mpz: Mpz box) =>
    """
    Initialize and set the value from mpz (mpf_init & mpf_set_z).
    """
    _f = @pony_mpf_init_set_z(mpz.cpointer())

  new from(mpf: Mpf box) =>
    """
    Initialize and set the value from mpf (mpf_init & mpf_set).
    """
    _f = @pony_mpf_init_set(mpf.cpointer())

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

  fun box cpointer(): Pointer[None] tag =>
    """
    Get mpf_t pointer.
    """
    _f

  fun box i64(): I64 =>
    """
    Convert value to I64 (mpf_get_si).
    """
    @pony_mpf_get_si(_f)

  fun box u64(): U64 =>
    """
    Convert value to U64 (mpf_get_ui).
    """
    @pony_mpf_get_ui(_f)

  fun box f64(): F64 =>
    """
    Convert value to F64 (mpf_get_d).
    """
    @pony_mpf_get_d(_f)

  fun box format(bufSize: USize = 100, pattern: String = "%Ff",
      base: I32 = 10): String ref =>
    """
    Format value to string ref (gmp_snprintf).
    """
    let s: String iso = recover iso String(bufSize) end
    String.from_cstring(@pony_mpf_snprintf(s.cpointer(), bufSize,
    pattern.cstring(), _f))

  fun box string(bufSize: USize = 100, pattern: String = "%Ff",
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

  fun box abs(): Mpf =>
    """
    Convert value to absolute.
    """
    let r: Mpf = Mpf
    @pony_mpf_abs(r._f, _f)
    r

  fun box neg(): Mpf =>
    """
    Convert value to negative.
    """
    let r: Mpf = Mpf
    let zero: Mpf = Mpf.from_i64(0)
    @pony_mpf_sub(r._f, zero._f, _f)
    r

  fun box add(other: Mpf box): Mpf =>
    """
    add operattor (mpf_add).
    """
    let r: Mpf = Mpf
    @pony_mpf_add(r._f, _f, other._f)
    r

  fun box sub(other: Mpf box): Mpf =>
    """
    sub operattor (mpf_sub).
    """
    let r: Mpf = Mpf
    @pony_mpf_sub(r._f, _f, other._f)
    r

  fun box mul(other: Mpf box): Mpf =>
    """
    mul operattor (mpf_mul).
    """
    let r: Mpf = Mpf
    @pony_mpf_mul(r._f, _f, other._f)
    r

  fun box div(other: Mpf box): Mpf =>
    """
    div operattor (mpf_div).
    """
    let r: Mpf = Mpf
    @pony_mpf_div(r._f, _f, other._f)
    r

  fun box sqrt(): Mpf =>
    """
    Returns square root of value (mpf_sqrt).
    """
    let r: Mpf = Mpf
    @pony_mpf_sqrt(r._f, _f)
    r

  fun box eq(other: Mpf box): Bool =>
    """
    eq operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) == 0 then
      true
    else
      false
    end

  fun box ne(other: Mpf box): Bool =>
    """
    ne operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) == 0 then
      false
    else
      true
    end

  fun box lt(other: Mpf box): Bool =>
    """
    lt operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) < 0 then
      true
    else
      false
    end

  fun box le(other: Mpf box): Bool =>
    """
    le operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) <= 0 then
      true
    else
      false
    end

  fun box gt(other: Mpf box): Bool =>
    """
    gt operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) > 0 then
      true
    else
      false
    end

  fun box ge(other: Mpf box): Bool =>
    """
    Ge operator (mpf_cmp).
    """
    if @pony_mpf_cmp(_f, other._f) >= 0 then
      true
    else
      false
    end
