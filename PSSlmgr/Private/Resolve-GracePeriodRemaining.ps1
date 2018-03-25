Set-StrictMode -Version Latest
Function Resolve-GracePeriodRemaining {

    [Cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [psobject]$Messages,
        [Parameter(Mandatory=$false)]
        [AllowNull()]
        [Long]$GracePeriodRemainingMinutes,
        [Parameter(Mandatory=$false)]
        [AllowNull()]
        [Long]$GracePeriodRemainingDays,
        [Parameter(Mandatory=$false)]
        [String]$LicenseType
    )

    $object = New-Object -TypeName psobject

    $GracePeriodRemainingDescripton = $null

    if ( $GracePeriodRemainingMinutes -ne 0 ) {

        Switch ( $LicenseType ) {

            'TBL' {
                $GracePeriodRemainingDescripton = $($Messages.L_MsgLicenseStatusTBL_1)
            }
            'AVMA' {
                $GracePeriodRemainingDescripton = $Messages.L_MsgLicenseStatusAVMA_1
            }
            Default {
                $GracePeriodRemainingDescripton = $Messages.L_MsgLicenseStatusVL_1
            }

        }

        $object | Add-Member -MemberType NoteProperty -Name GracePeriodRemainingDescripton -Value $GracePeriodRemainingDescripton.Replace('%MINUTE%',$GracePeriodRemainingMinutes).Replace('%DAY%',$GracePeriodRemainingDays)

    }

    $object

}