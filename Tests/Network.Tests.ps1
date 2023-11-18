Describe 'PowerShell Networking Tests' {

    BeforeAll {
        $script:NetSecurityProtocols = [enum]::GetNames([Net.SecurityProtocolType])
        $script:AvailableTls = [enum]::GetValues('Net.SecurityProtocolType') | Where-Object { $_ -ge 'Tls12' }

        $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
        if ($IsAdmin) { $script:SkipDefenderChecks = $null } else { $script:SkipDefenderChecks = $true }
    }

    AfterAll {
        $global:PSNativeCommandUseErrorActionPreference = $true
    }

    It 'Checks internet connection from a powershell shell' {
        $TestConnection = Test-Connection -ComputerName 'www.google.com' -Count 1 -Quiet
        $TestConnection | Should -Be $true
    }

    It 'Checks that TLS 1.2 is on system' {
        $NetSecurityProtocols | Should -Contain 'Tls12'
    }

    It 'Checks that TLS 1.2 is available' {
        $AvailableTls | Should -Contain 'Tls12'
    }

    It 'Checks that TLS 1.3 is available' {
        $AvailableTls | Should -Contain 'Tls13'
    }

    It 'Checks that TLS 1.1 is not available' {
        $AvailableTls | Should -Not -Contain 'Tls11'
    }

    It 'Checks that TLS 1.0 is not available' {
        $AvailableTls | Should -Not -Contain 'Tls'
    }

    It 'Checks that SSL 3.0 is not available' {
        $AvailableTls | Should -Not -Contain 'Ssl3'
    }

    It 'Checks that TLS 1.2 is default' {
        [Net.ServicePointManager]::SecurityProtocol | Should -Be 'SystemDefault'
    }

    It 'Checks EncryptionPolicy' {
        [Net.ServicePointManager]::EncryptionPolicy | Should -Be 'RequireEncryption'
    }

    It 'Checks DefaultConnectionLimit' {
        [Net.ServicePointManager]::DefaultConnectionLimit | Should -BeGreaterOrEqual 2
    }

    It 'Checks for Registry Keys for .NET Framework Version 4+ for Strong Cryptography (64bit)' {
        $splat = @{
            Path        = 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319'
            Name        = 'SchUseStrongCrypto'
            ErrorAction = 'SilentlyContinue'
        }

        $Val = Get-ItemProperty @splat
        If ($Val) {
            $Val.SchUseStrongCrypto | Should -BeExactly 1
        } Else {
            Write-Info -Message 'Registry key not found...'
        }
    }

    It 'Checks for Registry Keys for .NET Framework Version 4+ for Strong Cryptography (32bit)' {
        $splat = @{
            Path        = 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319'
            Name        = 'SchUseStrongCrypto'
            ErrorAction = 'SilentlyContinue'
        }

        $Val = Get-ItemProperty @splat
        If ($Val) {
            $Val.SchUseStrongCrypto | Should -BeExactly 1
        } Else {
            Write-Info -Message 'Registry key not found...'
        }
    }

}

Describe 'Windows Defender Checks' {

    BeforeDiscovery {
        $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
        if ($IsAdmin) { $script:SkipDefenderChecks = $null } else { $script:SkipDefenderChecks = $true }
    }

    It 'Checks Defender Exclusions Exist for PowerShell' -Skip:$SkipDefenderChecks {
        $DefenderExclusions = (Get-MpPreference).ExclusionPath
        $DefenderExclusions | Should -Contain "$Env:PROGRAMFILES\PowerShell"
        $DefenderExclusions | Should -Contain "$Env:PROGRAMFILES\PowerShell\7"
        $DefenderExclusions | Should -Contain "$Env:PROGRAMFILES\PowerShell\7-preview"
    }
}

Describe 'GitHub SSH Checks' {
    It 'Checks can connect to github via ssh' {

        $global:PSNativeCommandUseErrorActionPreference = $false
        Invoke-Command -ScriptBlock { ssh -T 'git@ssh.github.com' } -ErrorAction Ignore
        $LASTEXITCODE | Should -Be 1
        $? | Should -Be $true
        $global:PSNativeCommandUseErrorActionPreference = $true

    }
}
