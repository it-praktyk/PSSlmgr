Set-StrictMode -Version Latest
Function Resolve-LicenseStatus {

    #Strings are available also in the file
    #C:\Windows\System32\slmgr\0409\slmgr.ini

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [psobject]$Messages,
        [Parameter(Mandatory=$true)]
        [Int]$LicenseStatus,
        [Parameter(Mandatory=$false)]
        [AllowNull()]
        [Long]$LicenseStatusReason        
    )

    $object = New-Object -TypeName psobject

    $VariableFor5 = $null

    if ( $null -ne $LicenseStatusReason ) {

        [String]$ErrorHex = $([Convert]::ToString($LicenseStatusReason,16)).ToUpper()

        if ( $LicenseStatus -eq 5 ) {

            if ( $ErrorHex -eq 'C004F200' ) {
                $VariableFor5 = $($Messages.L_MsgNotificationErrorReasonNonGenuine).Replace('%ERRCODE%',"0x$ErrorHex")
            }
            elseif ( $ErrorHex -eq 'C004F00' ) {
                $VariableFor5 = $($Messages.L_MsgNotificationErrorReasonExpiration).Replace('%ERRCODE%',"0x$ErrorHex")
            }
            else {
                $VariableFor5 = $($Messages.L_MsgNotificationErrorReasonOther).Replace('%ERRCODE%',"0x$ErrorHex")
            }
        }

    }

    $StatusMessages = @{
        0 = $Messages.L_MsgLicenseStatusUnlicensed_1
        1 = $Messages.L_MsgLicenseStatusLicensed_1
        2 = $Messages.L_MsgLicenseStatusInitialGrace_1
        3 = $Messages.L_MsgLicenseStatusAdditionalGrace_1
        4 = $Messages.L_MsgLicenseStatusNonGenuineGrace_1
        5 = $Messages.L_MsgLicenseStatusNotification_1
        6 = $Messages.L_MsgLicenseStatusExtendedGrace_1
    }

    $StatusReasonMessages = @{
        0 = $null
        1 = $null
        2 = $null
        3 = $null
        4 = $null
        5 = $VariableFor5
        6 = $null
    }

    if ( $LicenseStatus -ge 0 -and $LicenseStatus -le 6 ) {

        $Status = $StatusMessages.Item($LicenseStatus)
        $StatusReason = $StatusReasonMessages.Item($LicenseStatus)

    }
    else {

        $Status = $(Split-MessageText -Message $Messages.L_MsgLicenseStatusUnknown).Value
        $StatusReason = $null

    }

    [String]$MessageText = "License status string: {0}" -f $Status

    Write-Verbose -Message $MessageText

    [String]$MessageText = "A value part of a license status string: {0}" -f $(Split-MessageText -Message $Status).Value

    Write-Verbose -Message $MessageText

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatus -Value $(Split-MessageText -Message $Status).Value

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatusReason -Value $(Split-MessageText -Message $StatusReason -RemoveTheEndingDot).Value

    #$object | Add

    $object

}