Set-StrictMode -Version Latest
Function Resolve-LicenseType {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$Description
    )

    $object = New-Object -TypeName psobject

    if ( $Description -match 'TIMEBASED_' ) {
        $LicenseType = "TBL"
        $LicenseTypeDescription = "Timebased activation" 
    }
    elseif ( $Description -match 'VOLUME_KMSCLIENT' ) {
        $LicenseType = "KMS"
        $LicenseTypeDescription = "Key Management Service" 
    }
    elseif ( $Description -match 'VIRTUAL_MACHINE_ACTIVATION') {
        $LicenseType = "AVMA"
        $LicenseTypeDescription = "Automatic Virtual Machine activation" 
    }
    elseif ( $Description -match 'MAK' ) {
        $LicenseType = "MAK"
        $LicenseTypeDescription ="Multiple Activation Key"
    }
    else {
        $LicenseType = "Other"
        $LicenseTypeDescription = "Other" 
    }

    $object | Add-Member -MemberType NoteProperty -Name LicenseType -Value $LicenseType

    $object | Add-Member -MemberType NoteProperty -Name LicenseTypeDescription -Value $LicenseTypeDescription

    $object

}