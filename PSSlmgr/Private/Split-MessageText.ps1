Function Split-MessageText {

    [Cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$MessageText,
        [Parameter(Mandatory=$false)]
        [String]$Separator=':',
        [Parameter(Mandatory=$false)]
        [Int]$SplitAt = 1,
        [Parameter(Mandatory=$false)]
        [Switch]$RemoveTheEndingDot
    )

    $Object = New-Object -TypeName psobject

    $Parts = $MessageText.Split($Separator,[System.StringSplitOptions]::RemoveEmptyEntries)

    $PartsCount = $( $Parts | Measure-Object).Count

    $Caption = $($Parts[0]).Trim()

    if ( $PartsCount -gt 1 -and $PartsCount -gt $SplitAt ) {
        $Value = $($Parts[$SplitAt]).Trim()

        if ( $RemoveTheEndingDot.IsPresent -and $Value.ToCharArray()[-1] -eq '.' ) {

            $Value = $Value.Substring(0,$Value.Length -1)

        }

    }
    else {

        $Value = $null

    }

    $object | Add-Member -MemberType NoteProperty -Name Caption -Value $Caption

    $object | Add-Member -MemberType NoteProperty -Name Value -Value $Value

    Write-Output $object

}