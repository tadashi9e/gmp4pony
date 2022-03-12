use "ponytest"
use "path:.."
use "lib:gmp"

actor \nodoc\ Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestMpzInit)
    test(_TestMpfInit)
    test(_TestMpzString)
    test(_TestMpfString)
    test(_TestMpzAdd)
    test(_TestMpfAdd)
    test(_TestMpzSub)
    test(_TestMpfSub)
    test(_TestMpzMul)
    test(_TestMpfMul)
    test(_TestMpzDiv)
    test(_TestMpfDiv)
    test(_TestMpfSqrt)
    test(_TestMpfSetbit)
    test(_TestMpfClrbit)

class \nodoc\ iso _TestMpzInit is UnitTest
  fun name(): String => "mpz/init"

  fun apply(h: TestHelper) =>
    let z: Mpz val = Mpz
    h.assert_eq[I64](z.i64(), 0)
    let z1: Mpz val = Mpz.from_i64(-12345)
    h.assert_eq[I64](z1.i64(), -12345)
    let z2: Mpz val = Mpz.from_u64(12345)
    h.assert_eq[U64](z1.u64(), 12345)
    let z3: Mpz val = Mpz.from_string("12345")
    h.assert_eq[U64](z1.u64(), 12345)

class \nodoc\ iso _TestMpfInit is UnitTest
  fun name(): String => "mpf/init"

  fun apply(h: TestHelper) =>
    let f: Mpf val = Mpf
    h.assert_eq[I64](f.i64(), 0)
    let f1: Mpf val = Mpf.from_i64(-12345)
    h.assert_eq[I64](f1.i64(), -12345)
    let f2: Mpf val = Mpf.from_u64(12345)
    h.assert_eq[U64](f1.u64(), 12345)
    let f3: Mpf val = Mpf.from_string("12345")
    h.assert_eq[U64](f1.u64(), 12345)

class \nodoc\ iso _TestMpzString is UnitTest
  fun name(): String => "mpz/string"

  fun apply(h: TestHelper) ? =>
    let z: Mpz val = Mpz
    h.assert_eq[I32](z.string().i32()?, 0)
    let z1: Mpz val = Mpz.from_i64(-12345)
    h.assert_eq[I32](z1.string().i32()?, -12345)
    let z2: Mpz val = Mpz.from_i64(12345)
    h.assert_eq[I32](z2.string().i32()?, 12345)

class \nodoc\ iso _TestMpfString is UnitTest
  fun name(): String => "mpf/string"

  fun apply(h: TestHelper) ? =>
    let f: Mpf val = Mpf
    h.assert_eq[F32](f.string().f32()?, 0)
    let f1: Mpf val = Mpf.from_i64(-12345)
    h.assert_eq[F32](f1.string().f32()?, -12345)
    let f2: Mpf val = Mpf.from_i64(12345)
    h.assert_eq[F32](f2.string().f32()?, 12345)

class \nodoc\ iso _TestMpzAdd is UnitTest
  fun name(): String => "mpz/add"

  fun apply(h: TestHelper) =>
    let z1: Mpz val = Mpz.from_i64(-12345)
    let z2: Mpz val = Mpz.from_u64(12345)
    h.assert_eq[I64]((z1 + z2).i64(), 0)

class \nodoc\ iso _TestMpfAdd is UnitTest
  fun name(): String => "mpf/add"

  fun apply(h: TestHelper) =>
    let f1: Mpf val = Mpf.from_i64(-12345)
    let f2: Mpf val = Mpf.from_u64(12345)
    h.assert_eq[I64]((f1 + f2).i64(), 0)

class \nodoc\ iso _TestMpzSub is UnitTest
  fun name(): String => "mpz/sub"

  fun apply(h: TestHelper) =>
    let z1: Mpz val = Mpz.from_i64(-12345)
    h.assert_eq[I64]((z1 - z1).i64(), 0)
    let z2: Mpz val = Mpz.from_u64(12345)
    h.assert_eq[I64]((z2 - z1).i64(), 12345 * 2)

class \nodoc\ iso _TestMpfSub is UnitTest
  fun name(): String => "mpf/sub"

  fun apply(h: TestHelper) =>
    let f1: Mpf val = Mpf.from_i64(-12345)
    h.assert_eq[I64]((f1 - f1).i64(), 0)
    let f2: Mpf val = Mpf.from_u64(12345)
    h.assert_eq[I64]((f2 - f1).i64(), 12345 * 2)

class \nodoc\ iso _TestMpzMul is UnitTest
  fun name(): String => "mpz/mul"

  fun apply(h: TestHelper) =>
    let z1: Mpz val = Mpz.from_i64(-12345)
    h.assert_eq[I64]((z1 * z1).i64(), 12345 * 12345)
    let z2: Mpz val = Mpz.from_u64(12345)
    h.assert_eq[I64]((z2 * z1).i64(), -12345 * 12345)

class \nodoc\ iso _TestMpfMul is UnitTest
  fun name(): String => "mpf/mul"

  fun apply(h: TestHelper) =>
    let f1: Mpf val = Mpf.from_i64(-12345)
    h.assert_eq[I64]((f1 * f1).i64(), 12345 * 12345)
    let f2: Mpf val = Mpf.from_u64(12345)
    h.assert_eq[I64]((f2 * f1).i64(), -12345 * 12345)

class \nodoc\ iso _TestMpzDiv is UnitTest
  fun name(): String => "mpz/div"

  fun apply(h: TestHelper) =>
    let z1: Mpz val = Mpz.from_i64(-12345)
    h.assert_eq[I64]((z1 / z1).i64(), 1)
    let z2: Mpz val = Mpz.from_u64(12345)
    h.assert_eq[I64]((z2 / z1).i64(), -1)

class \nodoc\ iso _TestMpfDiv is UnitTest
  fun name(): String => "mpf/div"

  fun apply(h: TestHelper) =>
    let f1: Mpf val = Mpf.from_i64(-12345)
    h.assert_eq[I64]((f1 / f1).i64(), 1)
    let f2: Mpf val = Mpf.from_u64(12345)
    h.assert_eq[I64]((f2 / f1).i64(), -1)

class \nodoc\ iso _TestMpfSqrt is UnitTest
  fun name(): String => "mpf/sqrt"

  fun apply(h: TestHelper) =>
    let f1: Mpf val = Mpf.from_i64(12345)
    h.assert_eq[I64]((f1 * f1).sqrt().i64(), 12345)

class \nodoc\ iso _TestMpfSetbit is UnitTest
  fun name(): String => "mpf/setbit"

  fun apply(h: TestHelper) =>
    var z: Mpz val = Mpz.from_i64(0)
    var mask: U64 = 1
    var i: U64 = 0
    while i < 512 do
      h.assert_eq[Bool](z.tstbit(i), false)
      z = z.setbit(i)
      h.assert_eq[Bool](z.tstbit(i), true)
      mask = mask * 2
      h.assert_eq[U64](z.u64(), mask - 1)
      i = i + 1
    end

class \nodoc\ iso _TestMpfClrbit is UnitTest
  fun name(): String => "mpf/clrbit"

  fun apply(h: TestHelper) =>
    var z: Mpz val = Mpz.from_i64(0)
    var mask: U64 = 1
    var i: U64 = 0
    while i < 512 do
      z = z.setbit(i)
      i = i + 1
    end
    i = 0
    while i < 512 do
      h.assert_eq[Bool](z.tstbit(i), true)
      z = z.clrbit(i)
      h.assert_eq[Bool](z.tstbit(i), false)
      i = i + 1
    end
