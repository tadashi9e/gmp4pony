use "lib:gmp"

// FFI call declarations
use @malloc[Pointer[U8] ref](size: USize)
use @free[None](p: Pointer[None])
use @__gmpf_set_default_prec[None](prec: U64)
use @__gmpf_get_default_prec[U64]()
use @__gmpf_init[None](mpf: MpfStruct)
use @__gmpf_init_set_ui[None](mpf: MpfStruct, i: U64)
use @__gmpf_init_set_si[None](mpf: MpfStruct, i: I64)
use @__gmpf_set_d[None](mpf: MpfStruct, double: F64)
use @__gmpf_set_z[None](mpf: MpfStruct, mpz: MpzStruct tag)
use @__gmpf_init_set_str[None](mpf: MpfStruct, s: Pointer[U8] tag,  base: I32)
use @__gmpf_set[None](mpf: MpfStruct tag, orig: MpfStruct tag)
use @__gmpf_clear[None](mpf: MpfStruct tag)
use @__gmpf_get_si[I64](mpf: MpfStruct tag)
use @__gmpf_get_ui[U64](mpf: MpfStruct tag)
use @__gmpf_get_d[F64](mpf: MpfStruct tag)
use @__gmpf_abs[None](r: MpfStruct tag, mpf: MpfStruct tag)
use @__gmpf_add[None](r: MpfStruct tag, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_sub[None](r: MpfStruct tag, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_mul[None](r: MpfStruct tag, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_div[None](r: MpfStruct tag, a: MpfStruct tag, b: MpfStruct tag)
use @__gmpf_sqrt[None](r: MpfStruct tag, mpf: MpfStruct tag)
use @__gmpf_cmp[I32](f: MpfStruct tag, other: MpfStruct tag)
use @__gmp_snprintf[I32](
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
    """
    Set the default precision to be at least prec bits
    (mpf_set_default_prec).
    """
    @__gmpf_set_default_prec(prec)

  fun get_default_prec(): U64 =>
    """
    Return the default precision actually used
    (mpf_get_default_prec).
    """
    @__gmpf_get_default_prec()

  new iso create() =>
    """
    Initialize to 0 (mpf_init).
    """
    @__gmpf_init(_f)

  new iso from_u64(u: U64 val) =>
    """
    Initialize and set the value from u (mpf_init_set_ui).
    """
    @__gmpf_init_set_ui(_f, u)

  new iso from_i64(i: I64 val) =>
    """
    Initialize and set the value from i (mpf_init_set_si).
    """
    @__gmpf_init_set_si(_f, i)

  new iso from_f64(double: F64 val) =>
    """
    Initialize and set the value from double (mpf_init_set_d).
    """
    @__gmpf_init(_f)
    @__gmpf_set_d(_f, double)

  new iso from_mpz(mpz: Mpz val) =>
    """
    Initialize and set the value from mpz (mpf_init & mpf_set_z).
    """
    @__gmpf_init(_f)
    @__gmpf_set_z(_f, mpz.cpointer())

  new iso from(mpf: Mpf val) =>
    """
    Initialize and set the value from mpf (mpf_init & mpf_set).
    """
    @__gmpf_init(_f)
    @__gmpf_set(_f, mpf.cpointer())

  new iso from_string(s: String, base: I32 = 10) =>
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

  fun box copy_iso(other: Mpf iso): Mpf iso^ =>
    """
    Copy valuie to Mpf iso and return it.
    """
    @__gmpf_set(other._f, _f)
    consume other

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

  fun box format(pattern: String = "%Ff",
      base: I32 = 10): String ref^ ? =>
    """
    Format value to string ref (gmp_snprintf).
    """
    var sz: I32 = @__gmp_snprintf(Pointer[U8], 0, pattern.cstring(), _f)
    if sz < 0 then
      error
    end
    let p: Pointer[U8] = @malloc(sz.usize() + 1)
    if p.is_null() then
      error
    end
    let i: I32 = @__gmp_snprintf(p, sz.usize() + 1, pattern.cstring(), _f)
    if i < 0 then
      error
    end
    let s: String ref = String.copy_cpointer(p, sz.usize())
    @free(p)
    s

  fun box string(pattern: String = "%Ff",
      base: I32 = 10): String val =>
    """
    Format value to string val (gmp_snprintf).
    """
    try
      let s: String ref = format(
        where pattern = pattern, base = base)?
      let slen: USize = s.size()
      let copy: String iso = recover iso String(slen) end
      var i: USize = 0
      try
        while i < slen do
          let c: U8 = s.at_offset(i.isize())?
          copy.push(c)
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
    var r: Mpf iso = recover iso Mpf end
    r = copy_iso(consume r)
    @__gmpf_abs(r._f, _f)
    consume r

  fun box neg(): Mpf val =>
    """
    Convert value to negative.
    """
    var r: Mpf iso = recover iso Mpf end
    r = copy_iso(consume r)
    let zero: Mpf val = Mpf.from_i64(0)
    @__gmpf_sub(r._f, zero._f, _f)
    consume r

  fun box add(other: Mpf val): Mpf val =>
    """
    add operattor (mpf_add).
    """
    var r: Mpf iso = recover iso Mpf end
    @__gmpf_add(r._f, _f, other._f)
    consume r

  fun box sub(other: Mpf val): Mpf val =>
    """
    sub operattor (mpf_sub).
    """
    var r: Mpf iso = recover iso Mpf end
    @__gmpf_sub(r._f, _f, other._f)
    consume r

  fun box mul(other: Mpf val): Mpf val =>
    """
    mul operattor (mpf_mul).
    """
    var r: Mpf iso = recover iso Mpf end
    @__gmpf_mul(r._f, _f, other._f)
    consume r

  fun box div(other: Mpf val): Mpf val =>
    """
    div operattor (mpf_div).
    """
    var r: Mpf iso = recover iso Mpf end
    @__gmpf_div(r._f, _f, other._f)
    consume r

  fun box sqrt(): Mpf val =>
    """
    Returns square root of value (mpf_sqrt).
    """
    var r: Mpf iso = recover iso Mpf end
    @__gmpf_sqrt(r._f, _f)
    consume r

  fun box eq(other: Mpf val): Bool =>
    """
    eq operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) == 0 then
      true
    else
      false
    end

  fun box ne(other: Mpf val): Bool =>
    """
    ne operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) == 0 then
      false
    else
      true
    end

  fun box lt(other: Mpf val): Bool =>
    """
    lt operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) < 0 then
      true
    else
      false
    end

  fun box le(other: Mpf val): Bool =>
    """
    le operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) <= 0 then
      true
    else
      false
    end

  fun box gt(other: Mpf val): Bool =>
    """
    gt operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) > 0 then
      true
    else
      false
    end

  fun box ge(other: Mpf val): Bool =>
    """
    Ge operator (mpf_cmp).
    """
    if @__gmpf_cmp(_f, other._f) >= 0 then
      true
    else
      false
    end
