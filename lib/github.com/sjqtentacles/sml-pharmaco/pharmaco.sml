structure Pharmaco :> PHARMACO =
struct
  fun oneCompartmentIV {dose, vd, ke} t =
    (dose / vd) * Math.exp (~ke * t)

  fun oneCompartmentOral {dose, vd, ka, ke, f} t =
    if Real.abs (ka - ke) < 1e~10 then
      (dose * f * ka / vd) * t * Math.exp (~ke * t)
    else
      (dose * f * ka / (vd * (ka - ke))) * (Math.exp (~ke * t) - Math.exp (~ka * t))

  fun twoCompartmentIV {a, alpha, b, beta} t =
    a * Math.exp (~alpha * t) + b * Math.exp (~beta * t)

  fun halfLife ke = Math.ln 2.0 / ke

  fun clearance {ke, vd} : real = ke * vd

  fun vdFromDoseC0 {dose, c0} = dose / c0

  fun steadyStateAccumulation {ke, tau} =
    1.0 / (1.0 - Math.exp (~ke * tau))

  fun aucTrapezoid pts =
    let
      fun go [] acc = acc
        | go [_] acc = acc
        | go ((t0, c0) :: (rest as (t1, c1) :: _)) acc =
            go rest (acc + (c0 + c1) * (t1 - t0) / 2.0)
    in go pts 0.0 end
end
