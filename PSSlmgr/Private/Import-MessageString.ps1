Set-StrictMode -Version Latest
Function Import-MessageString {

<#
    .SYNOPSIS
    This function import messages strings hard-coded in the slmgr.vbs and return them as an object

#>

    [Cmdletbinding()]

    Param(
        [Parameter(Mandatory=$false)]
        [String]$Scope=1
    )

    $WindowsFolder = $(Get-ChildItem -Path env:SystemRoot).Value

    [String[]]$Variables = $(Get-Content -Path "$WindowsFolder\System32\slmgr.vbs" | Select-String -Pattern 'private const L')

    $object = New-Object -TypeName PSObject

    ForEach ( $Variable in $Variables) {

        $TrimedLine = $Variable.Replace('private const ','').Trim()

        Try {

            [String]$PropertyName = $(($TrimedLine.Split('=',[System.StringSplitOptions]::RemoveEmptyEntries))[0]).Trim()

            [String]$PropertValueRaw = $(($TrimedLine.Split('=',[System.StringSplitOptions]::RemoveEmptyEntries))[1]).Trim()

            [String]$PropertyValue = $PropertValueRaw.SubString(1,$PropertValueRaw.Length -2 )

            $object | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue -Verbose:$([bool](Write-Verbose ([String]::Empty) 4>&1))

        }
        Catch {

            [String]$MessageText = "The line $Variable can't be exported as an object property."

            Write-Error -Message $MessageText

        }

    }

    $object

}