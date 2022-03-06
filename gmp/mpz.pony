use "lib:gmp"
use "lib:gmp4pony"

use @pony_mpz_init[Pointer[None]]()
use @pony_mpz_init_set_ui[Pointer[None]](i: U64)
use @pony_mpz_init_set_si[Pointer[None]](i: I64)
use @pony_mpz_init_set_d[Pointer[None]](double: F64)
use @pony_mpz_init_set_str[Pointer[None]](s: Pointer[U8] tag,  base: I32)
use @pony_mpz_init_set_f[Pointer[None]](f: Pointer[None] tag)
use @pony_mpz_clear[None](p: Pointer[None])
use @pony_mpz_get_si[I64](p: Pointer[None])
use @pony_mpz_get_ui[U64](p: Pointer[None])
use @pony_mpz_get_d[F64](p: Pointer[None])
use @pony_mpz_add[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_sub[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_mul[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_fdiv_q[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_and[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_ior[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_xor[None](r: Pointer[None], a: Pointer[None], b: Pointer[None])
use @pony_mpz_cmp[I32](z: Pointer[None], other: Pointer[None])
use @pony_mpz_sizeinbase[USize](p: Pointer[None], base: I32)
use @pony_mpz_snprintf[Pointer[U8] ref](
  buf: Pointer[U8] tag, size: USize, format: Pointer[U8] tag, p: Pointer[None])

class Mpz
  """
  mpz_t wrapper class
  """
  let _z: Pointer[None]

  new create() =>
    """
    Initialize to 0 (mpz_init).
    """
    _z = @pony_mpz_init()

  new from_u64(u: U64) =>
    """
    Initialize and set the value from u (mpz_init_set_ui).
    """
    _z = @pony_mpz_init_set_ui(u)

  new from_i64(i: I64) =>
    """
    Initialize and set the value from i (mpz_init_set_si).
    """
    _z = @pony_mpz_init_set_si(i)

  new from_f64(double: F64) =>
    """
    Initialize and set the value from double (mpz_init_set_d).
    """
    _z = @pony_mpz_init_set_d(double)

  new from_mpf(mpf: Mpf) =>
    """
    Initialize and set the value from mpf (mpz_init & mpz_set_f).
    """
    _z = @pony_mpz_init_set_f(mpf.cpointer())

  new from_string(s: String, base: I32 = 10) =>
    """
    Initialize and set the value from s (mpz_init_set_str).
    """
    _z = @pony_mpz_init_set_str(s.cstring(), base)

  fun _final() =>
    """
    Free the space occupied by mpz_t (mpz_clear).
    """
    @pony_mpz_clear(_z)

  fun cpointer(): Pointer[None] tag =>
    """
    Get mpz_t pointer.
    """
    _z

  fun i64(): I64 =>
    """
    Convert value to I64 (mpz_get_si).
    """
    @pony_mpz_get_si(_z)

  fun u64(): U64 =>
    """
    Convert value to U64 (mpz_get_ui).
    """
    @pony_mpz_get_ui(_z)

  fun f64(): F64 =>
    """
    Convert value to F64 (mpz_get_d).
    """
    @pony_mpz_get_d(_z)

  fun format(bufSize: USize = 100, pattern: String = "%Zd",
      base: I32 = 10): String ref =>
    """
    Format value to string ref (gmp_snprintf).
    """
    let s: String iso = recover iso String(bufSize) end
    String.from_cstring(@pony_mpz_snprintf(s.cpointer(), bufSize,
    "%Zd".cstring(), _z))

  fun string(bufSize: USize = 0, pattern: String = "%Zd",
      base: I32 = 10): String val =>
    """
    Format value to string val (gmp_snprintf).
    """
    let sz: USize =
      if bufSize > 0 then
        bufSize
      else
        @pony_mpz_sizeinbase(_z, base) + 1
      end
    let s: String ref = format(
      where bufSize = sz, pattern = pattern, base = base)
    let copy: String iso = recover iso String(sz) end
    var i: ISize = 0
    try
      while i < bufSize.isize() do
        copy.push(s.at_offset(i)?)
        i = i + 1
      end
    end
    consume copy

  fun neg(): Mpz =>
    """
    Convert value to negative.
    """
    let r: Mpz = Mpz
    let zero: Mpz = Mpz.from_i64(0)
    @pony_mpz_sub(r._z, zero._z, _z)
    r

  fun add(other: Mpz): Mpz =>
    """
    add operattor (mpz_add).
    """
    let r: Mpz = Mpz
    @pony_mpz_add(r._z, _z, other._z)
    r

  fun sub(other: Mpz): Mpz =>
    """
    sub operattor (mpz_sub).
    """
    let r: Mpz = Mpz
    @pony_mpz_sub(r._z, _z, other._z)
    r

  fun mul(other: Mpz): Mpz =>
    """
    mul operattor (mpz_mul).
    """
    let r: Mpz = Mpz
    @pony_mpz_mul(r._z, _z, other._z)
    r

  fun div(other: Mpz): Mpz =>
    """
    div operattor (mpz_div).
    """
    let r: Mpz = Mpz
    @pony_mpz_fdiv_q(r._z, _z, other._z)
    r

  fun op_and(other: Mpz): Mpz =>
    """
    and operator (mpz_and).
    """
    let r: Mpz = Mpz
    @pony_mpz_and(r._z, _z, other._z)
    r

  fun op_or(other: Mpz): Mpz =>
    """
    or operator (mpz_ior).
    """
    let r: Mpz = Mpz
    @pony_mpz_ior(r._z, _z, other._z)
    r

  fun op_xor(other: Mpz): Mpz =>
    """
    xor operator (mpz_xor).
    """
    let r: Mpz = Mpz
    @pony_mpz_xor(r._z, _z, other._z)
    r

  fun eq(other: Mpz): Bool =>
    """
    eq operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) == 0 then
      true
    else
      false
    end

  fun ne(other: Mpz): Bool =>
    """
    ne operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) == 0 then
      false
    else
      true
    end

  fun lt(other: Mpz): Bool =>
    """
    lt operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) < 0 then
      true
    else
      false
    end

  fun le(other: Mpz): Bool =>
    """
    le operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) <= 0 then
      true
    else
      false
    end

  fun gt(other: Mpz): Bool =>
    """
    gt operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) > 0 then
      true
    else
      false
    end

  fun ge(other: Mpz): Bool =>
    """
    ge operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) >= 0 then
      true
    else
      false
    end
