# sml-pharmaco

Zero-dependency Standard ML library for pharmacokinetic calculations.

## API

```sml
signature PHARMACO =
sig
  val oneCompartmentIV   : {dose:real, vd:real, ke:real} -> real -> real
  val oneCompartmentOral : {dose:real, vd:real, ka:real, ke:real, f:real} -> real -> real
  val twoCompartmentIV   : {a:real, alpha:real, b:real, beta:real} -> real -> real

  val halfLife               : real -> real              (* ke -> t½ *)
  val clearance              : {ke:real, vd:real} -> real
  val vdFromDoseC0           : {dose:real, c0:real} -> real
  val steadyStateAccumulation : {ke:real, tau:real} -> real

  val aucTrapezoid : (real * real) list -> real
end
```

## Worked example

```sml
(* One-compartment IV bolus: 100 mg dose, Vd=10 L, ke=ln(2)/1hr *)
val c = Pharmaco.oneCompartmentIV {dose=100.0, vd=10.0, ke=Math.ln 2.0}
val c0   = c 0.0   (* 10 mg/L at time 0 *)
val half = c 1.0   (*  5 mg/L at 1 hr (one half-life) *)

(* AUC by trapezoid *)
val pts = [(0.0, 10.0), (1.0, 5.0), (2.0, 2.5), (3.0, 1.25)]
val auc = Pharmaco.aucTrapezoid pts
```

## Scope and limitations

- Covers 1- and 2-compartment IV bolus, 1-compartment oral (Bateman), half-life, clearance, Vd, steady-state accumulation, and AUC by trapezoid rule.
- All models assume linear (first-order) pharmacokinetics.
- Units: dose in mg, volumes in L, rates in 1/hr, concentrations in mg/L, time in hr.
- Does not model non-linear kinetics, protein binding, or tissue distribution.

## Build and test

Requires [MLton](http://mlton.org/) and Poly/ML in PATH.

```
make all-tests
```
