Function Convert-MinutesToDay {

    <#
    .SYNOPSIS

    .DESCRIPTION

    ' VBScript only supports Int truncation or 'evens' rounding, it does not support a CEILING/FLOOR operation or MOD
    ' To simulate the CEILING operation used for other grace-day calculations in the UX we need to add the # of mins
    ' in a day minus 1 to the input then divide by the mins in a day

    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$true)]
        [Int]$Minutes
    )

    [Math]::Ceiling($Minutes/1440)

}