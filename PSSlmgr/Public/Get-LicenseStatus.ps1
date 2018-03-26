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
        [Switch]$Details,
        [Parameter(Mandatory=$false)]
        [Switch]$AnsibleMode
    )

    $object = New-Object -TypeName psobject

    if ( $Details.IsPresent) {

        [String]$LicenseProductFields = "Name,Description,GracePeriodRemaining,PartialProductKey,LicenseStatus,LicenseStatusReason,ProductKeyID,ProductKeyChannel,OfflineInstallationId,ProcessorURL,LicenseStatus,LicenseStatusReason,EvaluationEndDate,VLRenewalInterval,VLActivationInterval,KeyManagementServiceLookupDomain,KeyManagementServiceMachine,KeyManagementServicePort,DiscoveredKeyManagementServiceMachineName,DiscoveredKeyManagementServiceMachinePort,DiscoveredKeyManagementServiceMachineIpAddress,KeyManagementServiceProductKeyID,TokenActivationILID,TokenActivationILVID,TokenActivationGrantNumber,TokenActivationCertificateThumbprint,TokenActivationAdditionalInfo,TrustedTime,ADActivationObjectName,ADActivationObjectDN,ADActivationCsvlkPid,ADActivationCsvlkSkuId,VLActivationTypeEnabled,VLActivationType,IAID,AutomaticVMActivationHostMachineName,AutomaticVMActivationLastActivationTime,AutomaticVMActivationHostDigitalPid2,RemainingAppReArmCount,RemainingSkuReArmCount"

        [String]$LicenseServiceFields = "KeyManagementServiceListeningPort,KeyManagementServiceDnsPublishing,KeyManagementServiceLowPriority,ClientMachineId,KeyManagementServiceHostCaching,Version,RemainingWindowsReArmCount"

        [String]$ServiceQueryString = "select $LicenseServiceFields from SoftwareLicensingService"

        $LicenseServiceData = Get-CimInstance -Query $ServiceQueryString

        #$LicenseServiceData

    }
    else {

        [String]$LicenseProductFields = "Name,Description,PartialProductKey,LicenseStatus,LicenseStatusReason,GracePeriodRemaining"

    }

    #55c92734-d682-4d71-983e-d6ec3f16059f is Windows internal ApplicationId

    [String]$ProductQueryString = "select $LicenseProductFields from SoftwareLicensingProduct where ApplicationId = `"55c92734-d682-4d71-983e-d6ec3f16059f`" and PartialProductKey IS NOT NULL"

    $LicenseProductData = Get-CimInstance -Query $ProductQueryString

    #$LicenseProductData

    #This retrieve strings hard-coded in the slmgr.vbs tool
    $Messages = Import-MessageString

    #Below you have to add all calculated fields

    $ResolvedLicenseStatus = Resolve-LicenseStatus -Messages $Messages -LicenseStatus $LicenseProductData.LicenseStatus -LicenseStatusReason $LicenseProductData.LicenseStatusReason

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatus -Value $ResolvedLicenseStatus.LicenseStatus

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatusReason -Value $ResolvedLicenseStatus.LicenseStatusReason

    $object | Add-Member -MemberType NoteProperty -Name LicenseType -Value $ResolvedLicenseType.LicenseType

    $object | Add-Member -MemberType NoteProperty -Name LicenseTypeDescription -Value $ResolvedLicenseType.LicenseTypeDescription

    $GracePeriodRemainingDays = $(Convert-MinutesToDay -Minutes $LicenseProductData.GracePeriodRemaining)

    $object | Add-Member -MemberType NoteProperty -Name GraceRemainingTimeDays -Value $GracePeriodRemainingDays

    $ResolvedGracePeriodRemainingTime = Resolve-GracePeriodRemaining -Messages $Messages -GracePeriodRemainingMinutes $LicenseProductData.GracePeriodRemaining -GracePeriodRemainingDays $GracePeriodRemainingDays -LicenseType $ResolvedLicenseType.LicenseType

    $object | Add-Member -MemberType NoteProperty -Name GraceRemainingTimeDescription -Value $ResolvedGracePeriodRemainingTime.GracePeriodRemainingDescripton

    $ExistingProperties = $(Get-Member -InputObject $object -MemberType NoteProperty).Name

    #The rest of fields for a license product will be added by the loop

    [String[]]$LicenseProductFieldsArray = $LicenseProductFields -Split ','

    ForEach ( $Property in $LicenseProductFieldsArray ) {

        if ($ExistingProperties -notcontains $Property ) {

            $object | Add-Member -MemberType NoteProperty -Name $Property -Value $LicenseProductData.$Property

        }

    }


    #All license service (not products) data are added below
    if ( $Details.IsPresent ) {

        [String[]]$LicenseServiceFieldsArray = $LicenseServiceFields -Split ','

        ForEach ( $Property in $LicenseServiceFieldsArray ) {

            if ($ExistingProperties -notcontains $Property ) {

                $object | Add-Member -MemberType NoteProperty -Name $Property -Value $LicenseServiceData.$Property

            }

        }

    }

    $object

}