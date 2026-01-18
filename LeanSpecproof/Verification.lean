
import Lean
import LeanSearchClient
import Std.Data.HashSet
import Mathlib

open Lean Meta Elab Command System IO

/-- Recursively collect all constants used in an expression -/
partial def collectConstants (e : Expr) : MetaM (Std.HashSet Name) := do
  let rec visit (e : Expr) (acc : Std.HashSet Name) : MetaM (Std.HashSet Name) := do
    match e with
    | .const name _ => return acc.insert name
    | .app f a =>
      let acc' ← visit f acc
      visit a acc'
    | .lam _ t b _ =>
      let acc' ← visit t acc
      visit b acc'
    | .forallE _ t b _ =>
      let acc' ← visit t acc
      visit b acc'
    | .letE _ t v b _ =>
      let acc' ← visit t acc
      let acc'' ← visit v acc'
      visit b acc''
    | .mdata _ e => visit e acc
    | .proj _ _ e => visit e acc
    | _ => return acc
  visit e {}

/-- Check if proof uses any forbidden theorem from a list -/
def usesAnyTheorem (theoremName : Name) (forbiddenList : List Name) : MetaM Bool := do
  let env ← getEnv
  let some info := env.find? theoremName
    | throwError "Theorem {theoremName} not found"
  let some value := info.value?
    | throwError "No proof value found for {theoremName}"
  let constants ← collectConstants value
  for forbidden in forbiddenList do
    if constants.contains forbidden then
      return true
  return false

/-- Check if a name matches the forbidden pattern -/
def matchesForbidden (name : Name) (forbidden : Name) : Bool :=
  -- Check exact match or contains pattern
  name == forbidden ||
  !(name.toString.splitOn forbidden.toString).tail.isEmpty

/-- Check if proof uses theorems matching the pattern -/
def usesMatchingTheorem (theoremName : Name) (forbiddenPattern : Name) : MetaM Bool := do
  let env ← getEnv
  let some info := env.find? theoremName
    | throwError "Theorem {theoremName} not found"
  let some value := info.value?
    | throwError "No proof value found for {theoremName}"
  let constants ← collectConstants value
  for const in constants do
    if matchesForbidden const forbiddenPattern then
      return true
  return false

-- Command for exact list of forbidden theorems
elab "#verify_solution " solutionName:ident " forbids " "[" forbidden:ident,* "]" : command => do
  let sol := solutionName.getId
  let forbiddenList := forbidden.getElems.toList.map (·.getId)
  logInfo m!"Not complete"
  --logInfo m!"Blocking exact theorems: {forbiddenList}"
  let uses ← liftTermElabM <| usesAnyTheorem sol forbiddenList
  if uses then
    logError m!"Solution uses a forbidden theorem"
  else
    pure ()
    --logInfo m!"✓ Solution is valid (doesn't use any forbidden theorems)!"

-- Command for pattern-based blocking
elab "#verify_solution " solutionName:ident " forbids_pattern " forbidden:ident : command => do
  let sol := solutionName.getId
  let forb := forbidden.getId
  --logInfo m!"Blocking theorems matching pattern: {forb}"
  let uses ← liftTermElabM <| usesMatchingTheorem sol forb
  if uses then
    logError m!"Solution {solutionName} uses a theorem matching pattern {forb}"
  else
    pure ()
    --logInfo m!"✓ Solution is valid (no pattern matches)!"
