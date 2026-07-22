# sml-pharmaco

[![CI](https://github.com/sjqtentacles/sml-pharmaco/actions/workflows/ci.yml/badge.svg)](https://github.com/sjqtentacles/sml-pharmaco/actions/workflows/ci.yml)

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

## Example

`make example` builds and runs [`examples/demo.sml`](examples/demo.sml), which
runs a fixed dosing scenario through one-compartment IV bolus, one-compartment
oral (Bateman), and two-compartment IV bolus models, then prints derived
half-life, clearance, Vd, steady-state accumulation, and trapezoidal AUC
(output is byte-identical under MLton and Poly/ML):

```
-- One-compartment IV bolus (500 mg dose, Vd=50 L, t1/2=6 hr) --
  C(0.0000 hr) = 10.0000 mg/L
  C(3.0000 hr) = 7.0711 mg/L
  C(6.0000 hr) = 5.0000 mg/L
  C(12.0000 hr) = 2.5000 mg/L
  half-life from ke  = 6.0000 hr
  clearance          = 5.7762 L/hr
  Vd from dose/C0    = 50.0000 L

-- One-compartment oral, Bateman equation (500 mg, F=0.8, ka=1.5, ke=0.2) --
  C(0.5000 hr) = 3.9920 mg/L
  C(1.0000 hr) = 5.4979 mg/L
  C(2.0000 hr) = 5.7280 mg/L
  C(6.0000 hr) = 2.7791 mg/L
  C(12.0000 hr) = 0.8374 mg/L

-- Two-compartment IV bolus (A=8, alpha=1.5, B=2, beta=0.1) --
  C(0.0000 hr) = 10.0000 mg/L
  C(1.0000 hr) = 3.5947 mg/L
  C(4.0000 hr) = 1.3605 mg/L
  C(10.0000 hr) = 0.7358 mg/L

-- Steady-state accumulation (ke=0.2 /hr, tau=12 hr dosing interval) --
  R = 1.0998

-- AUC by trapezoid rule, from the IV-bolus curve above --
  AUC[0,12] = 66.2132 mg*hr/L
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
