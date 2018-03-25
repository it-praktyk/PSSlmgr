Set-StrictMode -Version Latest
Function Get-LicenseStatus {

    [Cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [Alias('MachineName')]
        $ComputerName="localhost",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,
        [Parameter(Mandatory=$false)]
        [Switch]$Detailed,
        [Parameter(Mandatory=$false)]
        [Switch]$AnsibleMode
    )

    $object = New-Object -TypeName psobject

    if ( $Detailed.IsPresent) {

        [String]$LicenseFields = "Name,Description,GracePeriodRemaining,PartialProductKey,LicenseStatus,LicenseStatusReason"

        #SLS = Software licensing service version
        $SLSVersion = $(Get-CimInstance -Query 'select Version from SoftwareLicensingService').Version

    }
    else {

        [String]$LicenseFields = "Name,Description,PartialProductKey,LicenseStatus,LicenseStatusReason,GracePeriodRemaining"

    }

    #55c92734-d682-4d71-983e-d6ec3f16059f is Windows internal ApplicationId

    [String]$QueryString = "select $LicenseFields from SoftwareLicensingProduct where ApplicationId = `"55c92734-d682-4d71-983e-d6ec3f16059f`" and PartialProductKey IS NOT NULL"

    $LicenseData = Get-CimInstance -Query $QueryString

    $LicenseData

    #This retrieve strings hard-coded in the slmgr.vbs tool
    $Messages = Import-MessageString

    $object | Add-Member -MemberType NoteProperty -Name Name -Value $LicenseData.Name

    $object | Add-Member -MemberType NoteProperty -Name Description -Value $LicenseData.Description

    $ResolvedLicenseStatus = Resolve-LicenseStatus -Messages $Messages -LicenseStatus $LicenseData.LicenseStatus -LicenseStatusReason $LicenseData.LicenseStatusReason

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatus -Value $ResolvedLicenseStatus.LicenseStatus

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatusReason -Value $ResolvedLicenseStatus.LicenseStatusReason

    $ResolvedLicenseType = Resolve-LicenseType -Description $LicenseData.Description

    $object | Add-Member -MemberType NoteProperty -Name LicenseType -Value $ResolvedLicenseType.LicenseType

    $object | Add-Member -MemberType NoteProperty -Name LicenseTypeDescription -Value $ResolvedLicenseType.LicenseTypeDescription

    $object | Add-Member -MemberType NoteProperty -Name GraceRemainingTimeMinutes -Value $LicenseData.GracePeriodRemaining

    $GracePeriodRemainingDays = $(Convert-MinutesToDay -Minutes $LicenseData.GracePeriodRemaining)

    $object | Add-Member -MemberType NoteProperty -Name GraceRemainingTimeDays -Value $GracePeriodRemainingDays

    $ResolvedGraceRemainingTime = Resolve-GracePeriodRemaining -Messages $Messages -GracePeriodRemainingMinutes $LicenseData.GracePeriodRemaining -GracePeriodRemainingDays $GracePeriodRemainingDays -LicenseType $ResolvedLicenseType.LicenseType

    $object | Add-Member -MemberType NoteProperty -Name GraceRemainingTimeDescription -Value $ResolvedGraceRemainingTime.GracePeriodRemainingDescripton

    $object | Add-Member -MemberType NoteProperty -Name PartialProductKey -Value $LicenseData.PartialProductKey

    $object

}