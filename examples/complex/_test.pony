use "../../gmp"

actor Main
  new create(env: Env) =>
    var i: Mpf val = Mpf.from_i64(123)
    env.out.print(i.string())
    let c1: Complex = Complex(Mpf.from_i64(123), Mpf.from_i64(456))
    env.out.print("   " + c1.string())
    let c2: Complex = Complex(Mpf, Mpf.from_i64(-1))
    env.out.print(" * " + c2.string())
    env.out.print(" = " + (c1 * c2).string())
