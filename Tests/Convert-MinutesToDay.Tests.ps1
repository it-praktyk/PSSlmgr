Set-StrictMode -Version Latest

[String]$ModuleName = 'PSSlmgr'

$VerboseInternal = $false

#Provided path asume that your module manifest (a file with the psd1 extension) exists in the parent directory for directory where the current test script is stored
$RelativePathToModuleManifest = "{0}\..\{1}\{1}.psd1" -f $PSScriptRoot, $ModuleName

#Remove module if it's currently loaded
Get-Module -Name $ModuleName -ErrorAction SilentlyContinue -Verbose:$VerboseInternal | Remove-Module -Verbose:$VerboseInternal

Import-Module -FullyQualifiedName $RelativePathToModuleManifest -Force -Scope Global -Verbose:$VerboseInternal

InModuleScope -ModuleName $ModuleName {

    $FunctionName = "Convert-MinutesToDay"

    Describe "Tests for $FunctionName" {

        $cases = @{ minutes = 1; result = 1},@{ minutes = 1440; result = 1},@{ minutes = 1441; result = 2},@{ minutes = -1; result = $null},@{ minutes = $null; result = $null}

        it "<minutes> minute(s) converted to <result> day(s)" -TestCases $cases -Test {

            param ( $minutes, $result )

            Convert-MinutesToDay -Minutes $minutes | should -Be $result
        }

    }

}