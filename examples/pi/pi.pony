use "../../gmp"

actor Main
  new create(env: Env) =>
    env.out.print(Mpf.get_default_prec().string())
    Mpf.set_default_prec(65536)
    let pi: Mpf = calc_pi(where loop = 10000)
    dump_pi(env, pi where bufSize=10000, pattern="%.10000Ff")

  fun calc_pi(loop: I32 = 100): Mpf =>
    """
    Gauss–Legendre algorithm
    """
    let f0: Mpf = Mpf
    let f1: Mpf = Mpf.from_i64(1)
    let f2: Mpf = Mpf.from_i64(2)
    let f4: Mpf = Mpf.from_i64(4)
    var a: Mpf = f1
    var ba: Mpf = f0
    var b: Mpf = f1 / f2.sqrt()
    var t: Mpf = f1 / f4
    var p: Mpf = f1
    var k: I32 = 0
    while k < loop do
      ba = a
      a = (ba + b) / f2
      b = (ba * b).sqrt()
      t = t - ((p * (ba - a)) * (ba - a))
      p = f2 * p
      k = k + 1
    end
    ((a + b) * (a + b)) / (t * Mpf.from_i64(4))

  fun dump_pi(env: Env, pi: Mpf,
              bufSize: USize = 1000, pattern: String = "%.1000Ff"): None =>
    let s = pi.string(where bufSize=bufSize, pattern=pattern)
    env.out.print(s.substring(0, 2))
    var offset: ISize = 2
    var line: String iso = recover iso String end
    while offset < s.size().isize() do
      if line.size() > 0 then
        line.append(" ")
      end
      line.append(s.substring(offset, offset + 10))
      if line.size() > 100 then
        env.out.print(consume line)
        line = recover iso String end
      end
      offset = offset + 10
    end
    env.out.print(consume line)
