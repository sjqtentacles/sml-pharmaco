(* demo.sml - a deterministic pharmacokinetic dosing scenario: one- and
   two-compartment IV bolus, one-compartment oral (Bateman), and derived
   PK parameters, over fixed literal dose/clearance/volume inputs. Real
   output is fixed-point formatted so it is byte-identical under MLton
   and Poly/ML. *)

structure P = Pharmaco

fun fmt x =
  let val x' = if Real.== (x, 0.0) then 0.0 else x
  in Real.fmt (StringCvt.FIX (SOME 4)) x' end

val () = print "-- One-compartment IV bolus (500 mg dose, Vd=50 L, t1/2=6 hr) --\n"
val ke1 = Math.ln 2.0 / 6.0
val ivConc = P.oneCompartmentIV { dose = 500.0, vd = 50.0, ke = ke1 }
val () =
  List.app
    (fn t => print ("  C(" ^ fmt t ^ " hr) = " ^ fmt (ivConc t) ^ " mg/L\n"))
    [0.0, 3.0, 6.0, 12.0]
val () = print ("  half-life from ke  = " ^ fmt (P.halfLife ke1) ^ " hr\n")
val () = print ("  clearance          = " ^ fmt (P.clearance { ke = ke1, vd = 50.0 }) ^ " L/hr\n")
val () = print ("  Vd from dose/C0    = " ^ fmt (P.vdFromDoseC0 { dose = 500.0, c0 = ivConc 0.0 }) ^ " L\n")

val () = print "\n-- One-compartment oral, Bateman equation (500 mg, F=0.8, ka=1.5, ke=0.2) --\n"
val oralConc = P.oneCompartmentOral { dose = 500.0, vd = 50.0, ka = 1.5, ke = 0.2, f = 0.8 }
val () =
  List.app
    (fn t => print ("  C(" ^ fmt t ^ " hr) = " ^ fmt (oralConc t) ^ " mg/L\n"))
    [0.5, 1.0, 2.0, 6.0, 12.0]

val () = print "\n-- Two-compartment IV bolus (A=8, alpha=1.5, B=2, beta=0.1) --\n"
val twoConc = P.twoCompartmentIV { a = 8.0, alpha = 1.5, b = 2.0, beta = 0.1 }
val () =
  List.app
    (fn t => print ("  C(" ^ fmt t ^ " hr) = " ^ fmt (twoConc t) ^ " mg/L\n"))
    [0.0, 1.0, 4.0, 10.0]

val () = print "\n-- Steady-state accumulation (ke=0.2 /hr, tau=12 hr dosing interval) --\n"
val () = print ("  R = " ^ fmt (P.steadyStateAccumulation { ke = 0.2, tau = 12.0 }) ^ "\n")

val () = print "\n-- AUC by trapezoid rule, from the IV-bolus curve above --\n"
val pts = List.map (fn t => (t, ivConc t)) [0.0, 3.0, 6.0, 12.0]
val () = print ("  AUC[0,12] = " ^ fmt (P.aucTrapezoid pts) ^ " mg*hr/L\n")
