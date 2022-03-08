use "lib:gmp"
use "lib:gmp4pony"

use @pony_mpz_init[Pointer[None] tag]()
use @pony_mpz_init_set_ui[Pointer[None] tag](i: U64)
use @pony_mpz_init_set_si[Pointer[None] tag](i: I64)
use @pony_mpz_init_set_d[Pointer[None] tag](double: F64)
use @pony_mpz_init_set_str[Pointer[None] tag](s: Pointer[U8] tag,  base: I32)
use @pony_mpz_init_set_f[Pointer[None] tag](f: Pointer[None] tag)
use @pony_mpz_init_set[Pointer[None] tag](z: Pointer[None] tag)
use @pony_mpz_clear[None](z: Pointer[None] tag)
use @pony_mpz_get_si[I64](z: Pointer[None] tag)
use @pony_mpz_get_ui[U64](z: Pointer[None] tag)
use @pony_mpz_get_d[F64](z: Pointer[None] tag)
use @pony_mpz_add[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_sub[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_mul[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_fdiv_q[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_and[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_ior[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_xor[None](
  r: Pointer[None] tag, a: Pointer[None] tag, b: Pointer[None] tag)
use @pony_mpz_setbit[None](z: Pointer[None] tag, bit_index: U64)
use @pony_mpz_clrbit[None](z: Pointer[None] tag, bit_index: U64)
use @pony_mpz_combit[None](z: Pointer[None] tag, bit_index: U64)
use @pony_mpz_tstbit[I32](z: Pointer[None] tag, bit_index: U64)
use @pony_mpz_cmp[I32](z: Pointer[None] tag, other: Pointer[None] tag)
use @pony_mpz_sizeinbase[USize](p: Pointer[None] tag, base: I32)
use @pony_mpz_snprintf[Pointer[U8] ref](
  buf: Pointer[U8] tag, size: USize, format:
  Pointer[U8] tag, p: Pointer[None] tag)

class Mpz
  """
  mpz_t wrapper class
  """
  let _z: Pointer[None] tag

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

  new from_mpz(mpz: Mpz box) =>
    """
    Initialize and set the value from mpz (mpz_init & mpz_set).
    """
    _z = @pony_mpz_init_set(mpz.cpointer())

  new from(mpf: Mpf box) =>
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

  fun box cpointer(): Pointer[None] tag =>
    """
    Get mpz_t pointer.
    """
    _z

  fun box i64(): I64 =>
    """
    Convert value to I64 (mpz_get_si).
    """
    @pony_mpz_get_si(_z)

  fun box u64(): U64 =>
    """
    Convert value to U64 (mpz_get_ui).
    """
    @pony_mpz_get_ui(_z)

  fun box f64(): F64 =>
    """
    Convert value to F64 (mpz_get_d).
    """
    @pony_mpz_get_d(_z)

  fun box format(bufSize: USize = 100, pattern: String = "%Zd",
      base: I32 = 10): String ref =>
    """
    Format value to string ref (gmp_snprintf).
    """
    let s: String iso = recover iso String(bufSize) end
    String.from_cstring(@pony_mpz_snprintf(s.cpointer(), bufSize,
    "%Zd".cstring(), _z))

  fun box string(bufSize: USize = 0, pattern: String = "%Zd",
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

  fun box neg(): Mpz =>
    """
    Convert value to negative.
    """
    let r: Mpz = Mpz
    let zero: Mpz = Mpz.from_i64(0)
    @pony_mpz_sub(r._z, zero._z, _z)
    r

  fun box add(other: Mpz box): Mpz =>
    """
    add operattor (mpz_add).
    """
    let r: Mpz = Mpz
    @pony_mpz_add(r._z, _z, other._z)
    r

  fun box sub(other: Mpz box): Mpz =>
    """
    sub operattor (mpz_sub).
    """
    let r: Mpz = Mpz
    @pony_mpz_sub(r._z, _z, other._z)
    r

  fun box mul(other: Mpz box): Mpz =>
    """
    mul operattor (mpz_mul).
    """
    let r: Mpz = Mpz
    @pony_mpz_mul(r._z, _z, other._z)
    r

  fun box div(other: Mpz box): Mpz =>
    """
    div operattor (mpz_div).
    """
    let r: Mpz = Mpz
    @pony_mpz_fdiv_q(r._z, _z, other._z)
    r

  fun box op_and(other: Mpz box): Mpz =>
    """
    and operator (mpz_and).
    """
    let r: Mpz = Mpz
    @pony_mpz_and(r._z, _z, other._z)
    r

  fun box op_or(other: Mpz box): Mpz =>
    """
    or operator (mpz_ior).
    """
    let r: Mpz = Mpz
    @pony_mpz_ior(r._z, _z, other._z)
    r

  fun box op_xor(other: Mpz box): Mpz =>
    """
    xor operator (mpz_xor).
    """
    let r: Mpz = Mpz
    @pony_mpz_xor(r._z, _z, other._z)
    r

  fun setbit(bit_index: U64): None =>
    """
    Set bit (mpz_setbit)
    """
    @pony_mpz_setbit(_z, bit_index)

  fun clrbit(bit_index: U64): None =>
    """
    Clear bit (mpz_clrbit)
    """
    @pony_mpz_clrbit(_z, bit_index)

  fun combit(bit_index: U64): None =>
    """
    Complement bit (mpz_combit)
    """
    @pony_mpz_combit(_z, bit_index)

  fun box tstbit(bit_index: U64): Bool =>
    """
    Test bit (mpz_tstbit)
    """
    if @pony_mpz_tstbit(_z, bit_index) == 0 then false else true end

  fun box eq(other: Mpz box): Bool =>
    """
    eq operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) == 0 then
      true
    else
      false
    end

  fun box ne(other: Mpz box): Bool =>
    """
    ne operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) == 0 then
      false
    else
      true
    end

  fun box lt(other: Mpz box): Bool =>
    """
    lt operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) < 0 then
      true
    else
      false
    end

  fun box le(other: Mpz box): Bool =>
    """
    le operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) <= 0 then
      true
    else
      false
    end

  fun box gt(other: Mpz box): Bool =>
    """
    gt operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) > 0 then
      true
    else
      false
    end

  fun box ge(other: Mpz box): Bool =>
    """
    ge operator (mpz_cmp).
    """
    if @pony_mpz_cmp(_z, other._z) >= 0 then
      true
    else
      false
    end
