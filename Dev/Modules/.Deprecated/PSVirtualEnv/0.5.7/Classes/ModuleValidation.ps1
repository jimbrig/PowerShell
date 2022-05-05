# ===========================================================================
#   ModuleValidation.ps1 ----------------------------------------------------
# ===========================================================================

#   import ------------------------------------------------------------------
# ---------------------------------------------------------------------------
using namespace System.Management.Automation

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnv : IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvDirectories)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateRequirements: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvRequirement)
    }
}

#   validation --------------------------------------------------------------
# ---------------------------------------------------------------------------
Class ValidateVirtualEnvLocal: IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        return [String[]] (ValidateVirtualEnvLocalDirectories)
    }
}
