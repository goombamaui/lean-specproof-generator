/-
This file is used for testing lean code.
-/

import LeanSpecproof.Verification

theorem challenge {a b c : ℕ} : a + (b + c) = (a + b) + c := by
  induction a with
  | zero =>
    sorry
  | succ a ih =>
    sorry
#check Nat.add_assoc
#verify_solution challenge forbids_pattern add_assoc
