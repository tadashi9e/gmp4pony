use "lib:gmp"

// FFI call declarations
use @__gmpz_init[None](mpz: MpzStruct tag)
use @__gmpz_init_set_ui[None](mpz: MpzStruct tag, i: U64)
use @__gmpz_init_set_si[None](mpz: MpzStruct tag, i: I64)
use @__gmpz_init_set_d[None](mpz: MpzStruct tag, double: F64)
use @__gmpz_init_set_str[None](mpz: MpzStruct tag,
  s: Pointer[U8] tag,  base: I32)
use @__gmpz_init_set_f[None](mpz: MpzStruct tag, f: MpfStruct tag)
use @__gmpz_clear[None](mpz: MpzStruct tag)
use @__gmpz_get_si[I64](mpz: MpzStruct tag)
use @__gmpz_get_ui[U64](mpz: MpzStruct tag)
use @__gmpz_get_d[F64](mpz: MpzStruct tag)
use @__gmpz_add[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_sub[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_mul[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_fdiv_q[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_and[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_ior[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_xor[None](r: MpzStruct tag, a: MpzStruct tag, b: MpzStruct tag)
use @__gmpz_setbit[None](mpz: MpzStruct tag, bit_index: U64)
use @__gmpz_clrbit[None](mpz: MpzStruct tag, bit_index: U64)
use @__gmpz_combit[None](mpz: MpzStruct tag, bit_index: U64)
use @__gmpz_tstbit[I32](mpz: MpzStruct tag, bit_index: U64)
use @__gmpz_cmp[I32](mpz: MpzStruct tag, other: MpzStruct tag)
use @__gmpz_sizeinbase[USize](mpz: MpzStruct tag, base: I32)
use @__gmpz_get_str[Pointer[U8]](
  buf: Pointer[U8] tag, base: I32, mpz: MpzStruct tag)

struct MpzStruct
  var _mp_alloc: I32
  var _mp_size: I32
  var _mp_d: Pointer[None]
  new create() =>
    _mp_alloc = 0
    _mp_size = 0
    _mp_d = Pointer[None]

class Mpz
  """
  mpz_t wrapper class
  """
  let _z: MpzStruct = MpzStruct

  new create() =>
    """
    Initialize to 0 (mpz_init).
    """
    @__gmpz_init(_z)

  new from_u64(u: U64) =>
    """
    Initialize and set the value from u (mpz_init_set_ui).
    """
    @__gmpz_init_set_ui(_z, u)

  new from_i64(i: I64) =>
    """
    Initialize and set the value from i (mpz_init_set_si).
    """
    @__gmpz_init_set_si(_z, i)

  new from_f64(double: F64) =>
    """
    Initialize and set the value from double (mpz_init_set_d).
    """
    @__gmpz_init_set_d(_z, double)
  new from_mpf(mpf: Mpf) =>
    """
    Initialize and set the value from mpf (mpz_init & mpz_set_f).
    """
    @__gmpz_init_set_f(_z, mpf.cpointer())
  new from_string(s: String, base: I32 = 10) =>
    """
    Initialize and set the value from s (mpz_init_set_str).
    """
    @__gmpz_init_set_str(_z, s.cstring(), base)

  fun _final() =>
    """
    Free the space occupied by mpz_t (mpz_clear).
    """
    @__gmpz_clear(_z)

  fun box cpointer(): MpzStruct tag =>
    """
    Get mpz_t pointer.
    """
    _z

  fun box i64(): I64 =>
    """
    Convert value to I64 (mpz_get_si).
    """
    @__gmpz_get_si(_z)

  fun box u64(): U64 =>
    """
    Convert value to U64 (mpz_get_ui).
    """
    @__gmpz_get_ui(_z)

  fun box f64(): F64 =>
    """
    Convert value to F64 (mpz_get_d).
    """
    @__gmpz_get_d(_z)

  fun box format(base: I32 = 10): String ref ? =>
    """
    Format value to string val (gmp_snprintf).
    """
    let bufSize: USize = @__gmpz_sizeinbase(_z, base) + 2
    let p: Pointer[U8] = @malloc(bufSize)
    if p.is_null() then
      error
    end
    @__gmpz_get_str(p, base, _z)
    let s: String ref = String.from_cpointer(p, bufSize)
    @free(p)
    s
  fun box string(base: I32 = 10): String val =>
    """
    Format value to string val (gmp_snprintf).
    """
    try
      let s: String ref = format(base)?
      let bufSize: USize = s.size()
      let copy: String iso = recover iso String(bufSize) end
      var i: ISize = 0
      try
        while i < bufSize.isize() do
          copy.push(s.at_offset(i)?)
          i = i + 1
        end
      end
      consume copy
    else
      ""
    end

  fun box neg(): Mpz =>
    """
    Convert value to negative.
    """
    let r: Mpz = Mpz
    let zero: Mpz = Mpz.from_i64(0)
    @__gmpz_sub(r._z, zero._z, _z)
    r

  fun box add(other: Mpz box): Mpz =>
    """
    add operattor (mpz_add).
    """
    let r: Mpz = Mpz
    @__gmpz_add(r._z, _z, other._z)
    r

  fun box sub(other: Mpz box): Mpz =>
    """
    sub operattor (mpz_sub).
    """
    let r: Mpz = Mpz
    @__gmpz_sub(r._z, _z, other._z)
    r

  fun box mul(other: Mpz box): Mpz =>
    """
    mul operattor (mpz_mul).
    """
    let r: Mpz = Mpz
    @__gmpz_mul(r._z, _z, other._z)
    r

  fun box div(other: Mpz box): Mpz =>
    """
    div operattor (mpz_div).
    """
    let r: Mpz = Mpz
    @__gmpz_fdiv_q(r._z, _z, other._z)
    r

  fun box op_and(other: Mpz box): Mpz =>
    """
    and operator (mpz_and).
    """
    let r: Mpz = Mpz
    @__gmpz_and(r._z, _z, other._z)
    r

  fun box op_or(other: Mpz box): Mpz =>
    """
    or operator (mpz_ior).
    """
    let r: Mpz = Mpz
    @__gmpz_ior(r._z, _z, other._z)
    r

  fun box op_xor(other: Mpz box): Mpz =>
    """
    xor operator (mpz_xor).
    """
    let r: Mpz = Mpz
    @__gmpz_xor(r._z, _z, other._z)
    r

  fun setbit(bit_index: U64): None =>
    """
    Set bit (mpz_setbit)
    """
    @__gmpz_setbit(_z, bit_index)

  fun clrbit(bit_index: U64): None =>
    """
    Clear bit (mpz_clrbit)
    """
    @__gmpz_clrbit(_z, bit_index)

  fun combit(bit_index: U64): None =>
    """
    Complement bit (mpz_combit)
    """
    @__gmpz_combit(_z, bit_index)

  fun box tstbit(bit_index: U64): Bool =>
    """
    Test bit (mpz_tstbit)
    """
    if @__gmpz_tstbit(_z, bit_index) == 0 then false else true end

  fun box eq(other: Mpz box): Bool =>
    """
    eq operator (mpz_cmp).
    """
    if @__gmpz_cmp(_z, other._z) == 0 then
      true
    else
      false
    end

  fun box ne(other: Mpz box): Bool =>
    """
    ne operator (mpz_cmp).
    """
    if @__gmpz_cmp(_z, other._z) == 0 then
      false
    else
      true
    end

  fun lt(other: Mpz box): Bool =>
    """
    lt operator (mpz_cmp).
    """
    if @__gmpz_cmp(_z, other._z) < 0 then
      true
    else
      false
    end

  fun box le(other: Mpz box): Bool =>
    """
    le operator (mpz_cmp).
    """
    if @__gmpz_cmp(_z, other._z) <= 0 then
      true
    else
      false
    end

  fun box gt(other: Mpz box): Bool =>
    """
    gt operator (mpz_cmp).
    """
    if @__gmpz_cmp(_z, other._z) > 0 then
      true
    else
      false
    end

  fun box ge(other: Mpz box): Bool =>
    """
    ge operator (mpz_cmp).
    """
    if @__gmpz_cmp(_z, other._z) >= 0 then
      true
    else
      false
    end
