Set-StrictMode -Version Latest
Function Convert-MinutesToDay {
<#
    .SYNOPSIS
    Convert amount of minutes to days - in Microsoft way, means rounding up.
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [AllowNull()]
        [Decimal]$Minutes
    )

    if ( $Minutes -gt 0 ) {
        [Math]::Ceiling($Minutes/1440)
    }

}