Set-StrictMode -Version Latest
Function Get-LicenseStatus {

    [Cmdletbinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [String]$ApplicationID,
        [Parameter(Mandatory=$false)]
        [Alias('MachineName')]
        [String]$ComputerName="localhost",
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

    if ( [String]::IsNullOrEmpty($ApplicationID) ) {

        #55c92734-d682-4d71-983e-d6ec3f16059f is Windows internal ApplicationId
        $ApplicationIDInternal = '55c92734-d682-4d71-983e-d6ec3f16059f'

    }

    $object = New-Object -TypeName psobject

    if ( $Details.IsPresent) {

        [String]$LicenseProductFields = "Name,Description,GracePeriodRemaining,PartialProductKey,LicenseStatus,LicenseStatusReason,ProductKeyID,ProductKeyChannel,OfflineInstallationId,ProcessorURL,LicenseStatus,LicenseStatusReason,EvaluationEndDate,VLRenewalInterval,VLActivationInterval,KeyManagementServiceLookupDomain,KeyManagementServiceMachine,KeyManagementServicePort,DiscoveredKeyManagementServiceMachineName,DiscoveredKeyManagementServiceMachinePort,DiscoveredKeyManagementServiceMachineIpAddress,KeyManagementServiceProductKeyID,TokenActivationILID,TokenActivationILVID,TokenActivationGrantNumber,TokenActivationCertificateThumbprint,TokenActivationAdditionalInfo,TrustedTime,ADActivationObjectName,ADActivationObjectDN,ADActivationCsvlkPid,ADActivationCsvlkSkuId,VLActivationTypeEnabled,VLActivationType,IAID,AutomaticVMActivationHostMachineName,AutomaticVMActivationLastActivationTime,AutomaticVMActivationHostDigitalPid2,RemainingAppReArmCount,RemainingSkuReArmCount"

        [String]$LicenseServiceFields = "KeyManagementServiceListeningPort,KeyManagementServiceDnsPublishing,KeyManagementServiceLowPriority,ClientMachineId,KeyManagementServiceHostCaching,Version,RemainingWindowsReArmCount"

        [String]$ServiceQueryString = "select $LicenseServiceFields from SoftwareLicensingService"

        $LicenseServiceData = Get-CimInstance -Query $ServiceQueryString

    }
    else {

        [String]$LicenseProductFields = "Name,Description,PartialProductKey,LicenseStatus,LicenseStatusReason,GracePeriodRemaining"

    }

    [String]$ProductQueryString = "select $LicenseProductFields from SoftwareLicensingProduct where ApplicationId = `"$ApplicationIDInternal`" and PartialProductKey IS NOT NULL"

    $LicenseProductData = $(Get-CimSoftwareLicensingProduct -Query $ProductQueryString)

    Try {

        $LicenseProductErrorGlobalInternal = $LicenseProductErrorGlobal

    }
    Catch {

        $LicenseProductErrorGlobalInternal = $null

    }
    

    if ( ($? -ne 0) -and ( $null -ne $LicenseProductErrorGlobalInternal) ) {

        [String]$ExceptionMessage = $($LicenseProductErrorGlobalInternal.Exception | Select-Object -First 1)

        Remove-Variable -Name LicenseProductErrorGlobal -Scope Global -ErrorAction SilentlyContinue

        Throw $ExceptionMessage

    }

    #This retrieve strings hard-coded in the slmgr.vbs tool
    $Messages = Import-MessageString

    #Below you have to add all calculated fields

    $ResolvedLicenseStatus = Resolve-LicenseStatus -Messages $Messages -LicenseStatus $LicenseProductData.LicenseStatus -LicenseStatusReason $LicenseProductData.LicenseStatusReason

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatus -Value $ResolvedLicenseStatus.LicenseStatus

    $object | Add-Member -MemberType NoteProperty -Name LicenseStatusReason -Value $ResolvedLicenseStatus.LicenseStatusReason

    $ResolvedLicenseType = Resolve-LicenseType -Description $LicenseProductData.Description

    $object | Add-Member -MemberType NoteProperty -Name LicenseType -Value $ResolvedLicenseType.LicenseType

    $object | Add-Member -MemberType NoteProperty -Name LicenseTypeDescription -Value $ResolvedLicenseType.LicenseTypeDescription

    if ( $LicenseProductData.GracePeriodRemaining -eq 0 ) {

        GracePeriodRemainingDays = 0

    }
    else {

        $GracePeriodRemainingDays = $(Convert-MinutesToDay -Minutes $LicenseProductData.GracePeriodRemaining)

    }

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