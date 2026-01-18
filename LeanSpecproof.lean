/-
This file is used for testing lean code.
-/

import LeanSpecproof.Verification


#loogle Nat, "toList_roc_eq"
#loogle Nat, "toList_roc", "cons"
#loogle Nat, "roc", _ = _ :: _

#loogle Std.Roc, "toList", "eq"
#loogle Std.Roc, "toList", "roc"
#loogle Std.Roc, "toList"

#loogle Std.Roc, ⊢ _.toList = _
#loogle Nat, "toList_roc", "iff"
#loogle Nat, Std.Roc, "eq"
#loogle Nat, "roc", "nil"
#loogle Nat, Std.Roc, "toList"
#loogle Nat, (_<...=_).toList = _
#loogle Nat, (?a<...=?b).toList = _
#check Nat.toList_roc_eq_if
theorem challenge {m n : ℕ} : (m<...=n).toList = if m + 1 ≤ n then (m + 1) :: ((m + 1)<...=n).toList else [] := by


  #check m<...=n
  by_cases h : m + 1 ≤ n
  · simp_all

  · simp_all
