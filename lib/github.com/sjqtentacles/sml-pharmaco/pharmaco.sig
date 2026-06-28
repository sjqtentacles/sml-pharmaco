signature PHARMACO =
sig
  (* One-compartment IV bolus: C(t) = (dose/Vd) * exp(-ke*t)
     dose: mg, Vd: L, ke: 1/hr, t: hr -> mg/L *)
  val oneCompartmentIV : {dose:real, vd:real, ke:real} -> real -> real

  (* One-compartment oral (Bateman equation):
     C(t) = dose*F*ka/Vd/(ka-ke) * (exp(-ke*t) - exp(-ka*t))
     f=bioavailability, ka=absorption rate constant (1/hr) *)
  val oneCompartmentOral : {dose:real, vd:real, ka:real, ke:real, f:real} -> real -> real

  (* Two-compartment IV bolus: C(t) = A*exp(-alpha*t) + B*exp(-beta*t) *)
  val twoCompartmentIV : {a:real, alpha:real, b:real, beta:real} -> real -> real

  (* Half-life from elimination rate constant (hr) *)
  val halfLife : real -> real   (* ke -> t_{1/2} *)

  (* Clearance (L/hr) = ke * Vd *)
  val clearance : {ke:real, vd:real} -> real

  (* Volume of distribution from dose and initial concentration *)
  val vdFromDoseC0 : {dose:real, c0:real} -> real

  (* Steady-state accumulation ratio: 1/(1 - exp(-ke*tau))
     tau=dosing interval (hr) *)
  val steadyStateAccumulation : {ke:real, tau:real} -> real

  (* AUC by trapezoid rule from list of (time, concentration) pairs *)
  val aucTrapezoid : (real * real) list -> real
end
