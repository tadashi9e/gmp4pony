use "../../gmp"

actor Main
  new create(env: Env) =>
    env.out.print(Mpf.get_default_prec().string())
    Mpf.set_default_prec(65536)
    let s = pi(where loop = 10000)
      .string(where bufSize=1100, pattern="%.1100Ff")
    env.out.print(s.substring(0, 2))
    var offset: ISize = 2
    var line: String iso = recover iso String end
    while offset < s.size().isize() do
      if line.size() > 0 then
        line.append(" ")
      end
      line.append(s.substring(offset, offset + 10))
      if line.size() > 80 then
        env.out.print(consume line)
        line = recover iso String end
      end
      offset = offset + 10
    end
    env.out.print(consume line)

  fun pi(loop: I32 = 100): Mpf =>
    let one: Mpf = Mpf.from_i64(1)
    let two: Mpf = Mpf.from_i64(2)
    var a: Mpf = one
    var ba: Mpf = Mpf.from_i64(0)
    var b: Mpf = one / two.sqrt()
    var t: Mpf = one / Mpf.from_i64(4)
    var p: Mpf = one
    var k: I32 = 0
    while k < loop do
      ba = a
      a = (ba + b) / Mpf.from_i64(2)
      b = (ba * b).sqrt()
      t = t - ((p * (ba - a)) * (ba - a))
      p = two * p
      k = k + 1
    end
    ((a + b) * (a + b)) / (t * Mpf.from_i64(4))
