use "lib:gmp"

// FFI call declarations
use @malloc[Pointer[U8] ref](size: USize)
use @free[None](p: Pointer[None])
use @__gmpf_set_default_prec[None](prec: U64)
use @__gmpf_get_default_prec[U64]()
use @__gmpf_init[None](mpf: MpfStruct)
use @__gmpf_init_set_ui[None](mpf: MpfStruct, i: U64)
use @__gmpf_init_set_si[None](mpf: MpfStruct, i: I64)
use @__gmpf_init_set_d[None](mpf: MpfStruct, double: F64)
use @__gmpf_init_set_z[None](mpf: MpfStruct, mpz: MpzStruct tag)
use @__gmpf_init_set_str[None](mpf: MpfStruct, s: Pointer[U8] tag,  base: I32)
use @__gmpf_set[None](mpf: MpfStruct, orig: MpfStruct tag)
use @__gmpf_clear[None](mpf: MpfStruct tag)
use @__gmpf_get_si[I64](mpf: MpfStruct tag)
use @__gmpf_get_ui[U64](mpf: MpfStruct tag)
use @__gmpf_get_d[F64](mpf: MpfStruct tag)
use @__gmpf_abs[None](r: MpfStruct, mpf: MpfStruct tag)
use @__gmpf_add[None](r: MpfStruct, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_sub[None](r: MpfStruct, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_mul[None](r: MpfStruct, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_div[None](r: MpfStruct, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_sqrt[None](r: MpfStruct, mpf: MpfStruct tag)
use @__gmpf_cmp[I32](f: MpfStruct tag, other: MpfStruct tag)
use @__gmp_snprintf[ISize](
  buf: Pointer[U8] tag, size: USize,
  format: Pointer[U8] tag, arg: MpfStruct box)

struct MpfStruct
  var _mp_prec: I32
  var _mp_size: I32
  var _mp_exp: I64
  var _mp_d: Pointer[None]
  new create() =>
    _mp_prec = 0
    _mp_size = 0
    _mp_exp = 0
    _mp_d = Pointer[None]

class Mpf
  """
  mpf_t wrapper class
  """
  let _f: MpfStruct = MpfStruct

  fun set_default_prec(prec: U64): None =>
    @__gmpf_set_default_prec(prec)

  fun get_default_prec(): U64 =>
    @__gmpf_get_default_prec()

  new create() =>
    """
    Initialize to 0 (mpf_init).
    """
    @__gmpf_init(_f)

  new from_u64(u: U64) =>
    """
    Initialize and set the value from u (mpf_init_set_ui).
    """
    @__gmpf_init_set_ui(_f, u)

  new from_i64(i: I64) =>
    """
    Initialize and set the value from i (mpf_init_set_si).
    """
    @__gmpf_init_set_si(_f, i)

  new from_f64(double: F64) =>
    """
    Initialize and set the value from double (mpf_init_set_d).
    """
    @__gmpf_init_set_d(_f, double)

  new from_mpz(mpz: Mpz) =>
    """
    Initialize and set the value from mpz (mpf_init & mpf_set_z).
    """
    @__gmpf_init_set_z(_f, mpz.cpointer())

  new from(mpf: Mpf) =>
    """
    Initialize and set the value from mpf (mpf_init & mpf_set).
    """
    @__gmpf_init(_f)
    @__gmpf_set(_f, mpf.cpointer())

  new from_string(s: String, base: I32 = 10) =>
    """
    Initialize and set the value from s (mpf_init_set_str).
    """
    @__gmpf_init_set_str(_f, s.cstring(), base)

  fun _final() =>
    """
    Free the space occupied by mpf_t (mpf_clear).
    """
    @__gmpf_clear(_f)

  fun box cpointer(): MpfStruct tag =>
    """
    Get mpf_t pointer.
    """
    _f

  fun box i64(): I64 =>
    """
    Convert value to I64 (mpf_get_si).
    """
    @__gmpf_get_si(_f)

  fun box u64(): U64 =>
    """
    Convert value to U64 (mpf_get_ui).
    """
    @__gmpf_get_ui(_f)

  fun box f64(): F64 =>
    """
    Convert value to F64 (mpf_get_d).
    """
    @__gmpf_get_d(_f)

  fun box format(bufSize: USize = 100, pattern: String = "%Ff",
      base: I32 = 10): String ref ? =>
    """
    Format value to string ref (gmp_snprintf).
    """
    let p: Pointer[U8] = @malloc(bufSize)
    if p.is_null() then
      error
    end
    @__gmp_snprintf(p, bufSize, pattern.cstring(), _f)
    let s: String ref = String.from_cpointer(p, bufSize)
    @free(p)
    s

  fun box string(bufSize: USize = 100, pattern: String = "%Ff",
    base: I32 = 10): String val =>
    """
    Format value to string val (gmp_snprintf).
    """
    try
      let s: String ref = format(
        where bufSize = bufSize, pattern = pattern, base = base)?
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

  fun box abs(): Mpf =>
    """
    Convert value to absolute.
    """
    let r: Mpf = Mpf
    @__gmpf_abs(r._f, _f)
    r

  fun box neg(): Mpf =>
    """
    Convert value to negative.
    """
    let r: Mpf = Mpf
    let zero: Mpf = Mpf.from_i64(0)
    @__gmpf_sub(r._f, zero._f, _f)
    r

  fun box add(other: Mpf box): Mpf =>
    """
    add operattor (mpf_add).
    """
    let r: Mpf = Mpf
    @__gmpf_add(r._f, _f, other._f)
    r

  fun box sub(other: Mpf box): Mpf =>
    """
    sub operattor (mpf_sub).
    """
    let r: Mpf = Mpf
    @__gmpf_sub(r._f, _f, other._f)
    r

  fun box mul(other: Mpf box): Mpf =>
    """
    mul operattor (mpf_mul).
    """
    let r: Mpf = Mpf
    @__gmpf_mul(r._f, _f, other._f)
    r

  fun box div(other: Mpf box): Mpf =>
    """
    div operattor (mpf_div).
    """
    let r: Mpf = Mpf
    @__gmpf_div(r._f, _f, other._f)
    r

  fun box sqrt(): Mpf =>
    """
    Returns square root of value (mpf_sqrt).
    """
    let r: Mpf = Mpf
    @__gmpf_sqrt(r._f, _f)
    r

  fun box eq(other: Mpf box): Bool =>
    """
    eq operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) == 0 then
      true
    else
      false
    end

  fun box ne(other: Mpf box): Bool =>
    """
    ne operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) == 0 then
      false
    else
      true
    end

  fun box lt(other: Mpf box): Bool =>
    """
    lt operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) < 0 then
      true
    else
      false
    end

  fun box le(other: Mpf): Bool =>
    """
    le operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) <= 0 then
      true
    else
      false
    end

  fun box gt(other: Mpf box): Bool =>
    """
    gt operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) > 0 then
      true
    else
      false
    end

  fun box ge(other: Mpf box): Bool =>
    """
    Ge operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) >= 0 then
      true
    else
      false
    end
