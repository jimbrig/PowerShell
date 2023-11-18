Describe 'Testing Git Configuration Values' {
    BeforeAll {
        Function Get-GitConfigValue {
            <#
        .SYNOPSIS
            Gets a value from the global git config file.
        #>
            [CmdletBinding()]
            Param(
                [Parameter(Mandatory)]
                [String]$Key,
                [Parameter()]
                [String]$GitConfigPath = "$HOME\.gitconfig"
            )

            $Cmd = "& git config --global --get $Key"
            Invoke-Expression -Command $Cmd
        }

        $Test_Email = Get-GitConfigValue -Key 'user.email'
        $Test_DefaultMain = Get-GitConfigValue -Key 'init.defaultBranch'
        $Test_SigningKey = Get-GitConfigValue -Key 'user.signingkey'
        $Test_GPGProgram = Get-GitConfigValue -Key 'gpg.program'
        $Test_CommitSigning = Get-GitConfigValue -Key 'commit.gpgSign'
        $Test_TagSigning = Get-GitConfigValue -Key 'tag.forceSignAnnotated'
    }

    It 'Checks that user.email is set' {
        $Test_Email | Should -Not -BeNullOrEmpty
    }

    It 'Checks that init.defaultBranch is set' {
        $Test_DefaultMain | Should -Be 'main'
    }

    It 'Checks that user.signingkey is set' {
        $Test_SigningKey | Should -Not -BeNullOrEmpty
    }

    It 'Checks that gpg.program is set' {
        $Test_GPGProgram | Should -Not -BeNullOrEmpty
    }

    It 'Checks that commit.gpgSign is set' {
        $Test_CommitSigning | Should -Be 'true'
    }

    It 'Checks that tag.forceSignAnnotated is set' {
        $Test_TagSigning | Should -Be 'true'
    }
}
