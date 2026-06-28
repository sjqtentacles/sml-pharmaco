structure Tests =
struct
  open Harness
  fun close name (e, a, eps) = check name (Real.abs (e - a) <= eps)

  fun run () =
  let
    val () = section "half-life"
    val () = close "half-life ke=ln2" (1.0, Pharmaco.halfLife (Math.ln 2.0), 1e~12)

    val () = section "one-compartment IV"
    val ke = Math.ln 2.0
    val c = Pharmaco.oneCompartmentIV {dose=100.0, vd=10.0, ke=ke}
    val () = close "C0 at t=0" (10.0, c 0.0, 1e~9)
    val () = close "C at t=t1/2" (5.0, c (Pharmaco.halfLife ke), 1e~9)
    val () = close "C at 2*t1/2" (2.5, c (2.0 * Pharmaco.halfLife ke), 1e~9)

    val () = section "clearance"
    val () = close "CL = ke*Vd" (10.0, Pharmaco.clearance {ke=1.0, vd=10.0}, 1e~12)

    val () = section "Vd from dose and C0"
    val () = close "Vd = dose/C0" (10.0, Pharmaco.vdFromDoseC0 {dose=100.0, c0=10.0}, 1e~12)

    val () = section "steady-state accumulation"
    val tHalf = Pharmaco.halfLife ke
    val () = close "SS accum tau=t1/2 = 2" (2.0,
               Pharmaco.steadyStateAccumulation {ke=ke, tau=tHalf}, 1e~9)

    val () = section "AUC trapezoid"
    val pts = [(0.0, 5.0), (1.0, 5.0), (2.0, 5.0)]
    val () = close "AUC constant" (10.0, Pharmaco.aucTrapezoid pts, 1e~12)
    val pts2 = [(0.0, 0.0), (1.0, 1.0), (2.0, 2.0)]
    val () = close "AUC linear ramp" (2.0, Pharmaco.aucTrapezoid pts2, 1e~12)
    val () = close "AUC single pt" (0.0, Pharmaco.aucTrapezoid [(0.0, 5.0)], 1e~12)
    val () = close "AUC empty" (0.0, Pharmaco.aucTrapezoid [], 1e~12)

    val () = section "oral one-compartment"
    val c2 = Pharmaco.oneCompartmentOral {dose=100.0, vd=10.0, ka=2.0, ke=0.5, f=1.0}
    val () = close "oral C at t=0" (0.0, c2 0.0, 1e~9)
    val () = check "oral C > 0 at t=1" (c2 1.0 > 0.0)

    val () = section "two-compartment IV"
    val c3 = Pharmaco.twoCompartmentIV {a=8.0, alpha=1.5, b=2.0, beta=0.2}
    val () = close "2-comp C0" (10.0, c3 0.0, 1e~9)
    val () = check "2-comp C decreases" (c3 1.0 < c3 0.0)

  in Harness.run () end
end
