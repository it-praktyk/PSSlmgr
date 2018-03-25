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

    $object | Add-Member -MemberType NoteProperty -Name Name -Value $LicenseData.Name

    $object | Add-Member -MemberType NoteProperty -Name Description -Value $LicenseData.Description

    $ResolvedLicenseStatus = Resolve-LicenseStatus -LicenseStatus $LicenseData.LicenseStatus -LicenseStatusReason $LicenseData.LicenseStatusReason

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatus -Value $ResolvedLicenseStatus.LicenseStatus

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatusReason -Value $ResolvedLicenseStatus.LicenseStatusReason

    $object | Add-Member -MemberType NoteProperty -Name PartialProductKey -Value $LicenseData.PartialProductKey


    $object


}